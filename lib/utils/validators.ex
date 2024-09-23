defmodule ExPass.Utils.Validators do
  @moduledoc """
  Provides validation functions for ExPass data types.

  This module contains utility functions to validate different types of data
  used in pass creation and management, ensuring they meet required formats
  and constraints.

  These validators are primarily used internally by other ExPass modules.
  """

  @currency_code_regex ~r/^(AED|AFN|ALL|AMD|ANG|AOA|ARS|AUD|AWG|AZN|BAM|BBD|BDT|BGN|BHD|BIF|BMD|BND|BOB|BOV|BRL|BSD|BTN|BWP|BYN|BZD|CAD|CDF|CHE|CHF|CHW|CLF|CLP|CNY|COP|COU|CRC|CUP|CVE|CZK|DJF|DKK|DOP|DZD|EGP|ERN|ETB|EUR|FJD|FKP|GBP|GEL|GHS|GIP|GMD|GNF|GTQ|GYD|HKD|HNL|HTG|HUF|IDR|ILS|INR|IQD|IRR|ISK|JMD|JOD|JPY|KES|KGS|KHR|KMF|KPW|KRW|KWD|KYD|KZT|LAK|LBP|LKR|LRD|LSL|LYD|MAD|MDL|MGA|MKD|MMK|MNT|MOP|MRU|MUR|MVR|MWK|MXN|MXV|MYR|MZN|NAD|NGN|NIO|NOK|NPR|NZD|OMR|PAB|PEN|PGK|PHP|PKR|PLN|PYG|QAR|RON|RSD|RUB|RWF|SAR|SBD|SCR|SDG|SEK|SGD|SHP|SLE|SOS|SRD|SSP|STN|SVC|SYP|SZL|THB|TJS|TMT|TND|TOP|TRY|TTD|TWD|TZS|UAH|UGX|USD|USN|UYI|UYU|UYW|UZS|VED|VES|VND|VUV|WST|XAF|XAG|XAU|XBA|XBB|XBC|XBD|XCD|XDR|XOF|XPD|XPF|XPT|XSU|XTS|XUA|XXX|YER|ZAR|ZMW|ZWG|ZWL)$/

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
      {:error, "Invalid attributed_value type. Supported types are: String (including <a></a> tag), number, DateTime and Date"}

  """
  @spec validate_attributed_value(String.t() | number() | DateTime.t() | Date.t() | nil) ::
          :ok | {:error, String.t()}
  def validate_attributed_value(nil), do: :ok
  def validate_attributed_value(value) when is_number(value), do: :ok

  def validate_attributed_value(value) when is_binary(value) do
    case contains_unsupported_html_tags?(value) do
      true -> {:error, "Supported types are: String (including <a></a> tag), number, DateTime and Date"}
      false -> :ok
    end
  end

  def validate_attributed_value(%DateTime{} = value) do
    DateTime.to_iso8601(value)

    :ok
  end

  def validate_attributed_value(%Date{} = value) do
    Date.to_iso8601(value)

    :ok
  end

  def validate_attributed_value(_), do: {:error, "Invalid attributed_value type. Supported types are: String (including <a></a> tag), number, DateTime and Date"}

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
      {:error, "The change_message must be a string containing the '%@' placeholder for the new value."}
    end
  end

  def validate_change_message(_), do: {:error, "The change_message must be a string containing the '%@' placeholder for the new value."}

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
    value_string = if is_atom(value), do: Atom.to_string(value), else: value

    if Regex.match?(@currency_code_regex, value_string) do
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
      {:error, "Invalid data detector type: InvalidDetector. Supported types are: PKDataDetectorTypePhoneNumber, PKDataDetectorTypeLink, PKDataDetectorTypeAddress, PKDataDetectorTypeCalendarEvent"}

      iex> validate_data_detector_types("PKDataDetectorTypePhoneNumber")
      {:error, "data_detector_types must be a list"}

  """
  @spec validate_data_detector_types(list(String.t()) | nil) :: :ok | {:error, String.t()}
  def validate_data_detector_types(nil), do: :ok
  def validate_data_detector_types([]), do: :ok

  def validate_data_detector_types(types) when is_list(types) do
    invalid_types = Enum.reject(types, &(&1 in @valid_detector_types))

    if Enum.empty?(invalid_types) do
      :ok
    else
      {:error,
       "Invalid data detector type: #{Enum.join(invalid_types, ", ")}. Supported types are: #{Enum.join(@valid_detector_types, ", ")}"}
    end
  end

  def validate_data_detector_types(_), do: {:error, "data_detector_types must be a list"}

  @doc """
  Validates the date_style field.

  The date_style must be a valid date style string.

  ## Returns

    * `:ok` if the value is a valid date style string or nil.
    * `{:error, reason}` if the value is not valid, where reason is a string explaining the error.

  ## Examples

      iex> validate_date_style("PKDateStyleShort")
      :ok

      iex> validate_date_style(nil)
      :ok

      iex> validate_date_style("InvalidStyle")
      {:error, "Invalid date_style: InvalidStyle. Supported values are: PKDateStyleNone, PKDateStyleShort, PKDateStyleMedium, PKDateStyleLong, PKDateStyleFull"}

      iex> validate_date_style(42)
      {:error, "date_style must be a string"}

  """
  @spec validate_date_style(String.t() | nil) :: :ok | {:error, String.t()}
  def validate_date_style(nil), do: :ok

  def validate_date_style(style) when is_binary(style) do
    if style in @valid_date_styles do
      :ok
    else
      {:error,
       "Invalid date_style: #{style}. Supported values are: #{Enum.join(@valid_date_styles, ", ")}"}
    end
  end

  def validate_date_style(_), do: {:error, "date_style must be a string"}

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
  def validate_boolean_field(_, field_name), do: {:error, "#{field_name} must be a boolean value (true or false)"}

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
      {:error, "key cannot be an empty string"}

      iex> validate_required_string(nil, :key)
      {:error, "key is a required field and must be a non-empty string"}

      iex> validate_required_string(123, :key)
      {:error, "key is a required field and must be a non-empty string"}

  """
  @spec validate_required_string(String.t() | nil, atom()) :: :ok | {:error, String.t()}
  def validate_required_string(nil, field_name), do: {:error, "#{field_name} is a required field and must be a non-empty string"}

  def validate_required_string("", field_name),
    do: {:error, "#{field_name} cannot be an empty string"}

  def validate_required_string(value, _field_name) when is_binary(value), do: :ok
  def validate_required_string(_, field_name), do: {:error, "#{field_name} is a required field and must be a non-empty string"}

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
  def validate_optional_string(nil, _field_name), do: :ok
  def validate_optional_string(value, _field_name) when is_binary(value), do: :ok
  def validate_optional_string(_, field_name), do: {:error, "#{field_name} must be a string if provided"}

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

  def validate_number_style(value) when is_binary(value) do
    if value in @valid_number_styles do
      :ok
    else
      {:error,
       "Invalid number_style: #{value}. Supported values are: #{Enum.join(@valid_number_styles, ", ")}"}
    end
  end

  def validate_number_style(_), do: {:error, "number_style must be a string"}

  defp contains_unsupported_html_tags?(string) do
    # Remove all valid anchor tags
    string_without_anchors = String.replace(string, ~r{<a\s[^>]*>.*?</a>|<a\s[^>]*/>}, "")

    # Check if any HTML tags remain
    Regex.match?(~r{<[^>]+>}, string_without_anchors)
  end
end
