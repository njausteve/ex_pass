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

  - `data_detector_types`: A list of data detectors to apply to the field's value.
     These detectors can automatically convert certain types of data into tappable links.

     Supported values are:
     * "PKDataDetectorTypePhoneNumber" - Detects phone numbers
     * "PKDataDetectorTypeLink" - Detects URLs and web links
     * "PKDataDetectorTypeAddress" - Detects physical addresses
     * "PKDataDetectorTypeCalendarEvent" - Detects calendar events

  - `date_style`: The style of the date to display in the field.
     Supported values are:
     * "PKDateStyleNone"
     * "PKDateStyleShort"
     * "PKDateStyleMedium"
     * "PKDateStyleLong"
     * "PKDateStyleFull"
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

  @typedoc """
  The list of data detector types to apply to the field's value.

  Optional. Valid values are:
  - "PKDataDetectorTypePhoneNumber"
  - "PKDataDetectorTypeLink"
  - "PKDataDetectorTypeAddress"
  - "PKDataDetectorTypeCalendarEvent"

  These detectors can automatically convert certain types of data into tappable links.
  """
  @type data_detector_types() :: list(String.t())

  @typedoc """
  The style of the date to display in the field.

  Optional. Valid values are:
  - "PKDateStyleNone"
  - "PKDateStyleShort"
  - "PKDateStyleMedium"
  - "PKDateStyleLong"
  - "PKDateStyleFull"
  """
  @type date_style() :: String.t()

  typedstruct do
    field :attributed_value, attributed_value(), default: nil
    field :change_message, String.t(), default: nil
    field :currency_code, String.t(), default: nil
    field :data_detector_types, data_detector_types(), default: nil
    field :date_style, date_style(), default: nil
  end

  @doc """
  Creates a new FieldContent struct.

  This function initializes a new FieldContent struct with the given attributes.
  It validates the `attributed_value`, `change_message`, `currency_code`, `data_detector_types`, and `date_style`.

  ## Parameters

    * `attrs` - A map of attributes for the FieldContent struct. Defaults to an empty map.

  ## Returns

    * A new `%FieldContent{}` struct.

  ## Raises

    * `ArgumentError` if any of the attributes are invalid. The error message will include details about the invalid value and supported types.

  ## Examples

      iex> FieldContent.new(%{attributed_value: "Hello, World!"})
      %FieldContent{attributed_value: "Hello, World!", change_message: nil, currency_code: nil, data_detector_types: nil, date_style: nil}

      iex> FieldContent.new(%{attributed_value: 42, data_detector_types: ["PKDataDetectorTypePhoneNumber"], date_style: "PKDateStyleShort"})
      %FieldContent{attributed_value: 42, change_message: nil, currency_code: nil, data_detector_types: ["PKDataDetectorTypePhoneNumber"], date_style: "PKDateStyleShort"}

      iex> datetime = DateTime.utc_now()
      iex> field_content = FieldContent.new(%{attributed_value: datetime, currency_code: "USD", date_style: "PKDateStyleLong"})
      iex> %FieldContent{attributed_value: ^datetime, currency_code: "USD", date_style: "PKDateStyleLong"} = field_content
      iex> field_content.change_message
      nil

      iex> FieldContent.new(%{attributed_value: "<a href='http://example.com'>Click here</a>", data_detector_types: ["PKDataDetectorTypeLink"], date_style: "PKDateStyleFull"})
      %FieldContent{attributed_value: "<a href='http://example.com'>Click here</a>", change_message: nil, currency_code: nil, data_detector_types: ["PKDataDetectorTypeLink"], date_style: "PKDateStyleFull"}
  """
  @spec new(map()) :: %__MODULE__{}
  def new(attrs \\ %{}) do
    attrs =
      attrs
      |> Converter.trim_string_values()
      |> validate(:attributed_value, &Validators.validate_attributed_value/1)
      |> validate(:change_message, &Validators.validate_change_message/1)
      |> validate(:currency_code, &Validators.validate_currency_code/1)
      |> validate(:data_detector_types, &Validators.validate_data_detector_types/1)
      |> validate(:date_style, &Validators.validate_date_style/1)

    struct!(__MODULE__, attrs)
  end

  defp validate(attrs, key, validator) do
    case validator.(attrs[key]) do
      :ok ->
        attrs

      {:error, reason} ->
        error_message = get_error_message(key, attrs[key], reason)
        raise ArgumentError, error_message
    end
  end

  defp get_error_message(key, value, reason) do
    base_message = """
    Invalid #{key}: #{inspect(value)}
    Reason: #{reason}
    """

    additional_info =
      case key do
        :attributed_value ->
          "Supported types are: String (including <a></a> tag), number, DateTime and Date"

        :change_message ->
          "The change_message must be a string containing the '%@' placeholder for the new value."

        :data_detector_types ->
          "data_detector_types must be a list of valid detector type strings."

        :date_style ->
          "Supported values are: PKDateStyleNone, PKDateStyleShort, PKDateStyleMedium, PKDateStyleLong, PKDateStyleFull"

        _ ->
          ""
      end

    base_message <> additional_info
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
