defmodule ExPass.Structs.FieldContent do
  @moduledoc """
  Represents a field on a pass.

  A field displays information on the front or back of a pass, such as a customer's name,
  a balance, or an expiration date.

  ## Attributes

  - `attributed_value`: The field's value, which can include HTML markup for enhanced
    formatting or interactivity. It can be a string, number, or ISO 8601 date string.

  ## Examples

      iex> field = ExPass.Structs.FieldContent.new(%{attributed_value: "<a href='http://example.com'>Click here</a>"})
      %ExPass.Structs.FieldContent{attributed_value: "<a href='http://example.com'>Click here</a>"}

      iex> field = ExPass.Structs.FieldContent.new(%{attributed_value: 42})
      %ExPass.Structs.FieldContent{attributed_value: 42}

      iex> field = ExPass.Structs.FieldContent.new(%{attributed_value: "2023-04-15T14:30:00Z"})
      %ExPass.Structs.FieldContent{attributed_value: "2023-04-15T14:30:00Z"}
  """

  use TypedStruct
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
  end

  @doc """
  Creates a new FieldContent struct.

  This function initializes a new FieldContent struct with the given attributes.
  It validates the `attributed_value` using the `ExPass.Utils.Validators.validate_attributed_value/1` function.

  ## Parameters

    * `attrs` - A map of attributes for the FieldContent struct. Defaults to an empty map.

  ## Returns

    * A new `%FieldContent{}` struct.

  ## Raises

    * `ArgumentError` if the `attributed_value` is invalid. The error message will include details about the invalid value and supported types.

  ## Examples

      iex> FieldContent.new(%{attributed_value: "Hello, World!"})
      %FieldContent{attributed_value: "Hello, World!"}

      iex> FieldContent.new(%{attributed_value: 42})
      %FieldContent{attributed_value: 42}

      iex> FieldContent.new(%{attributed_value: DateTime.utc_now()})
      %FieldContent{attributed_value: #DateTime<...>}

      iex> FieldContent.new(%{attributed_value: Date.utc_today()})
      %FieldContent{attributed_value: ~D[...]}

      iex> FieldContent.new(%{attributed_value: "<a href='http://example.com'>Click here</a>"})
      %FieldContent{attributed_value: "<a href='http://example.com'>Click here</a>"}

      iex> FieldContent.new()
      %FieldContent{attributed_value: nil}

  """
  @spec new(map()) :: %__MODULE__{}
  def new(attrs \\ %{}) do
    attrs =
      attrs
      |> validate(:attributed_value, &Validators.validate_attributed_value/1)

    struct!(__MODULE__, attrs)
  end

  defp validate(attrs, key, validator) do
    case validator.(attrs[key]) do
      :ok ->
        attrs

      {:error, reason} ->
        raise ArgumentError, """
        Invalid attributed_value: #{inspect(attrs[key])}
        Reason: #{reason}
        Supported types are: String (including <a></a> tag), number, DateTime and Date
        """
    end
  end
end
