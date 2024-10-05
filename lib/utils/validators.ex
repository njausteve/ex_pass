defmodule ExPass.Utils.Validators do
  @moduledoc """
  Provides validation functions for ExPass data types.

  This module contains utility functions to validate different types of data
  used in pass creation and management, ensuring they meet required formats
  and constraints.

  These validators are primarily used internally by other ExPass modules.
  """

  @currency_codes [
    "AED",
    "AFN",
    "ALL",
    "AMD",
    "ANG",
    "AOA",
    "ARS",
    "AUD",
    "AWG",
    "AZN",
    "BAM",
    "BBD",
    "BDT",
    "BGN",
    "BHD",
    "BIF",
    "BMD",
    "BND",
    "BOB",
    "BOV",
    "BRL",
    "BSD",
    "BTN",
    "BWP",
    "BYN",
    "BZD",
    "CAD",
    "CDF",
    "CHE",
    "CHF",
    "CHW",
    "CLF",
    "CLP",
    "CNY",
    "COP",
    "COU",
    "CRC",
    "CUP",
    "CVE",
    "CZK",
    "DJF",
    "DKK",
    "DOP",
    "DZD",
    "EGP",
    "ERN",
    "ETB",
    "EUR",
    "FJD",
    "FKP",
    "GBP",
    "GEL",
    "GHS",
    "GIP",
    "GMD",
    "GNF",
    "GTQ",
    "GYD",
    "HKD",
    "HNL",
    "HTG",
    "HUF",
    "IDR",
    "ILS",
    "INR",
    "IQD",
    "IRR",
    "ISK",
    "JMD",
    "JOD",
    "JPY",
    "KES",
    "KGS",
    "KHR",
    "KMF",
    "KPW",
    "KRW",
    "KWD",
    "KYD",
    "KZT",
    "LAK",
    "LBP",
    "LKR",
    "LRD",
    "LSL",
    "LYD",
    "MAD",
    "MDL",
    "MGA",
    "MKD",
    "MMK",
    "MNT",
    "MOP",
    "MRU",
    "MUR",
    "MVR",
    "MWK",
    "MXN",
    "MXV",
    "MYR",
    "MZN",
    "NAD",
    "NGN",
    "NIO",
    "NOK",
    "NPR",
    "NZD",
    "OMR",
    "PAB",
    "PEN",
    "PGK",
    "PHP",
    "PKR",
    "PLN",
    "PYG",
    "QAR",
    "RON",
    "RSD",
    "RUB",
    "RWF",
    "SAR",
    "SBD",
    "SCR",
    "SDG",
    "SEK",
    "SGD",
    "SHP",
    "SLE",
    "SOS",
    "SRD",
    "SSP",
    "STN",
    "SVC",
    "SYP",
    "SZL",
    "THB",
    "TJS",
    "TMT",
    "TND",
    "TOP",
    "TRY",
    "TTD",
    "TWD",
    "TZS",
    "UAH",
    "UGX",
    "USD",
    "USN",
    "UYI",
    "UYU",
    "UYW",
    "UZS",
    "VED",
    "VES",
    "VND",
    "VUV",
    "WST",
    "XAF",
    "XAG",
    "XAU",
    "XBA",
    "XBB",
    "XBC",
    "XBD",
    "XCD",
    "XDR",
    "XOF",
    "XPD",
    "XPF",
    "XPT",
    "XSU",
    "XTS",
    "XUA",
    "XXX",
    "YER",
    "ZAR",
    "ZMW",
    "ZWG",
    "ZWL"
  ]
  @valid_currency_codes MapSet.new(@currency_codes)

  @valid_detector_types [
    "PKDataDetectorTypePhoneNumber",
    "PKDataDetectorTypeLink",
    "PKDataDetectorTypeAddress",
    "PKDataDetectorTypeCalendarEvent"
  ]

  @valid_date_styles [
    "PKDateStyleNone",
    "PKDateStyleShort",
    "PKDateStyleMedium",
    "PKDateStyleLong",
    "PKDateStyleFull"
  ]

  @valid_number_styles [
    "PKNumberStyleDecimal",
    "PKNumberStylePercent",
    "PKNumberStyleScientific",
    "PKNumberStyleSpellOut"
  ]

  @valid_text_alignments [
    "PKTextAlignmentLeft",
    "PKTextAlignmentCenter",
    "PKTextAlignmentRight",
    "PKTextAlignmentNatural"
  ]

  @valid_barcode_formats [
    "PKBarcodeFormatQR",
    "PKBarcodeFormatPDF417",
    "PKBarcodeFormatAztec",
    "PKBarcodeFormatCode128"
  ]

  @doc """
  Validates the type of the attributed value.

  This function checks if the given value is of a valid type for an attributed value.
  Valid types include numbers, strings, DateTime, and Date.

  ## Parameters

    * `value` - The value to be validated.

  ## Returns

    * `:ok` if the value is of a valid type.
    * `{:error, reason}` if the value is not of a valid type, where reason is a string explaining the error.

  ## Examples

      iex> validate_attributed_value(42)
      :ok

      iex> validate_attributed_value("string")
      :ok

      iex> validate_attributed_value(DateTime.utc_now())
      :ok

      iex> validate_attributed_value(Date.utc_today())
      :ok

      iex> validate_attributed_value(%{})
      {:error, "Invalid attributed_value type. Supported types are: String (including <a></a> tag), number, DateTime, and Date"}

  """
  @spec validate_attributed_value(String.t() | number() | DateTime.t() | Date.t() | nil) ::
          :ok | {:error, String.t()}
  def validate_attributed_value(nil), do: :ok
  def validate_attributed_value(value) when is_number(value), do: :ok

  def validate_attributed_value(value) when is_binary(value) do
    if contains_unsupported_html_tags?(value) do
      {:error,
       "Invalid attributed_value type. Supported types are: String (including <a></a> tag), number, DateTime, and Date"}
    else
      :ok
    end
  end

  def validate_attributed_value(%DateTime{}), do: :ok
  def validate_attributed_value(%Date{}), do: :ok

  def validate_attributed_value(_),
    do:
      {:error,
       "Invalid attributed_value type. Supported types are: String (including <a></a> tag), number, DateTime, and Date"}

  @doc """
  Validates the change_message field.

  The change_message must be a string containing the '%@' placeholder for the new value.

  ## Returns

    * `:ok` if the value is a valid change_message string.
    * `{:error, reason}` if the value is not valid, where reason is a string explaining the error.

  ## Examples

      iex> validate_change_message("Gate changed to %@")
      :ok

      iex> validate_change_message("Invalid message without placeholder")
      {:error, "The change_message must be a string containing the '%@' placeholder for the new value."}

      iex> validate_change_message(nil)
      :ok

      iex> validate_change_message(42)
      {:error, "The change_message must be a string containing the '%@' placeholder for the new value."}

  """
  @spec validate_change_message(String.t() | nil) :: :ok | {:error, String.t()}
  def validate_change_message(nil), do: :ok

  def validate_change_message(value) when is_binary(value) do
    if String.contains?(value, "%@") do
      :ok
    else
      {:error,
       "The change_message must be a string containing the '%@' placeholder for the new value."}
    end
  end

  def validate_change_message(_),
    do:
      {:error,
       "The change_message must be a string containing the '%@' placeholder for the new value."}

  @doc """
  Validates the currency_code field.

  The currency_code must be a valid ISO 4217 currency code string or atom.

  ## Returns

    * `:ok` if the value is a valid ISO 4217 currency code string or atom.
    * `{:error, reason}` if the value is not valid, where reason is a string explaining the error.

  ## Examples

      iex> validate_currency_code("USD")
      :ok

      iex> validate_currency_code(:EUR)
      :ok

      iex> validate_currency_code("INVALID")
      {:error, "Invalid currency code INVALID"}

      iex> validate_currency_code(nil)
      :ok

      iex> validate_currency_code(123)
      {:error, "Currency code must be a string or atom"}

  """
  @spec validate_currency_code(String.t() | atom() | nil) :: :ok | {:error, String.t()}
  def validate_currency_code(nil), do: :ok

  def validate_currency_code(value) when is_binary(value) or is_atom(value) do
    value_string = to_string(value)

    if MapSet.member?(@valid_currency_codes, value_string) do
      :ok
    else
      {:error, "Invalid currency code #{value_string}"}
    end
  end

  def validate_currency_code(_), do: {:error, "Currency code must be a string or atom"}

  @doc """
  Validates the data_detector_types field.

  The data_detector_types must be a list of valid detector type strings.

  ## Returns

    * `:ok` if the value is a valid list of detector types or nil.
    * `{:error, reason}` if the value is not valid, where reason is a string explaining the error.

  ## Examples

      iex> validate_data_detector_types(["PKDataDetectorTypePhoneNumber", "PKDataDetectorTypeLink"])
      :ok

      iex> validate_data_detector_types([])
      :ok

      iex> validate_data_detector_types(nil)
      :ok

      iex> validate_data_detector_types(["InvalidDetector"])
      {:error, "Invalid data_detector_types: InvalidDetector. Supported values are: PKDataDetectorTypePhoneNumber, PKDataDetectorTypeLink, PKDataDetectorTypeAddress, PKDataDetectorTypeCalendarEvent"}

      iex> validate_data_detector_types("PKDataDetectorTypePhoneNumber")
      {:error, "data_detector_types must be a list"}

  """
  @spec validate_data_detector_types([String.t()] | nil) :: :ok | {:error, String.t()}
  def validate_data_detector_types(nil), do: :ok
  def validate_data_detector_types([]), do: :ok

  def validate_data_detector_types(types) when is_list(types) do
    validate_inclusion_list(types, @valid_detector_types, "data_detector_types")
  end

  def validate_data_detector_types(_), do: {:error, "data_detector_types must be a list"}

  @doc """
  Validates the date_style field.

  The date_style must be a valid date style string.

  ## Parameters

    * `value` - The value to validate.
    * `key` - The key for the date_style field in the map.

  ## Returns

    * `:ok` if the value is a valid date style string or nil.
    * `{:error, reason}` if the value is not valid, where reason is a string explaining the error.

  ## Examples

      iex> validate_date_style("PKDateStyleShort", :date_style)
      :ok

      iex> validate_date_style(nil, :date_style)
      :ok

      iex> validate_date_style("InvalidStyle", :date_style)
      {:error, "Invalid date_style: InvalidStyle. Supported values are: PKDateStyleNone, PKDateStyleShort, PKDateStyleMedium, PKDateStyleLong, PKDateStyleFull"}

      iex> validate_date_style(42, :date_style)
      {:error, "date_style must be a string"}

  """
  @spec validate_date_style(String.t() | nil, atom()) :: :ok | {:error, String.t()}
  def validate_date_style(value, key) do
    case value do
      nil -> :ok
      style when is_binary(style) -> validate_inclusion(style, @valid_date_styles, to_string(key))
      _ -> {:error, "#{key} must be a string"}
    end
  end

  @doc """
  Validates a boolean field.

  The field must be a boolean value or nil.

  ## Parameters

    * `value` - The value to validate.
    * `field_name` - The name of the field being validated as an atom.

  ## Returns

    * `:ok` if the value is a valid boolean or nil.
    * `{:error, reason}` if the value is not valid, where reason is a string explaining the error.

  ## Examples

      iex> validate_boolean_field(true, :ignores_time_zone)
      :ok

      iex> validate_boolean_field(false, :is_relative)
      :ok

      iex> validate_boolean_field(nil, :ignores_time_zone)
      :ok

      iex> validate_boolean_field("true", :is_relative)
      {:error, "is_relative must be a boolean value (true or false)"}

  """
  @spec validate_boolean_field(boolean() | nil, atom()) :: :ok | {:error, String.t()}
  def validate_boolean_field(nil, _field_name), do: :ok
  def validate_boolean_field(value, _field_name) when is_boolean(value), do: :ok

  def validate_boolean_field(_, field_name),
    do: {:error, "#{field_name} must be a boolean value (true or false)"}

  @doc """
  Validates a required string field.

  The field must be a non-empty string.

  ## Parameters

    * `value` - The value to validate.
    * `field_name` - The name of the field being validated as an atom.

  ## Returns

    * `:ok` if the value is a valid non-empty string.
    * `{:error, reason}` if the value is not valid, where reason is a string explaining the error.

  ## Examples

      iex> validate_required_string("valid string", :key)
      :ok

      iex> validate_required_string("", :key)
      {:error, "key is a required field and must be a non-empty string"}

      iex> validate_required_string(nil, :key)
      {:error, "key is a required field and must be a non-empty string"}

      iex> validate_required_string(123, :key)
      {:error, "key is a required field and must be a non-empty string"}

  """
  @spec validate_required_string(String.t(), atom()) :: :ok | {:error, String.t()}
  def validate_required_string(value, _field_name) when is_binary(value) and value != "", do: :ok

  def validate_required_string(_, field_name),
    do: {:error, "#{field_name} is a required field and must be a non-empty string"}

  @doc """
  Validates an optional string field.

  The field must be a string or nil.

  ## Parameters

    * `value` - The value to validate.
    * `field_name` - The name of the field being validated as an atom.

  ## Returns

    * `:ok` if the value is a valid string or nil.
    * `{:error, reason}` if the value is not valid, where reason is a string explaining the error.

  ## Examples

      iex> validate_optional_string("valid string", :label)
      :ok

      iex> validate_optional_string("", :label)
      :ok

      iex> validate_optional_string(nil, :label)
      :ok

      iex> validate_optional_string(123, :label)
      {:error, "label must be a string if provided"}

  """
  @spec validate_optional_string(String.t() | nil, atom()) :: :ok | {:error, String.t()}
  def validate_optional_string(value, _field_name) when is_binary(value) or is_nil(value), do: :ok

  def validate_optional_string(_, field_name),
    do: {:error, "#{field_name} must be a string if provided"}

  @doc """
  Validates the number_style field.

  The number_style must be a valid number style string.

  ## Returns

    * `:ok` if the value is a valid number style string or nil.
    * `{:error, reason}` if the value is not valid, where reason is a string explaining the error.

  ## Examples

      iex> validate_number_style("PKNumberStyleDecimal")
      :ok

      iex> validate_number_style(nil)
      :ok

      iex> validate_number_style("InvalidStyle")
      {:error, "Invalid number_style: InvalidStyle. Supported values are: PKNumberStyleDecimal, PKNumberStylePercent, PKNumberStyleScientific, PKNumberStyleSpellOut"}

      iex> validate_number_style(42)
      {:error, "number_style must be a string"}

  """
  @spec validate_number_style(String.t() | nil) :: :ok | {:error, String.t()}
  def validate_number_style(nil), do: :ok

  def validate_number_style(style) when is_binary(style) do
    validate_inclusion(style, @valid_number_styles, "number_style")
  end

  def validate_number_style(_), do: {:error, "number_style must be a string"}

  @doc """
  Validates a required value field.

  The field must be a non-nil value. The value can be a localizable string, ISO 8601 date, or number.

  ## Parameters

    * `value` - The value to validate. A date or time value must include a time zone.
    * `field_name` - The name of the field being validated as an atom.

  ## Returns

    * `:ok` if the value is valid (non-nil).
    * `{:error, reason}` if the value is not valid, where reason is a string explaining the error.

  ## Examples

      iex> validate_required_value(42, :value)
      :ok

      iex> validate_required_value(nil, :value)
      {:error, "value is a required field and cannot be nil"}

      iex> validate_required_value("2021-09-15T15:53:00Z", :value)
      :ok

      iex> validate_required_value("localizable string", :value)
      :ok

      iex> validate_required_value(nil, :another_field)
      {:error, "another_field is a required field and cannot be nil"}

      iex> validate_required_value("2023-04-15T14:30:00", :value)
      :ok

  """
  @spec validate_required_value(String.t() | number() | DateTime.t() | Date.t(), atom()) ::
          :ok | {:error, String.t()}
  def validate_required_value(nil, field_name),
    do: {:error, "#{field_name} is a required field and cannot be nil"}

  def validate_required_value(value, _field_name) when is_number(value), do: :ok

  def validate_required_value(value, _field_name) when is_binary(value), do: :ok

  def validate_required_value(%DateTime{}, _field_name), do: :ok
  def validate_required_value(%Date{}, _field_name), do: :ok

  def validate_required_value(_, field_name),
    do: {:error, "#{field_name} must be a string, number, DateTime, or Date"}

  @doc """
  Validates the text alignment value.

  This function checks if the given value is a valid text alignment option.
  Valid options are "PKTextAlignmentLeft", "PKTextAlignmentCenter", "PKTextAlignmentRight", and "PKTextAlignmentNatural".

  ## Parameters

    * `value` - The text alignment value to validate.

  ## Returns

    * `:ok` if the value is valid.
    * `{:error, message}` if the value is invalid, where `message` is a string explaining the error.

  ## Examples

      iex> validate_text_alignment("PKTextAlignmentLeft")
      :ok

      iex> validate_text_alignment("PKTextAlignmentCenter")
      :ok

      iex> validate_text_alignment("PKTextAlignmentRight")
      :ok

      iex> validate_text_alignment("PKTextAlignmentNatural")
      :ok

      iex> validate_text_alignment("InvalidAlignment")
      {:error, "Invalid text_alignment: InvalidAlignment. Supported values are: PKTextAlignmentLeft, PKTextAlignmentCenter, PKTextAlignmentRight, PKTextAlignmentNatural"}

      iex> validate_text_alignment(nil)
      :ok

  """
  @spec validate_text_alignment(String.t() | nil) :: :ok | {:error, String.t()}
  def validate_text_alignment(nil), do: :ok

  def validate_text_alignment(value) when is_binary(value) do
    validate_inclusion(value, @valid_text_alignments, "text_alignment")
  end

  def validate_text_alignment(_),
    do: {:error, "text_alignment must be a string"}

  @doc """
  Validates the barcode format.

  This function checks if the given value is a valid barcode format.
  Valid formats are "PKBarcodeFormatQR", "PKBarcodeFormatPDF417", "PKBarcodeFormatAztec", and "PKBarcodeFormatCode128".

  ## Parameters

    * `value` - The barcode format value to validate.

  ## Returns

    * `:ok` if the value is valid.
    * `{:error, message}` if the value is invalid, where `message` is a string explaining the error.

  ## Examples

      iex> validate_barcode_format("PKBarcodeFormatQR")
      :ok

      iex> validate_barcode_format("PKBarcodeFormatPDF417")
      :ok

      iex> validate_barcode_format("InvalidFormat")
      {:error, "Invalid format: InvalidFormat. Supported formats are: PKBarcodeFormatQR, PKBarcodeFormatPDF417, PKBarcodeFormatAztec, PKBarcodeFormatCode128"}

      iex> validate_barcode_format(nil)
      {:error, "format is required"}

  """
  @spec validate_barcode_format(String.t() | nil) :: :ok | {:error, String.t()}
  def validate_barcode_format(nil), do: {:error, "format is required"}

  def validate_barcode_format(value) when is_binary(value) do
    validate_inclusion(value, @valid_barcode_formats, "format")
  end

  def validate_barcode_format(_), do: {:error, "format must be a string"}

  defp validate_inclusion(value, valid_values, field_name) do
    if value in valid_values do
      :ok
    else
      {:error,
       "Invalid #{field_name}: #{value}. Supported values are: #{Enum.join(valid_values, ", ")}"}
    end
  end

  defp validate_inclusion_list(values, valid_values, field_name) do
    invalid_values = Enum.reject(values, &(&1 in valid_values))

    if invalid_values == [] do
      :ok
    else
      {:error,
       "Invalid #{field_name}: #{Enum.join(invalid_values, ", ")}. Supported values are: #{Enum.join(valid_values, ", ")}"}
    end
  end

  defp contains_unsupported_html_tags?(string) do
    # Remove all valid anchor tags
    string_without_anchors =
      Regex.replace(~r{<a\s[^>]*>.*?</a>|<a\s[^>]*/>}, string, "")

    # Check if any HTML tags remain
    Regex.match?(~r{<[^>]+>}, string_without_anchors)
  end
end
