defmodule ExPass.Structs.PassFields.AuxiliaryFields do
  @moduledoc """
  Represents auxiliary fields displayed on a pass.

  Auxiliary fields are displayed below the primary and secondary fields on the front of the pass.
  They inherit all properties from `ExPass.Structs.FieldContent` and add a `row` field for
  positioning.

  For more details, see the [Apple Developer Documentation](https://developer.apple.com/documentation/walletpasses/pass/auxiliaryfields).

  ## Attributes

  All attributes from `ExPass.Structs.FieldContent` are inherited, plus:

  - `row`: The row in the auxiliary field area. A value of 0 places the field in the first row,
    and a value of 1 places it in the second row. The default is 0.
  """

  use ExPass.Structs.Base
  use TypedStruct

  alias ExPass.Structs.FieldContent
  alias ExPass.Utils.Converter
  alias ExPass.Utils.Validators

  @typedoc """
  The row position for the auxiliary field.

  Optional. Valid values are 0 or 1:
  - 0: Places the field in the first row (default)
  - 1: Places the field in the second row
  """
  @type row() :: 0 | 1

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

    # Additional field specific to AuxiliaryFields
    field :row, row(), default: 0
  end

  @doc """
  Creates a new AuxiliaryFields struct.

  This function initializes a new AuxiliaryFields struct with the given attributes.
  It validates all inherited fields from FieldContent plus the `row` field.

  ## Parameters

    * `attrs` - A map of attributes for the AuxiliaryFields struct. Defaults to an empty map.

  ## Returns

    * A new `%AuxiliaryFields{}` struct.

  ## Raises

    * `ArgumentError` if any of the attributes are invalid. The error message will include details about the invalid value and supported types.

  ## Examples

      iex> AuxiliaryFields.new(%{key: "aux1", value: "Auxiliary Info"})
      %AuxiliaryFields{key: "aux1", value: "Auxiliary Info", row: 0}

      iex> AuxiliaryFields.new(%{key: "aux2", value: "Second Row", row: 1})
      %AuxiliaryFields{key: "aux2", value: "Second Row", row: 1}

      iex> AuxiliaryFields.new(%{key: "aux3", value: 100, label: "Points", row: 0})
      %AuxiliaryFields{key: "aux3", value: 100, label: "Points", row: 0}
  """
  @spec new(map()) :: %__MODULE__{}
  def new(attrs \\ %{}) do
    # Set default for row if not provided
    attrs = Map.put_new(attrs, :row, 0)
    
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
      |> validate(:row, &validate_row/1)

    struct!(__MODULE__, attrs)
  end

  @spec validate_row(any()) :: :ok | {:error, String.t()}
  defp validate_row(value) when value in [0, 1], do: :ok
  defp validate_row(nil), do: :ok
  defp validate_row(_value) do
    {:error, "row must be 0 or 1"}
  end
end