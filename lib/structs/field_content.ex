defmodule ExPass.Structs.FieldContent do
  @moduledoc """
  Represents a field on a pass.

  A field displays information on the front or back of a pass, such as a customer's name,
  a balance, or an expiration date.

  For more details, see the [Apple Developer Documentation](https://developer.apple.com/documentation/walletpasses/passfieldcontent).

  ## Attributes

  - `attributed_value`: The field's value, which can include HTML markup for enhanced
    formatting or interactivity. It can be a string, number, or ISO 8601 date string.
  - `change_message`: A message that describes the change to the field's value.
     It should include the '%@' placeholder for the new value.
  - `currency_code`: The ISO 4217 currency code for the field's value, if applicable.
     This is used when the field represents a monetary amount.
  """

  use TypedStruct

  alias ExPass.Utils.Converter
  alias ExPass.Utils.Validators

  @typedoc """
  The field's attributed value, which may include HTML markup for enhanced
  formatting or interactivity.

  Optional. The attributed value of the field, which can be:

  - A localizable string (e.g., "Welcome to our service")
  - An ISO 8601 date string (e.g., "2023-04-15T14:30:00Z")
  - A number (e.g., 42)

  When both attributed_value and value are present, attribute_value takes
  priority. It supports a limited set of HTML tags,
  primarily for basic text formatting and creating hyperlinks. This allows
  for more dynamic content presentation,
  such as clickable links or emphasized text.

  Note that only a subset of HTML tags are supported, generally restricted
  to simple text formatting and anchor elements.
  Unsupported tags may be removed or escaped in the final pass display.

  Example:
      "<a href='http://example.com'>Click here</a> for more information"

  Note: Unsupported HTML tags may be stripped or escaped when displayed in the pass.
  """
  @type attributed_value() :: String.t() | number() | DateTime.t() | Date.t()

  typedstruct do
    field :attributed_value, attributed_value(), default: nil
    field :change_message, String.t(), default: nil
    field :currency_code, String.t(), default: nil
  end

  @doc """
  Creates a new FieldContent struct.

  This function initializes a new FieldContent struct with the given attributes.
  It validates both the `attributed_value` using the `ExPass.Utils.Validators.validate_attributed_value/1` function
  and the `change_message` using the `ExPass.Utils.Validators.validate_change_message/1` function.

  ## Parameters

    * `attrs` - A map of attributes for the FieldContent struct. Defaults to an empty map.

  ## Returns

    * A new `%FieldContent{}` struct.

  ## Raises

    * `ArgumentError` if the `attributed_value` is invalid. The error message will include details about the invalid value and supported types.
    * `ArgumentError` if the `change_message` is invalid. The error message will include details about the invalid value and the required format.

  ## Examples

      iex> FieldContent.new(%{attributed_value: "Hello, World!"})
      %FieldContent{attributed_value: "Hello, World!", change_message: nil}

      iex> FieldContent.new(%{attributed_value: 42})
      %FieldContent{attributed_value: 42, change_message: nil}

      iex> datetime = DateTime.utc_now()
      iex> field_content = FieldContent.new(%{attributed_value: datetime})
      iex> %FieldContent{attributed_value: ^datetime} = field_content
      iex> field_content.change_message
      nil

      iex> date = Date.utc_today()
      iex> FieldContent.new(%{attributed_value: date})
      %FieldContent{attributed_value: date, change_message: nil}

      iex> FieldContent.new(%{attributed_value: "<a href='http://example.com'>Click here</a>"})
      %FieldContent{attributed_value: "<a href='http://example.com'>Click here</a>", change_message: nil}
  """
  @spec new(map()) :: %__MODULE__{}
  def new(attrs \\ %{}) do
    attrs =
      attrs
      |> Converter.trim_string_values()
      |> validate(:attributed_value, &Validators.validate_attributed_value/1)
      |> validate(:change_message, &Validators.validate_change_message/1)
      |> validate(:currency_code, &Validators.validate_currency_code/1)

    struct!(__MODULE__, attrs)
  end

  defp validate(attrs, key, validator) do
    case validator.(attrs[key]) do
      :ok ->
        attrs

      {:error, reason} ->
        cond do
          key == :attributed_value ->
            raise ArgumentError, """
            Invalid attributed_value: #{inspect(attrs[key])}
            Reason: #{reason}
            Supported types are: String (including <a></a> tag), number, DateTime and Date
            """

          key == :change_message ->
            raise ArgumentError, """
            Invalid change_message: #{inspect(attrs[key])}
            Reason: #{reason}
            The change_message must be a string containing the '%@' placeholder for the new value.
            """

          true ->
            raise ArgumentError, """
            Invalid value for #{key}: #{inspect(attrs[key])}
            Reason: #{reason}
            """
        end
    end
  end

  defimpl Jason.Encoder do
    def encode(field_content, opts) do
      field_content
      |> Map.from_struct()
      |> Enum.reduce(%{}, fn
        {_k, nil}, acc -> acc
        {k, v}, acc -> Map.put(acc, Converter.camelize_key(k), v)
      end)
      |> Jason.Encode.map(opts)
    end
  end
end
