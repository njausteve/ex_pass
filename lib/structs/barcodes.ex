defmodule ExPass.Structs.Barcodes do
  @moduledoc """
  Represents a barcode on a pass.

  A barcode encodes information that can be scanned by devices. It can be used for various purposes,
  such as ticket validation, loyalty card identification, or linking to additional information.

  For more details, see the [Apple Developer Documentation](https://developer.apple.com/documentation/walletpasses/pass/barcodes).

  ## Attributes

  - `alt_text`: Optional. Text displayed near the barcode. For example, a human-readable version of the barcode data.
  - `format`: Required. The format of the barcode. Possible values are: PKBarcodeFormatQR, PKBarcodeFormatPDF417, PKBarcodeFormatAztec, PKBarcodeFormatCode128.
    Note: The barcode format PKBarcodeFormatCode128 isn't supported for watchOS.
  """

  use TypedStruct

  alias ExPass.Utils.Converter
  alias ExPass.Utils.Validators

  typedstruct do
    field :alt_text, String.t()
    field :format, String.t(), enforce: true
  end

  @doc """
  Creates a new Barcodes struct.

  ## Parameters

    * `attrs` - A map of attributes for the Barcodes struct.

  ## Returns

    * A new Barcodes struct.

  ## Examples

      iex> Barcodes.new(%{alt_text: "Scan this QR code", format: "PKBarcodeFormatQR"})
      %Barcodes{alt_text: "Scan this QR code", format: "PKBarcodeFormatQR"}

  """
  @spec new(map()) :: %__MODULE__{}
  def new(attrs \\ %{}) do
    attrs =
      attrs
      |> Converter.trim_string_values()
      |> validate(:alt_text, &Validators.validate_optional_string(&1, :alt_text))
      |> validate(:format, &Validators.validate_barcode_format/1)

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

  defimpl Jason.Encoder, for: __MODULE__ do
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
