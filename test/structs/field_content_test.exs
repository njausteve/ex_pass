defmodule ExPass.Structs.FieldContentTest do
  @moduledoc false

  use ExUnit.Case
  alias ExPass.Structs.FieldContent

  doctest FieldContent

  describe "change_message" do
    test "new/1 raises ArgumentError for invalid change_message without '%@' placeholder" do
      message = "Balance updated"

      assert_raise ArgumentError, ~r/Invalid change_message: "Balance updated"/, fn ->
        FieldContent.new(%{change_message: message})
      end
    end

    test "new/1 creates a FieldContent struct with valid change_message containing '%@' placeholder" do
      message = "Balance updated to %@"
      result = FieldContent.new(%{change_message: message})

      assert result.change_message == message
      assert Jason.encode!(result) == ~s({"changeMessage":"Balance updated to %@"})
    end

    test "new/1 trims whitespace from change_message while preserving '%@' placeholder" do
      message = "  Trimmed message %@  "
      result = FieldContent.new(%{change_message: message})

      assert result.change_message == "Trimmed message %@"
      assert Jason.encode!(result) == ~s({"changeMessage":"Trimmed message %@"})
    end
  end

  describe "attributed_value" do
    test "new/1 creates an empty FieldContent struct when no attributes are provided" do
      assert %FieldContent{attributed_value: nil} = FieldContent.new()
      assert Jason.encode!(FieldContent.new()) == ~s({})
    end

    test "new/1 creates a valid FieldContent struct with string" do
      input_string = "Hello, World!"
      result = FieldContent.new(%{attributed_value: input_string})

      assert %FieldContent{attributed_value: ^input_string} = result
      assert Jason.encode!(result) == ~s({"attributedValue":"Hello, World!"})
    end

    test "new/1 creates a valid FieldContent struct with number" do
      input_number = 42
      result = FieldContent.new(%{attributed_value: input_number})

      assert %FieldContent{attributed_value: ^input_number} = result
      assert Jason.encode!(result) == ~s({"attributedValue":42})
    end

    test "new/1 raises ArgumentError for invalid attributed_value types" do
      invalid_values = [%{}, [1, 2, 3], self(), :atom]

      for invalid_value <- invalid_values do
        assert_raise ArgumentError, ~r/Invalid attributed_value:/, fn ->
          FieldContent.new(%{attributed_value: invalid_value})
        end
      end
    end

    test "new/1 creates a valid FieldContent struct with DateTime" do
      input_time = DateTime.utc_now()
      result = FieldContent.new(%{attributed_value: input_time})

      assert %FieldContent{attributed_value: ^input_time} = result
      assert Jason.encode!(result) == ~s({"attributedValue":"#{DateTime.to_iso8601(input_time)}"})
    end

    test "new/1 creates a valid FieldContent struct with Date" do
      input_date = Date.utc_today()
      result = FieldContent.new(%{attributed_value: input_date})

      assert %FieldContent{attributed_value: ^input_date} = result
      assert Jason.encode!(result) == ~s({"attributedValue":"#{Date.to_iso8601(input_date)}"})
    end

    test "new/1 raises ArgumentError for attributed_value with unsupported HTML tag" do
      input_value = "<span>Unsupported tag</span>"

      assert_raise ArgumentError, ~r/Invalid attributed_value:/, fn ->
        FieldContent.new(%{attributed_value: input_value})
      end
    end

    test "new/1 creates a valid FieldContent struct with supported HTML tag" do
      input_value = "<a href='http://example.com'>Link</a>"
      result = FieldContent.new(%{attributed_value: input_value})

      assert %FieldContent{attributed_value: ^input_value} = result

      assert Jason.encode!(result) ==
               ~s({"attributedValue":"<a href='http://example.com'>Link</a>"})
    end
  end

  describe "currency_code" do
    test "new/1 creates a valid FieldContent struct with valid currency_code as string" do
      result = FieldContent.new(%{currency_code: "USD"})

      assert %FieldContent{currency_code: "USD"} = result
      assert Jason.encode!(result) == ~s({"currencyCode":"USD"})
    end

    test "new/1 creates a valid FieldContent struct with valid currency_code as atom" do
      result = FieldContent.new(%{currency_code: :USD})

      assert %FieldContent{currency_code: :USD} = result
      assert Jason.encode!(result) == ~s({"currencyCode":"USD"})
    end

    test "new/1 raises ArgumentError for invalid currency_code" do
      assert_raise ArgumentError, ~r/Invalid currency code INVALID/, fn ->
        FieldContent.new(%{currency_code: "INVALID"})
      end

      assert_raise ArgumentError, ~r/Invalid currency code INVALID/, fn ->
        FieldContent.new(%{currency_code: :INVALID})
      end
    end

    test "new/1 raises ArgumentError when currency_code is not a string or atom" do
      assert_raise ArgumentError, ~r/Currency code must be a string or atom/, fn ->
        FieldContent.new(%{currency_code: 123})
      end
    end

    test "new/1 trims whitespace from currency_code string" do
      result = FieldContent.new(%{currency_code: "  USD  "})

      assert %FieldContent{currency_code: "USD"} = result
      assert Jason.encode!(result) == ~s({"currencyCode":"USD"})
    end
  end

  describe "data_detector_types" do
    test "new/1 creates a valid FieldContent struct with valid data_detector_types" do
      result =
        FieldContent.new(%{
          data_detector_types: ["PKDataDetectorTypePhoneNumber", "PKDataDetectorTypeLink"]
        })

      assert %FieldContent{
               data_detector_types: ["PKDataDetectorTypePhoneNumber", "PKDataDetectorTypeLink"]
             } = result

      assert Jason.encode!(result) ==
               ~s({"dataDetectorTypes":["PKDataDetectorTypePhoneNumber","PKDataDetectorTypeLink"]})
    end

    test "new/1 creates a valid FieldContent struct with empty data_detector_types" do
      result = FieldContent.new(%{data_detector_types: []})

      assert %FieldContent{data_detector_types: []} = result

      assert Jason.encode!(result) == ~s({"dataDetectorTypes":[]})
    end

    test "new/1 raises ArgumentError for invalid data_detector_types" do
      assert_raise ArgumentError,
                   ~r/Invalid data detector type: InvalidDetector. Supported types are: PKDataDetectorTypePhoneNumber, PKDataDetectorTypeLink, PKDataDetectorTypeAddress, PKDataDetectorTypeCalendarEvent/,
                   fn ->
                     FieldContent.new(%{
                       data_detector_types: ["InvalidDetector"]
                     })
                   end
    end

    test "new/1 raises ArgumentError when data_detector_types is not a list" do
      assert_raise ArgumentError, ~r/data_detector_types must be a list/, fn ->
        FieldContent.new(%{
          data_detector_types: "PKDataDetectorTypePhoneNumber"
        })
      end
    end
  end

  describe "date_style" do
    test "new/1 creates a valid FieldContent struct with date_style" do
      result = FieldContent.new(%{date_style: "PKDateStyleShort"})

      assert %FieldContent{date_style: "PKDateStyleShort"} = result

      assert Jason.encode!(result) == ~s({"dateStyle":"PKDateStyleShort"})
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
        result = FieldContent.new(%{date_style: style})
        assert %FieldContent{date_style: ^style} = result
      end
    end

    test "new/1 raises ArgumentError for invalid date_style" do
      assert_raise ArgumentError,
                   ~r/Invalid date_style: InvalidStyle. Supported values are: PKDateStyleNone, PKDateStyleShort, PKDateStyleMedium, PKDateStyleLong, PKDateStyleFull/,
                   fn ->
                     FieldContent.new(%{
                       date_style: "InvalidStyle"
                     })
                   end
    end

    test "new/1 raises ArgumentError when date_style is not a string" do
      assert_raise ArgumentError, ~r/date_style must be a string/, fn ->
        FieldContent.new(%{date_style: :PKDateStyleShort})
      end
    end
  end

  describe "ignores_time_zone" do
    test "new/1 creates a valid FieldContent struct with ignores_time_zone set to true" do
      result = FieldContent.new(%{ignores_time_zone: true})

      assert %FieldContent{ignores_time_zone: true} = result
      assert Jason.encode!(result) == ~s({"ignoresTimeZone":true})
    end

    test "new/1 creates a valid FieldContent struct with ignores_time_zone set to false" do
      result = FieldContent.new(%{ignores_time_zone: false})

      assert %FieldContent{ignores_time_zone: false} = result
      assert Jason.encode!(result) == ~s({"ignoresTimeZone":false})
    end

    test "new/1 defaults to false when ignores_time_zone is not provided" do
      result = FieldContent.new(%{})

      assert %FieldContent{ignores_time_zone: false} = result
      assert Jason.encode!(result) == ~s({})
    end

    test "new/1 raises ArgumentError when ignores_time_zone is not a boolean" do
      assert_raise ArgumentError, ~r/ignores_time_zone must be a boolean/, fn ->
        FieldContent.new(%{ignores_time_zone: "true"})
      end
    end
  end
end
