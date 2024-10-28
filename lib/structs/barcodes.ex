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
  - `message`: Required. The message or payload to display as a barcode.
  - `message_encoding`: Optional. The text encoding used for the message. This should be a valid IANA
     character set name. The system uses this to convert the message
     from a string to the data representation rendered as a barcode.

     Supported formats include:
      - US-ASCII
      - ISO-8859-1
      - ISO-8859-2
      - ISO-8859-3
      - ISO-8859-4
      - ISO-8859-5
      - ISO-8859-6
      - ISO-8859-7
      - ISO-8859-8
      - ISO-8859-9
      - ISO-8859-10
      - Shift_JIS
      - EUC-JP
      - ISO-2022-KR
      - EUC-KR
      - ISO-2022-JP
      - ISO-2022-JP-2
      - ISO-8859-6-E
      - ISO-8859-6-I
      - ISO-8859-8-E
      - ISO-8859-8-I
      - GB2312
      - Big5
      - KOI8-R

    For a complete list, refer to the IANA Character Sets registry at
    https://www.iana.org/assignments/character-sets/character-sets.xhtml.
  """

  use ExPass.Structs.Base
  use TypedStruct

  alias ExPass.Utils.Validators

  typedstruct do
    field :alt_text, String.t()
    field :format, String.t(), enforce: true
    field :message, String.t(), enforce: true
    field :message_encoding, String.t(), enforce: true
  end

  @doc """
  Creates a new Barcodes struct.

  ## Parameters

    * `attrs` - A map of attributes for the Barcodes struct. The map can include the following keys:
      * `:alt_text` - (Optional) Text displayed near the barcode. For example, a human-readable version of the barcode data.
      * `:format` - (Required) The format of the barcode. Must be one of: "PKBarcodeFormatQR", "PKBarcodeFormatPDF417", "PKBarcodeFormatAztec", or "PKBarcodeFormatCode128".
      * `:message` - (Required) The message or payload to display as a barcode.
      * `:message_encoding` - (Required) The text encoding used for the message. Must be a valid IANA character set name.

  ## Returns

    * A new `%Barcodes{}` struct.

  ## Examples

      iex> Barcodes.new(%{
      ...>   alt_text: "Scan this QR code",
      ...>   format: "PKBarcodeFormatQR",
      ...>   message: "https://example.com/ticket/123456789",
      ...>   message_encoding: "ISO-8859-1"
      ...> })
      %Barcodes{
        alt_text: "Scan this QR code",
        format: "PKBarcodeFormatQR",
        message: "https://example.com/ticket/123456789",
        message_encoding: "ISO-8859-1"
      }

      iex> Barcodes.new(%{
      ...>   format: "PKBarcodeFormatPDF417",
      ...>   message: "PASS-1234-5678-90",
      ...>   message_encoding: "US-ASCII"
      ...> })
      %Barcodes{
        alt_text: nil,
        format: "PKBarcodeFormatPDF417",
        message: "PASS-1234-5678-90",
        message_encoding: "US-ASCII"
      }

  """
  @spec new(map()) :: %__MODULE__{}
  def new(attrs \\ %{}) do
    attrs =
      attrs
      |> Converter.trim_string_values()
      |> validate(:alt_text, &Validators.validate_optional_string(&1, :alt_text))
      |> validate(:format, &Validators.validate_barcode_format/1)
      |> validate(:message, &Validators.validate_required_string(&1, :message))
      |> validate(:message_encoding, &Validators.validate_message_encoding/1)

    struct!(__MODULE__, attrs)
  end
end
