defmodule ExPass.Structs.FieldContentTest do
  @moduledoc false

  use ExUnit.Case
  alias ExPass.Structs.FieldContent

  doctest FieldContent

  describe "change_message" do
    test "new/1 raises ArgumentError for invalid change_message without '%@' placeholder" do
      message = "Balance updated"

      assert_raise ArgumentError, "The change_message must be a string containing the '%@' placeholder for the new value.", fn ->
        FieldContent.new(%{key: "test_key", change_message: message})
      end
    end

    test "new/1 creates a FieldContent struct with valid change_message containing '%@' placeholder" do
      message = "Balance updated to %@"
      result = FieldContent.new(%{key: "test_key", change_message: message})

      assert result.change_message == message
      assert result.key == "test_key"
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("changeMessage":"Balance updated to %@")
    end

    test "new/1 trims whitespace from change_message while preserving '%@' placeholder" do
      message = "  Trimmed message %@  "
      result = FieldContent.new(%{key: "test_key", change_message: message})

      assert result.change_message == "Trimmed message %@"
      assert result.key == "test_key"
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("changeMessage":"Trimmed message %@")
    end
  end

  describe "attributed_value" do
    test "new/1 creates an empty FieldContent struct when no attributes are provided" do
      result = FieldContent.new(%{key: "test_key"})
      assert %FieldContent{attributed_value: nil} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      refute encoded =~ "attributedValue"
    end

    test "new/1 creates a valid FieldContent struct with string" do
      input_string = "Hello, World!"
      result = FieldContent.new(%{key: "test_key", attributed_value: input_string})

      assert %FieldContent{attributed_value: ^input_string} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("attributedValue":"Hello, World!")
    end

    test "new/1 creates a valid FieldContent struct with number" do
      input_number = 42
      result = FieldContent.new(%{key: "test_key", attributed_value: input_number})

      assert %FieldContent{attributed_value: ^input_number} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("attributedValue":42)
    end

    test "new/1 raises ArgumentError for invalid attributed_value types" do
      invalid_values = [%{}, [1, 2, 3], self(), :atom]

      for invalid_value <- invalid_values do
        assert_raise ArgumentError, "Invalid attributed_value type. Supported types are: String (including <a></a> tag), number, DateTime and Date", fn ->
          FieldContent.new(%{key: "test_key", attributed_value: invalid_value})
        end
      end
    end

    test "new/1 creates a valid FieldContent struct with DateTime" do
      input_time = DateTime.utc_now()
      result = FieldContent.new(%{key: "test_key", attributed_value: input_time})

      assert %FieldContent{attributed_value: ^input_time} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("attributedValue":"#{DateTime.to_iso8601(input_time)}")
    end

    test "new/1 creates a valid FieldContent struct with Date" do
      input_date = Date.utc_today()
      result = FieldContent.new(%{key: "test_key", attributed_value: input_date})

      assert %FieldContent{attributed_value: ^input_date} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("attributedValue":"#{Date.to_iso8601(input_date)}")
    end

    test "new/1 raises ArgumentError for attributed_value with unsupported HTML tag" do
      input_value = "<span>Unsupported tag</span>"

      assert_raise ArgumentError, "Supported types are: String (including <a></a> tag), number, DateTime and Date", fn ->
        FieldContent.new(%{key: "test_key", attributed_value: input_value})
      end
    end

    test "new/1 creates a valid FieldContent struct with supported HTML tag" do
      input_value = "<a href='http://example.com'>Link</a>"
      result = FieldContent.new(%{key: "test_key", attributed_value: input_value})

      assert %FieldContent{attributed_value: ^input_value} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("attributedValue":"<a href='http://example.com'>Link</a>")
    end
  end

  describe "currency_code" do
    test "new/1 creates a valid FieldContent struct with valid currency_code as string" do
      result = FieldContent.new(%{key: "test_key", currency_code: "USD"})

      assert %FieldContent{currency_code: "USD"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("currencyCode":"USD")
    end

    test "new/1 creates a valid FieldContent struct with valid currency_code as atom" do
      result = FieldContent.new(%{key: "test_key", currency_code: :USD})

      assert %FieldContent{currency_code: :USD} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("currencyCode":"USD")
    end

    test "new/1 raises ArgumentError for invalid currency_code" do
      assert_raise ArgumentError, ~r/Invalid currency code INVALID/, fn ->
        FieldContent.new(%{key: "test_key", currency_code: "INVALID"})
      end

      assert_raise ArgumentError, ~r/Invalid currency code INVALID/, fn ->
        FieldContent.new(%{key: "test_key", currency_code: :INVALID})
      end
    end

    test "new/1 raises ArgumentError when currency_code is not a string or atom" do
      assert_raise ArgumentError, ~r/Currency code must be a string or atom/, fn ->
        FieldContent.new(%{key: "test_key", currency_code: 123})
      end
    end

    test "new/1 trims whitespace from currency_code string" do
      result = FieldContent.new(%{key: "test_key", currency_code: "  USD  "})

      assert %FieldContent{currency_code: "USD"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("currencyCode":"USD")
    end
  end

  describe "data_detector_types" do
    test "new/1 creates a valid FieldContent struct with valid data_detector_types" do
      result =
        FieldContent.new(%{
          key: "test_key",
          data_detector_types: ["PKDataDetectorTypePhoneNumber", "PKDataDetectorTypeLink"]
        })

      assert %FieldContent{
               data_detector_types: ["PKDataDetectorTypePhoneNumber", "PKDataDetectorTypeLink"]
             } = result

      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")

      assert encoded =~
               ~s("dataDetectorTypes":["PKDataDetectorTypePhoneNumber","PKDataDetectorTypeLink"])
    end

    test "new/1 creates a valid FieldContent struct with empty data_detector_types" do
      result = FieldContent.new(%{key: "test_key", data_detector_types: []})

      assert %FieldContent{data_detector_types: []} = result

      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("dataDetectorTypes":[])
    end

    test "new/1 raises ArgumentError for invalid data_detector_types" do
      assert_raise ArgumentError,
                   ~r/Invalid data detector type: InvalidDetector. Supported types are: PKDataDetectorTypePhoneNumber, PKDataDetectorTypeLink, PKDataDetectorTypeAddress, PKDataDetectorTypeCalendarEvent/,
                   fn ->
                     FieldContent.new(%{
                       key: "test_key",
                       data_detector_types: ["InvalidDetector"]
                     })
                   end
    end

    test "new/1 raises ArgumentError when data_detector_types is not a list" do
      assert_raise ArgumentError, ~r/data_detector_types must be a list/, fn ->
        FieldContent.new(%{
          key: "test_key",
          data_detector_types: "PKDataDetectorTypePhoneNumber"
        })
      end
    end
  end

  describe "date_style" do
    test "new/1 creates a valid FieldContent struct with date_style" do
      result = FieldContent.new(%{key: "test_key", date_style: "PKDateStyleShort"})

      assert %FieldContent{date_style: "PKDateStyleShort"} = result

      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
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
        result = FieldContent.new(%{key: "test_key", date_style: style})
        assert %FieldContent{date_style: ^style} = result
        encoded = Jason.encode!(result)
        assert encoded =~ ~s("key":"test_key")
        assert encoded =~ ~s("dateStyle":"#{style}")
      end
    end

    test "new/1 raises ArgumentError for invalid date_style" do
      assert_raise ArgumentError,
                   ~r/Invalid date_style: InvalidStyle. Supported values are: PKDateStyleNone, PKDateStyleShort, PKDateStyleMedium, PKDateStyleLong, PKDateStyleFull/,
                   fn ->
                     FieldContent.new(%{
                       key: "test_key",
                       date_style: "InvalidStyle"
                     })
                   end
    end

    test "new/1 raises ArgumentError when date_style is not a string" do
      assert_raise ArgumentError, ~r/date_style must be a string/, fn ->
        FieldContent.new(%{key: "test_key", date_style: :PKDateStyleShort})
      end
    end
  end

  describe "ignores_time_zone" do
    test "new/1 creates a valid FieldContent struct with ignores_time_zone set to true" do
      result = FieldContent.new(%{key: "test_key", ignores_time_zone: true})

      assert %FieldContent{ignores_time_zone: true} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("ignoresTimeZone":true)
    end

    test "new/1 creates a valid FieldContent struct with ignores_time_zone set to false" do
      result = FieldContent.new(%{key: "test_key", ignores_time_zone: false})

      assert %FieldContent{ignores_time_zone: false} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("ignoresTimeZone":false)
    end

    test "new/1 defaults to nil when ignores_time_zone is not provided" do
      result = FieldContent.new(%{key: "test_key"})

      assert %FieldContent{ignores_time_zone: nil} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      refute encoded =~ "ignoresTimeZone"
    end

    test "new/1 raises ArgumentError when ignores_time_zone is not a boolean" do
      assert_raise ArgumentError, ~r/ignores_time_zone must be a boolean/, fn ->
        FieldContent.new(%{key: "test_key", ignores_time_zone: "true"})
      end
    end
  end

  describe "is_relative" do
    test "new/1 creates a valid FieldContent struct with is_relative set to true" do
      result = FieldContent.new(%{key: "test_key", is_relative: true})

      assert %FieldContent{is_relative: true} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("isRelative":true)
    end

    test "new/1 creates a valid FieldContent struct with is_relative set to false" do
      result = FieldContent.new(%{key: "test_key", is_relative: false})

      assert %FieldContent{is_relative: false} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("isRelative":false)
    end

    test "new/1 defaults to nil when is_relative is not provided" do
      result = FieldContent.new(%{key: "test_key"})

      assert %FieldContent{is_relative: nil} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      refute encoded =~ "isRelative"
    end

    test "new/1 raises ArgumentError when is_relative is not a boolean" do
      assert_raise ArgumentError, ~r/is_relative must be a boolean/, fn ->
        FieldContent.new(%{key: "test_key", is_relative: "true"})
      end
    end
  end

  describe "key" do
    test "new/1 creates a valid FieldContent struct with a key" do
      result = FieldContent.new(%{key: "unique_identifier"})

      assert %FieldContent{key: "unique_identifier"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"unique_identifier")
    end

    test "new/1 raises ArgumentError when key is not provided" do
      assert_raise ArgumentError, "key is a required field and must be a non-empty string", fn ->
        FieldContent.new(%{})
      end
    end

    test "new/1 raises ArgumentError when key is an empty string" do
      assert_raise ArgumentError, ~r/key cannot be an empty string/, fn ->
        FieldContent.new(%{key: ""})
      end
    end

    test "new/1 raises ArgumentError when key is not a string" do
      assert_raise ArgumentError, "key is a required field and must be a non-empty string", fn ->
        FieldContent.new(%{key: 123})
      end
    end

    test "new/1 trims whitespace from key" do
      result = FieldContent.new(%{key: "  trimmed_key  "})

      assert %FieldContent{key: "trimmed_key"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"trimmed_key")
    end
  end

  describe "label" do
    test "new/1 creates a valid FieldContent struct with a label" do
      result = FieldContent.new(%{key: "test_key", label: "Test Label"})

      assert %FieldContent{key: "test_key", label: "Test Label"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("label":"Test Label")
    end

    test "new/1 creates a valid FieldContent struct without a label" do
      result = FieldContent.new(%{key: "test_key"})

      assert %FieldContent{key: "test_key", label: nil} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      refute encoded =~ "label"
    end

    test "new/1 trims whitespace from label" do
      result = FieldContent.new(%{key: "test_key", label: "  Trimmed Label  "})

      assert %FieldContent{key: "test_key", label: "Trimmed Label"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("label":"Trimmed Label")
    end

    test "new/1 raises ArgumentError when label is not a string" do
      assert_raise ArgumentError, ~r/label must be a string/, fn ->
        FieldContent.new(%{key: "test_key", label: 123})
      end
    end

    test "new/1 allows an empty string for label" do
      result = FieldContent.new(%{key: "test_key", label: ""})

      assert %FieldContent{key: "test_key", label: ""} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("label":"")
    end
  end

  describe "number_style" do
    test "new/1 creates a valid FieldContent struct with number_style" do
      result = FieldContent.new(%{key: "test_key", number_style: "PKNumberStyleDecimal"})

      assert %FieldContent{key: "test_key", number_style: "PKNumberStyleDecimal"} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
      assert encoded =~ ~s("numberStyle":"PKNumberStyleDecimal")
    end

    test "new/1 raises ArgumentError for invalid number_style" do
      assert_raise ArgumentError, ~r/Invalid number_style/, fn ->
        FieldContent.new(%{key: "test_key", number_style: "InvalidStyle"})
      end
    end

    test "new/1 allows nil for number_style" do
      result = FieldContent.new(%{key: "test_key", number_style: nil})

      assert %FieldContent{key: "test_key", number_style: nil} = result
      encoded = Jason.encode!(result)
      assert encoded =~ ~s("key":"test_key")
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
        result = FieldContent.new(%{key: "test_key", number_style: style})

        assert %FieldContent{key: "test_key", number_style: ^style} = result
        encoded = Jason.encode!(result)
        assert encoded =~ ~s("key":"test_key")
        assert encoded =~ ~s("numberStyle":"#{style}")
      end)
    end
  end
end
