defmodule ExPass.Structs.PassFields.PrimaryFields do
  @moduledoc """
  Represents the primary fields displayed on the front of a pass.

  Primary fields are the most prominent fields on a pass and display the most important
  information. For example, on a boarding pass, the primary fields might show the
  departure and arrival cities. On an event ticket, they might display the event name.

  PrimaryFields inherits all properties from `ExPass.Structs.FieldContent` without additional fields.

  For more details, see the [Apple Developer Documentation](https://developer.apple.com/documentation/walletpasses/pass/primaryfields).

  ## Attributes

  All attributes from `ExPass.Structs.FieldContent` are inherited:
  - `attributed_value` - The field's attributed value with HTML markup support
  - `change_message` - Message describing changes to the field's value
  - `currency_code` - ISO 4217 currency code for monetary values
  - `data_detector_types` - List of data detectors for automatic link conversion
  - `date_style` - Style for date display
  - `ignores_time_zone` - Boolean controlling time zone display
  - `is_relative` - Boolean for relative date display
  - `key` - Required unique field identifier
  - `label` - Optional field label text
  - `number_style` - Style for number display
  - `text_alignment` - Text alignment within the field
  - `time_style` - Style for time display
  - `value` - Required field value
  """

  use ExPass.Structs.Base
  use TypedStruct

  alias ExPass.Structs.FieldContent
  alias ExPass.Utils.Converter
  alias ExPass.Utils.Validators

  typedstruct do
    # Inherit all fields from FieldContent
    field :attributed_value, FieldContent.attributed_value(), default: nil
    field :change_message, String.t(), default: nil
    field :currency_code, String.t(), default: nil
    field :data_detector_types, FieldContent.data_detector_types(), default: nil
    field :date_style, FieldContent.date_style(), default: nil
    field :ignores_time_zone, boolean(), default: nil
    field :is_relative, boolean(), default: nil
    field :key, String.t(), enforce: true
    field :label, String.t(), default: nil
    field :number_style, FieldContent.number_style(), default: nil
    field :text_alignment, FieldContent.text_alignment(), default: nil
    field :time_style, FieldContent.time_style(), default: nil
    field :value, FieldContent.value(), enforce: true
  end

  @doc """
  Creates a new PrimaryFields struct.

  This function initializes a new PrimaryFields struct with the given attributes.
  It validates all inherited fields from FieldContent.

  ## Parameters

    * `attrs` - A map of attributes for the PrimaryFields struct. Defaults to an empty map.

  ## Returns

    * A new `%PrimaryFields{}` struct.

  ## Raises

    * `ArgumentError` if any of the attributes are invalid.

  ## Examples

      iex> PrimaryFields.new(%{key: "origin", value: "SFO"})
      %PrimaryFields{key: "origin", value: "SFO"}

      iex> PrimaryFields.new(%{key: "destination", value: "JFK", label: "New York"})
      %PrimaryFields{key: "destination", value: "JFK", label: "New York"}

      iex> PrimaryFields.new(%{key: "balance", value: 125.50, currency_code: "USD", number_style: "PKNumberStyleDecimal"})
      %PrimaryFields{key: "balance", value: 125.50, currency_code: "USD", number_style: "PKNumberStyleDecimal"}
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
      |> validate(:date_style, &Validators.validate_date_style(&1, :date_style))
      |> validate(:ignores_time_zone, &Validators.validate_boolean_field(&1, :ignores_time_zone))
      |> validate(:is_relative, &Validators.validate_boolean_field(&1, :is_relative))
      |> validate(:key, &Validators.validate_required_string(&1, :key))
      |> validate(:label, &Validators.validate_optional_string(&1, :label))
      |> validate(:number_style, &Validators.validate_number_style/1)
      |> validate(:text_alignment, &Validators.validate_text_alignment/1)
      |> validate(:time_style, &Validators.validate_date_style(&1, :time_style))
      |> validate(:value, &Validators.validate_required_value(&1, :value))

    struct!(__MODULE__, attrs)
  end
end
