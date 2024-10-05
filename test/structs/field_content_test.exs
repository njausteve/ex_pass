defmodule ExPass.Structs.FieldContentTest do
  @moduledoc false

  use ExUnit.Case
  alias ExPass.Structs.FieldContent

  doctest FieldContent

  describe "new/1" do
    test "new/1 raises ArgumentError when called with no arguments" do
      assert_raise ArgumentError, "key is a required field and must be a non-empty string", fn ->
        FieldContent.new()
      end
    end

    test "creates a new FieldContent with minimum required fields" do
      field_content = FieldContent.new(%{key: "test_key", value: "test_value"})
      assert %FieldContent{key: "test_key", value: "test_value"} = field_content
    end

    test "raises ArgumentError for invalid attributes" do
      assert_raise ArgumentError,
                   "Invalid data_detector_types: InvalidType. Supported values are: PKDataDetectorTypePhoneNumber, PKDataDetectorTypeLink, PKDataDetectorTypeAddress, PKDataDetectorTypeCalendarEvent",
                   fn ->
                     FieldContent.new(%{
                       key: "test",
                       value: "test",
                       data_detector_types: ["InvalidType"]
                     })
                   end
    end
  end

  describe "change_message" do
    test "new/1 raises ArgumentError for invalid change_message without '%@' placeholder" do
      message = "Balance updated"

      assert_raise ArgumentError,
                   "The change_message must be a string containing the '%@' placeholder for the new value.",
                   fn ->
                     FieldContent.new(%{
                       key: "test_key",
                       value: "test_value",
                       change_message: message
                     })
                   end
    end

    test "new/1 creates a FieldContent struct with valid change_message containing '%@' placeholder" do
      message = "Balance updated to %@"
      result = FieldContent.new(%{key: "test_key", value: "test_value", change_message: message})

      assert result.change_message == message
      assert result.key == "test_key"
      assert result.value == "test_value"
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("changeMessage":"Balance updated to %@")
    end

    test "new/1 trims whitespace from change_message while preserving '%@' placeholder" do
      message = "  Trimmed message %@  "
      result = FieldContent.new(%{key: "test_key", value: "test_value", change_message: message})

      assert result.change_message == "Trimmed message %@"
      assert result.key == "test_key"
      assert result.value == "test_value"
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("changeMessage":"Trimmed message %@")
    end

    test "validate_change_message/1 returns error for invalid change_message" do
      invalid_message = "Invalid message without placeholder"

      assert {:error,
              "The change_message must be a string containing the '%@' placeholder for the new value."} ==
               ExPass.Utils.Validators.validate_change_message(invalid_message)
    end

    test "validate_change_message/1 returns error when change_message is not a string" do
      invalid_types = [42, :atom, [], %{}]

      for invalid_type <- invalid_types do
        assert {:error,
                "The change_message must be a string containing the '%@' placeholder for the new value."} ==
                 ExPass.Utils.Validators.validate_change_message(invalid_type)
      end
    end
  end

  describe "attributed_value" do
    test "new/1 creates an empty FieldContent struct when no attributes are provided" do
      result = FieldContent.new(%{key: "test_key", value: "test_value"})
      assert %FieldContent{attributed_value: nil, value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      refute encoded =~ "attributedValue"
    end

    test "new/1 creates a valid FieldContent struct with string" do
      input_string = "Hello, World!"

      result =
        FieldContent.new(%{key: "test_key", value: "test_value", attributed_value: input_string})

      assert %FieldContent{attributed_value: ^input_string, value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("attributedValue":"Hello, World!")
    end

    test "new/1 creates a valid FieldContent struct with number" do
      input_number = 42

      result =
        FieldContent.new(%{key: "test_key", value: "test_value", attributed_value: input_number})

      assert %FieldContent{attributed_value: ^input_number, value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("attributedValue":42)
    end

    test "new/1 raises ArgumentError for invalid attributed_value types" do
      invalid_values = [%{}, [1, 2, 3], self(), :atom]

      for invalid_value <- invalid_values do
        assert_raise ArgumentError,
                     "Invalid attributed_value type. Supported types are: String (including <a></a> tag), number, DateTime, and Date",
                     fn ->
                       FieldContent.new(%{
                         key: "test_key",
                         value: "test_value",
                         attributed_value: invalid_value
                       })
                     end
      end
    end

    test "new/1 creates a valid FieldContent struct with DateTime" do
      input_time = DateTime.utc_now()

      result =
        FieldContent.new(%{key: "test_key", value: "test_value", attributed_value: input_time})

      assert %FieldContent{attributed_value: ^input_time, value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("attributedValue":"#{DateTime.to_iso8601(input_time)}")
    end

    test "new/1 creates a valid FieldContent struct with Date" do
      input_date = Date.utc_today()

      result =
        FieldContent.new(%{key: "test_key", value: "test_value", attributed_value: input_date})

      assert %FieldContent{attributed_value: ^input_date, value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("attributedValue":"#{Date.to_iso8601(input_date)}")
    end

    test "new/1 raises ArgumentError for attributed_value with unsupported HTML tag" do
      input_value = "<span>Unsupported tag</span>"

      assert_raise ArgumentError,
                   "Invalid attributed_value type. Supported types are: String (including <a></a> tag), number, DateTime, and Date",
                   fn ->
                     FieldContent.new(%{
                       key: "test_key",
                       value: "test_value",
                       attributed_value: input_value
                     })
                   end
    end

    test "new/1 creates a valid FieldContent struct with supported HTML tag" do
      input_value = "<a href='http://example.com'>Link</a>"

      result =
        FieldContent.new(%{key: "test_key", value: "test_value", attributed_value: input_value})

      assert %FieldContent{attributed_value: ^input_value, value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("attributedValue":"<a href='http://example.com'>Link</a>")
    end
  end

  describe "currency_code" do
    test "new/1 creates a valid FieldContent struct with valid currency_code as string" do
      result = FieldContent.new(%{key: "test_key", value: "test_value", currency_code: "USD"})

      assert %FieldContent{currency_code: "USD", value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("currencyCode":"USD")
    end

    test "new/1 creates a valid FieldContent struct with valid currency_code as atom" do
      result = FieldContent.new(%{key: "test_key", value: "test_value", currency_code: :USD})

      assert %FieldContent{currency_code: :USD, value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("currencyCode":"USD")
    end

    test "new/1 raises ArgumentError for invalid currency_code" do
      assert_raise ArgumentError, ~r/Invalid currency code INVALID/, fn ->
        FieldContent.new(%{key: "test_key", value: "test_value", currency_code: "INVALID"})
      end

      assert_raise ArgumentError, ~r/Invalid currency code INVALID/, fn ->
        FieldContent.new(%{key: "test_key", value: "test_value", currency_code: :INVALID})
      end
    end

    test "new/1 raises ArgumentError when currency_code is not a string or atom" do
      assert_raise ArgumentError, ~r/Currency code must be a string or atom/, fn ->
        FieldContent.new(%{key: "test_key", value: "test_value", currency_code: 123})
      end
    end

    test "new/1 trims whitespace from currency_code string" do
      result = FieldContent.new(%{key: "test_key", value: "test_value", currency_code: "  USD  "})

      assert %FieldContent{currency_code: "USD", value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("currencyCode":"USD")
    end
  end

  describe "data_detector_types" do
    test "new/1 creates a valid FieldContent struct with valid data_detector_types" do
      result =
        FieldContent.new(%{
          key: "test_key",
          value: "test_value",
          data_detector_types: ["PKDataDetectorTypePhoneNumber", "PKDataDetectorTypeLink"]
        })

      assert %FieldContent{
               data_detector_types: ["PKDataDetectorTypePhoneNumber", "PKDataDetectorTypeLink"],
               value: "test_value"
             } = result

      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")

      assert encoded =~
               ~s("dataDetectorTypes":["PKDataDetectorTypePhoneNumber","PKDataDetectorTypeLink"])
    end

    test "new/1 creates a valid FieldContent struct with empty data_detector_types" do
      result = FieldContent.new(%{key: "test_key", value: "test_value", data_detector_types: []})

      assert %FieldContent{data_detector_types: [], value: "test_value"} = result

      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("dataDetectorTypes":[])
    end

    test "new/1 raises ArgumentError for invalid data_detector_types" do
      assert_raise ArgumentError,
                   ~r/Invalid data_detector_types: InvalidDetector. Supported values are: PKDataDetectorTypePhoneNumber, PKDataDetectorTypeLink, PKDataDetectorTypeAddress, PKDataDetectorTypeCalendarEvent/,
                   fn ->
                     FieldContent.new(%{
                       key: "test_key",
                       value: "test_value",
                       data_detector_types: ["InvalidDetector"]
                     })
                   end
    end

    test "new/1 raises ArgumentError when data_detector_types is not a list" do
      assert_raise ArgumentError, ~r/data_detector_types must be a list/, fn ->
        FieldContent.new(%{
          key: "test_key",
          value: "test_value",
          data_detector_types: "PKDataDetectorTypePhoneNumber"
        })
      end
    end
  end

  describe "date_style" do
    test "new/1 creates a valid FieldContent struct with date_style" do
      result =
        FieldContent.new(%{key: "test_key", value: "test_value", date_style: "PKDateStyleShort"})

      assert %FieldContent{date_style: "PKDateStyleShort", value: "test_value"} = result

      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("dateStyle":"PKDateStyleShort")
    end

    test "new/1 allows all valid date_style values" do
      valid_styles = [
        "PKDateStyleNone",
        "PKDateStyleShort",
        "PKDateStyleMedium",
        "PKDateStyleLong",
        "PKDateStyleFull"
      ]

      for style <- valid_styles do
        result = FieldContent.new(%{key: "test_key", value: "test_value", date_style: style})
        assert %FieldContent{date_style: ^style, value: "test_value"} = result
        encoded = Jason.encode!(result)
        assert encoded =~ ~s("key":"test_key")
        assert encoded =~ ~s("value":"test_value")
        assert encoded =~ ~s("dateStyle":"#{style}")
      end
    end

    test "new/1 raises ArgumentError for invalid date_style" do
      assert_raise ArgumentError,
                   ~r/Invalid date_style: InvalidStyle. Supported values are: PKDateStyleNone, PKDateStyleShort, PKDateStyleMedium, PKDateStyleLong, PKDateStyleFull/,
                   fn ->
                     FieldContent.new(%{
                       key: "test_key",
                       value: "test_value",
                       date_style: "InvalidStyle"
                     })
                   end
    end

    test "new/1 raises ArgumentError when date_style is not a string" do
      assert_raise ArgumentError, ~r/date_style must be a string/, fn ->
        FieldContent.new(%{key: "test_key", value: "test_value", date_style: :PKDateStyleShort})
      end
    end
  end

  describe "ignores_time_zone" do
    test "new/1 creates a valid FieldContent struct with ignores_time_zone set to true" do
      result = FieldContent.new(%{key: "test_key", value: "test_value", ignores_time_zone: true})

      assert %FieldContent{ignores_time_zone: true, value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("ignoresTimeZone":true)
    end

    test "new/1 creates a valid FieldContent struct with ignores_time_zone set to false" do
      result = FieldContent.new(%{key: "test_key", value: "test_value", ignores_time_zone: false})

      assert %FieldContent{ignores_time_zone: false, value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("ignoresTimeZone":false)
    end

    test "new/1 defaults to nil when ignores_time_zone is not provided" do
      result = FieldContent.new(%{key: "test_key", value: "test_value"})

      assert %FieldContent{ignores_time_zone: nil, value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      refute encoded =~ "ignoresTimeZone"
    end

    test "new/1 raises ArgumentError when ignores_time_zone is not a boolean" do
      assert_raise ArgumentError, ~r/ignores_time_zone must be a boolean/, fn ->
        FieldContent.new(%{key: "test_key", value: "test_value", ignores_time_zone: "true"})
      end
    end
  end

  describe "is_relative" do
    test "new/1 creates a valid FieldContent struct with is_relative set to true" do
      result = FieldContent.new(%{key: "test_key", value: "test_value", is_relative: true})

      assert %FieldContent{is_relative: true, value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("isRelative":true)
    end

    test "new/1 creates a valid FieldContent struct with is_relative set to false" do
      result = FieldContent.new(%{key: "test_key", value: "test_value", is_relative: false})

      assert %FieldContent{is_relative: false, value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("isRelative":false)
    end

    test "new/1 defaults to nil when is_relative is not provided" do
      result = FieldContent.new(%{key: "test_key", value: "test_value"})

      assert %FieldContent{is_relative: nil, value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      refute encoded =~ "isRelative"
    end

    test "new/1 raises ArgumentError when is_relative is not a boolean" do
      assert_raise ArgumentError, ~r/is_relative must be a boolean/, fn ->
        FieldContent.new(%{key: "test_key", value: "test_value", is_relative: "true"})
      end
    end
  end

  describe "key and value" do
    test "new/1 creates a valid FieldContent struct with a key and value" do
      result = FieldContent.new(%{key: "unique_identifier", value: "test_value"})

      assert %FieldContent{key: "unique_identifier", value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"unique_identifier")
      assert encoded =~ ~s("value":"test_value")
    end

    test "new/1 raises ArgumentError when key is not provided" do
      assert_raise ArgumentError, "key is a required field and must be a non-empty string", fn ->
        FieldContent.new(%{value: "test_value"})
      end
    end

    test "new/1 raises ArgumentError when value is not provided" do
      assert_raise ArgumentError, "value is a required field and cannot be nil", fn ->
        FieldContent.new(%{key: "unique_identifier"})
      end
    end

    test "new/1 raises ArgumentError when key is an empty string" do
      assert_raise ArgumentError, "key is a required field and must be a non-empty string", fn ->
        FieldContent.new(%{key: "", value: "test_value"})
      end
    end

    test "new/1 raises ArgumentError when key is not a string" do
      assert_raise ArgumentError, "key is a required field and must be a non-empty string", fn ->
        FieldContent.new(%{key: 123, value: "test_value"})
      end
    end

    test "new/1 trims whitespace from key" do
      result = FieldContent.new(%{key: "  trimmed_key  ", value: "test_value"})

      assert %FieldContent{key: "trimmed_key", value: "test_value"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"trimmed_key")
      assert encoded =~ ~s("value":"test_value")
    end

    test "new/1 allows various types for value" do
      string_value = FieldContent.new(%{key: "string_key", value: "string_value"})
      assert %FieldContent{key: "string_key", value: "string_value"} = string_value

      number_value = FieldContent.new(%{key: "number_key", value: 42})
      assert %FieldContent{key: "number_key", value: 42} = number_value

      date_value = FieldContent.new(%{key: "date_key", value: ~D[2023-05-17]})
      assert %FieldContent{key: "date_key", value: ~D[2023-05-17]} = date_value

      datetime_value = FieldContent.new(%{key: "datetime_key", value: ~U[2023-05-17 10:00:00Z]})
      assert %FieldContent{key: "datetime_key", value: ~U[2023-05-17 10:00:00Z]} = datetime_value
    end
  end

  describe "label" do
    test "new/1 creates a valid FieldContent struct with a label" do
      result = FieldContent.new(%{key: "test_key", value: "test_value", label: "Test Label"})

      assert %FieldContent{key: "test_key", value: "test_value", label: "Test Label"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("label":"Test Label")
    end

    test "new/1 creates a valid FieldContent struct without a label" do
      result = FieldContent.new(%{key: "test_key", value: "test_value"})

      assert %FieldContent{key: "test_key", value: "test_value", label: nil} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      refute encoded =~ "label"
    end

    test "new/1 trims whitespace from label" do
      result =
        FieldContent.new(%{key: "test_key", value: "test_value", label: "  Trimmed Label  "})

      assert %FieldContent{key: "test_key", value: "test_value", label: "Trimmed Label"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("label":"Trimmed Label")
    end

    test "new/1 raises ArgumentError when label is not a string" do
      assert_raise ArgumentError, ~r/label must be a string/, fn ->
        FieldContent.new(%{key: "test_key", value: "test_value", label: 123})
      end
    end

    test "new/1 allows an empty string for label" do
      result = FieldContent.new(%{key: "test_key", value: "test_value", label: ""})

      assert %FieldContent{key: "test_key", value: "test_value", label: ""} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("label":"")
    end
  end

  describe "number_style" do
    test "new/1 creates a valid FieldContent struct with number_style" do
      result =
        FieldContent.new(%{
          key: "test_key",
          value: "test_value",
          number_style: "PKNumberStyleDecimal"
        })

      assert %FieldContent{
               key: "test_key",
               value: "test_value",
               number_style: "PKNumberStyleDecimal"
             } = result

      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      assert encoded =~ ~s("numberStyle":"PKNumberStyleDecimal")
    end

    test "new/1 raises ArgumentError for invalid number_style" do
      assert_raise ArgumentError, ~r/Invalid number_style/, fn ->
        FieldContent.new(%{key: "test_key", value: "test_value", number_style: "InvalidStyle"})
      end
    end

    test "new/1 allows nil for number_style" do
      result = FieldContent.new(%{key: "test_key", value: "test_value", number_style: nil})

      assert %FieldContent{key: "test_key", value: "test_value", number_style: nil} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"test_value")
      refute encoded =~ "numberStyle"
    end

    test "new/1 creates a valid FieldContent struct with all number_style options" do
      styles = [
        "PKNumberStyleDecimal",
        "PKNumberStylePercent",
        "PKNumberStyleScientific",
        "PKNumberStyleSpellOut"
      ]

      Enum.each(styles, fn style ->
        result = FieldContent.new(%{key: "test_key", value: "test_value", number_style: style})

        assert %FieldContent{key: "test_key", value: "test_value", number_style: ^style} = result
        encoded = Jason.encode!(result)
        assert encoded =~ ~s("key":"test_key")
        assert encoded =~ ~s("value":"test_value")
        assert encoded =~ ~s("numberStyle":"#{style}")
      end)
    end

    test "new/1 raises ArgumentError when number_style is not a string" do
      assert_raise ArgumentError, ~r/number_style must be a string/, fn ->
        FieldContent.new(%{
          key: "test_key",
          value: "test_value",
          number_style: :PKNumberStyleDecimal
        })
      end
    end
  end

  describe "value" do
    test "new/1 creates a valid FieldContent struct with a localizable string value" do
      result = FieldContent.new(%{key: "test_key", value: "Hello, World!"})

      assert %FieldContent{key: "test_key", value: "Hello, World!"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"Hello, World!")
    end

    test "new/1 creates a valid FieldContent struct with an ISO 8601 date value" do
      iso_date = "2023-04-15T14:30:00Z"
      result = FieldContent.new(%{key: "test_key", value: iso_date})

      assert %FieldContent{key: "test_key", value: ^iso_date} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":"2023-04-15T14:30:00Z")
    end

    test "new/1 creates a valid FieldContent struct with a number value" do
      result = FieldContent.new(%{key: "test_key", value: 42})

      assert %FieldContent{key: "test_key", value: 42} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("value":42)
    end

    test "new/1 raises ArgumentError for invalid value type" do
      assert_raise ArgumentError, "value must be a string, number, DateTime, or Date", fn ->
        FieldContent.new(%{key: "test_key", value: %{invalid: "type"}})
      end
    end
  end

  describe "text_alignment" do
    test "new/1 creates a valid FieldContent struct with text_alignment" do
      alignments = [
        "PKTextAlignmentLeft",
        "PKTextAlignmentCenter",
        "PKTextAlignmentRight",
        "PKTextAlignmentNatural"
      ]

      Enum.each(alignments, fn alignment ->
        result =
          FieldContent.new(%{key: "test_key", value: "test_value", text_alignment: alignment})

        assert %FieldContent{key: "test_key", value: "test_value", text_alignment: ^alignment} =
                 result

        encoded = Jason.encode!(result)
        assert encoded =~ ~s("key":"test_key")
        assert encoded =~ ~s("value":"test_value")
        assert encoded =~ ~s("textAlignment":"#{alignment}")
      end)
    end

    test "new/1 raises ArgumentError for invalid text_alignment" do
      assert_raise ArgumentError, ~r/Invalid text_alignment/, fn ->
        FieldContent.new(%{
          key: "test_key",
          value: "test_value",
          text_alignment: "InvalidAlignment"
        })
      end
    end

    test "new/1 allows text_alignment to be nil" do
      result = FieldContent.new(%{key: "test_key", value: "test_value", text_alignment: nil})

      assert %FieldContent{key: "test_key", value: "test_value", text_alignment: nil} = result
      encoded = Jason.encode!(result)
      refute encoded =~ "textAlignment"
    end

    test "new/1 raises ArgumentError when text_alignment is not a string" do
      assert_raise ArgumentError, "text_alignment must be a string", fn ->
        FieldContent.new(%{
          key: "test_key",
          value: "test_value",
          text_alignment: 123
        })
      end

      assert_raise ArgumentError, "text_alignment must be a string", fn ->
        FieldContent.new(%{
          key: "test_key",
          value: "test_value",
          text_alignment: :some_atom
        })
      end

      assert_raise ArgumentError, "text_alignment must be a string", fn ->
        FieldContent.new(%{
          key: "test_key",
          value: "test_value",
          text_alignment: ["PKTextAlignmentLeft"]
        })
      end
    end
  end

  describe "timeStyle" do
    test "new/1 creates a valid FieldContent struct with time_style" do
      time_styles = [
        "PKDateStyleNone",
        "PKDateStyleShort",
        "PKDateStyleMedium",
        "PKDateStyleLong",
        "PKDateStyleFull"
      ]

      Enum.each(time_styles, fn style ->
        result =
          FieldContent.new(%{
            key: "test_key",
            value: "2023-04-15T14:30:00Z",
            date_style: "PKDateStyleMedium",
            time_style: style
          })

        assert %FieldContent{
                 key: "test_key",
                 value: "2023-04-15T14:30:00Z",
                 date_style: "PKDateStyleMedium",
                 time_style: ^style
               } = result

        encoded = Jason.encode!(result)
        assert encoded =~ ~s("key":"test_key")
        assert encoded =~ ~s("value":"2023-04-15T14:30:00Z")
        assert encoded =~ ~s("dateStyle":"PKDateStyleMedium")
        assert encoded =~ ~s("timeStyle":"#{style}")
      end)
    end

    test "new/1 raises ArgumentError for invalid time_style" do
      assert_raise ArgumentError, ~r/Invalid time_style/, fn ->
        FieldContent.new(%{
          key: "test_key",
          value: "2023-04-15T14:30:00Z",
          date_style: "PKDateStyleMedium",
          time_style: "InvalidTimeStyle"
        })
      end
    end

    test "new/1 allows time_style to be nil" do
      result =
        FieldContent.new(%{
          key: "test_key",
          value: "2023-04-15T14:30:00Z",
          date_style: "PKDateStyleMedium",
          time_style: nil
        })

      assert %FieldContent{
               key: "test_key",
               value: "2023-04-15T14:30:00Z",
               date_style: "PKDateStyleMedium",
               time_style: nil
             } = result

      encoded = Jason.encode!(result)
      assert encoded =~ ~s("dateStyle":"PKDateStyleMedium")
      refute encoded =~ "timeStyle"
    end

    test "new/1 allows timeStyle to be omitted" do
      result =
        FieldContent.new(%{
          key: "test_key",
          value: "2023-04-15T14:30:00Z",
          date_style: "PKDateStyleMedium"
        })

      assert %FieldContent{
               key: "test_key",
               value: "2023-04-15T14:30:00Z",
               date_style: "PKDateStyleMedium",
               time_style: nil
             } = result

      encoded = Jason.encode!(result)
      assert encoded =~ ~s("dateStyle":"PKDateStyleMedium")
      refute encoded =~ "timeStyle"
    end

    test "new/1 raises ArgumentError when time_style is not a string" do
      assert_raise ArgumentError, ~r/time_style must be a string/, fn ->
        FieldContent.new(%{
          key: "test_key",
          value: "2023-04-15T14:30:00Z",
          time_style: 123
        })
      end
    end
  end
end
