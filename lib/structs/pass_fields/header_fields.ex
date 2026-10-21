defmodule ExPass.Structs.PassFields.HeaderFields do
  @moduledoc """
  Represents header fields displayed on a pass.

  Header fields are displayed at the top of the pass and remain visible when the pass is
  stacked with other passes. They inherit all properties from `ExPass.Structs.FieldContent`.

  For more details, see the [Apple Developer Documentation](https://developer.apple.com/documentation/walletpasses/pass/headerfields).

  ## Attributes

  All attributes from `ExPass.Structs.FieldContent` are inherited.
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
  Creates a new HeaderFields struct.

  This function initializes a new HeaderFields struct with the given attributes.
  It validates all inherited fields from FieldContent.

  ## Parameters

    * `attrs` - A map of attributes for the HeaderFields struct. Defaults to an empty map.

  ## Returns

    * A new `%HeaderFields{}` struct.

  ## Raises

    * `ArgumentError` if any of the attributes are invalid. The error message will include details about the invalid value and supported types.

  ## Examples

      iex> HeaderFields.new(%{key: "header1", value: "Header Info"})
      %HeaderFields{key: "header1", value: "Header Info"}

      iex> HeaderFields.new(%{key: "header2", value: "Gate 5", label: "Gate"})
      %HeaderFields{key: "header2", value: "Gate 5", label: "Gate"}

      iex> HeaderFields.new(%{key: "header3", value: 100, label: "Points"})
      %HeaderFields{key: "header3", value: 100, label: "Points"}

      iex> HeaderFields.new(%{key: "header4", value: "Header", text_alignment: "InvalidAlignment"})
      ** (ArgumentError) Invalid text_alignment: InvalidAlignment. Supported values are: PKTextAlignmentLeft, PKTextAlignmentCenter, PKTextAlignmentRight, PKTextAlignmentNatural
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
