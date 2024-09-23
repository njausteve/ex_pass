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
     By default, all data detectors are applied. To use no data detectors, specify an empty list.

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

  - `ignores_time_zone`: A Boolean value that controls the time zone for the time and date to display in the field.
     The default value is false, which displays the time and date using the current device's time zone.
     If set to true, the time and date appear in the time zone associated with the date and time of value.
     This key doesn't affect the pass relevance calculation.

  - `is_relative`: A Boolean value that controls whether the date appears as a relative date.
     The default value is false, which displays the date as an absolute date.
     This key doesn't affect the pass relevance calculation.

  - `key`: A unique key that identifies a field in the pass. This field is required.

  - `label`: The text for a field label. This field is optional.

  - `number_style`: The style of the number to display in the field.
     Supported values are:
     * "PKNumberStyleDecimal"
     * "PKNumberStylePercent"
     * "PKNumberStyleScientific"
     * "PKNumberStyleSpellOut"
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
  By default, all data detectors are applied. To use no data detectors, specify an empty list.
  """
  @type data_detector_types() :: list(String.t()) | []

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

  @typedoc """
  The style of the number to display in the field.

  Optional. Valid values are:
  - "PKNumberStyleDecimal"
  - "PKNumberStylePercent"
  - "PKNumberStyleScientific"
  - "PKNumberStyleSpellOut"
  """
  @type number_style() :: String.t()

  typedstruct do
    field :attributed_value, attributed_value(), default: nil
    field :change_message, String.t(), default: nil
    field :currency_code, String.t(), default: nil
    field :data_detector_types, data_detector_types(), default: nil
    field :date_style, date_style(), default: nil
    field :ignores_time_zone, boolean(), default: nil
    field :is_relative, boolean(), default: nil
    field :key, String.t(), enforce: true
    field :label, String.t(), default: nil
    field :number_style, number_style(), default: nil
  end

  @doc """
  Creates a new FieldContent struct.

  This function initializes a new FieldContent struct with the given attributes.
  It validates the following fields:
  • attributed_value
  • change_message
  • currency_code
  • data_detector_types
  • date_style
  • ignores_time_zone
  • is_relative
  • key
  • label
  • number_style

  ## Parameters

    * `attrs` - A map of attributes for the FieldContent struct. Defaults to an empty map.

  ## Returns

    * A new `%FieldContent{}` struct.

  ## Raises

    * `ArgumentError` if any of the attributes are invalid. The error message will include details about the invalid value and supported types.

  ## Examples

      iex> FieldContent.new(%{key: "field1", attributed_value: "Hello, World!"})
      %FieldContent{key: "field1", attributed_value: "Hello, World!", change_message: nil, currency_code: nil, data_detector_types: nil, date_style: nil, ignores_time_zone: nil, is_relative: nil, label: nil, number_style: nil}

      iex> FieldContent.new(%{key: "field2", attributed_value: 42, data_detector_types: ["PKDataDetectorTypePhoneNumber"], date_style: "PKDateStyleShort", ignores_time_zone: true, is_relative: false, number_style: "PKNumberStyleDecimal"})
      %FieldContent{key: "field2", attributed_value: 42, change_message: nil, currency_code: nil, data_detector_types: ["PKDataDetectorTypePhoneNumber"], date_style: "PKDateStyleShort", ignores_time_zone: true, is_relative: false, label: nil, number_style: "PKNumberStyleDecimal"}

      iex> datetime = ~U[2023-04-15 14:30:00Z]
      iex> field_content = FieldContent.new(%{key: "field3", attributed_value: datetime, currency_code: "USD", date_style: "PKDateStyleLong", ignores_time_zone: true, is_relative: true})
      iex> %FieldContent{key: "field3", attributed_value: ^datetime, currency_code: "USD", date_style: "PKDateStyleLong", ignores_time_zone: true, is_relative: true} = field_content
      iex> field_content.change_message
      nil

      iex> FieldContent.new(%{key: "field4", attributed_value: "<a href='http://example.com'>Click here</a>", data_detector_types: ["PKDataDetectorTypeLink"], date_style: "PKDateStyleFull", is_relative: false, number_style: "PKNumberStylePercent"})
      %FieldContent{key: "field4", attributed_value: "<a href='http://example.com'>Click here</a>", change_message: nil, currency_code: nil, data_detector_types: ["PKDataDetectorTypeLink"], date_style: "PKDateStyleFull", ignores_time_zone: nil, is_relative: false, label: nil, number_style: "PKNumberStylePercent"}

      iex> FieldContent.new(%{key: "field5", attributed_value: "No detectors", data_detector_types: [], change_message: "Updated to %@", ignores_time_zone: true, is_relative: true, label: "Field Label", number_style: "PKNumberStyleScientific"})
      %FieldContent{key: "field5", attributed_value: "No detectors", change_message: "Updated to %@", currency_code: nil, data_detector_types: [], date_style: nil, ignores_time_zone: true, is_relative: true, label: "Field Label", number_style: "PKNumberStyleScientific"}
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
      |> validate(:ignores_time_zone, &Validators.validate_boolean_field(&1, :ignores_time_zone))
      |> validate(:is_relative, &Validators.validate_boolean_field(&1, :is_relative))
      |> validate(:key, &Validators.validate_required_string(&1, :key))
      |> validate(:label, &Validators.validate_optional_string(&1, :label))
      |> validate(:number_style, &Validators.validate_number_style/1)

    struct!(__MODULE__, attrs)
  end

  defp validate(attrs, key, validator) do
    case validator.(attrs[key]) do
      :ok ->
        attrs

      {:error, reason} ->
        raise ArgumentError, reason
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
