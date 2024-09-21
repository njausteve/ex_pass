defmodule ExPass.Structs.FieldContentTest do
  @moduledoc false

  use ExUnit.Case
  alias ExPass.Structs.FieldContent

  doctest FieldContent

  describe "FieldContent struct change_message" do
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

  describe "FieldContent struct attributed_value" do
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
      input = %{attributed_value: 100, currency_code: "USD"}
      result = FieldContent.new(input)

      assert %FieldContent{attributed_value: 100, currency_code: "USD"} = result
      assert Jason.encode!(result) == ~s({"attributedValue":100,"currencyCode":"USD"})
    end

    test "new/1 creates a valid FieldContent struct with valid currency_code as atom" do
      input = %{attributed_value: 100, currency_code: :USD}
      result = FieldContent.new(input)

      assert %FieldContent{attributed_value: 100, currency_code: :USD} = result
      assert Jason.encode!(result) == ~s({"attributedValue":100,"currencyCode":"USD"})
    end

    test "new/1 raises ArgumentError for invalid currency_code" do
      assert_raise ArgumentError, ~r/Invalid currency code INVALID/, fn ->
        FieldContent.new(%{attributed_value: 100, currency_code: "INVALID"})
      end

      assert_raise ArgumentError, ~r/Invalid currency code INVALID/, fn ->
        FieldContent.new(%{attributed_value: 100, currency_code: :INVALID})
      end
    end

    test "new/1 allows nil currency_code" do
      result = FieldContent.new(%{attributed_value: 100})

      assert %FieldContent{attributed_value: 100, currency_code: nil} = result
      assert Jason.encode!(result) == ~s({"attributedValue":100})
    end

    test "new/1 raises ArgumentError when currency_code is not a string or atom" do
      assert_raise ArgumentError, ~r/Currency code must be a string or atom/, fn ->
        FieldContent.new(%{attributed_value: 100, currency_code: 123})
      end
    end

    test "new/1 trims whitespace from currency_code string" do
      result = FieldContent.new(%{currency_code: "  USD  "})

      assert %FieldContent{attributed_value: nil, currency_code: "USD"} = result
      assert Jason.encode!(result) == ~s({"currencyCode":"USD"})
    end
  end

  describe "data_detector_types" do
    test "new/1 creates a valid FieldContent struct with valid data_detector_types" do
      input = %{
        attributed_value: "Contact us at info@example.com",
        data_detector_types: ["PKDataDetectorTypePhoneNumber", "PKDataDetectorTypeLink"]
      }

      result = FieldContent.new(input)

      assert %FieldContent{
               attributed_value: "Contact us at info@example.com",
               data_detector_types: ["PKDataDetectorTypePhoneNumber", "PKDataDetectorTypeLink"]
             } = result

      assert Jason.encode!(result) ==
               ~s({"attributedValue":"Contact us at info@example.com","dataDetectorTypes":["PKDataDetectorTypePhoneNumber","PKDataDetectorTypeLink"]})
    end

    test "new/1 creates a valid FieldContent struct with empty data_detector_types" do
      input = %{attributed_value: "No detectors", data_detector_types: []}
      result = FieldContent.new(input)

      assert %FieldContent{attributed_value: "No detectors", data_detector_types: []} = result

      assert Jason.encode!(result) ==
               ~s({"attributedValue":"No detectors","dataDetectorTypes":[]})
    end

    test "new/1 allows nil data_detector_types" do
      result = FieldContent.new(%{attributed_value: "Default detectors"})

      assert %FieldContent{attributed_value: "Default detectors", data_detector_types: nil} =
               result

      assert Jason.encode!(result) == ~s({"attributedValue":"Default detectors"})
    end

    test "new/1 raises ArgumentError for invalid data_detector_types" do
      assert_raise ArgumentError,
                   ~r/Invalid data detector type: InvalidDetector. Supported types are: PKDataDetectorTypePhoneNumber, PKDataDetectorTypeLink, PKDataDetectorTypeAddress, PKDataDetectorTypeCalendarEvent/,
                   fn ->
                     FieldContent.new(%{
                       attributed_value: "Invalid",
                       data_detector_types: ["InvalidDetector"]
                     })
                   end
    end

    test "new/1 raises ArgumentError when data_detector_types is not a list" do
      assert_raise ArgumentError, ~r/data_detector_types must be a list/, fn ->
        FieldContent.new(%{
          attributed_value: "Invalid",
          data_detector_types: "PKDataDetectorTypePhoneNumber"
        })
      end
    end
  end

  describe "dateStyle" do
    test "new/1 creates a valid FieldContent struct with dateStyle" do
      input = %{attributed_value: "2023-05-01", date_style: "PKDateStyleShort"}
      result = FieldContent.new(input)

      assert %FieldContent{attributed_value: "2023-05-01", date_style: "PKDateStyleShort"} =
               result

      assert Jason.encode!(result) ==
               ~s({"attributedValue":"2023-05-01","dateStyle":"PKDateStyleShort"})
    end

    test "new/1 allows all valid dateStyle values" do
      valid_styles = [
        "PKDateStyleNone",
        "PKDateStyleShort",
        "PKDateStyleMedium",
        "PKDateStyleLong",
        "PKDateStyleFull"
      ]

      for style <- valid_styles do
        result = FieldContent.new(%{attributed_value: "2023-05-01", date_style: style})
        assert %FieldContent{date_style: ^style} = result
      end
    end

    test "new/1 raises ArgumentError for invalid dateStyle" do
      assert_raise ArgumentError,
                   ~r/Invalid date_style: InvalidStyle. Supported values are: PKDateStyleNone, PKDateStyleShort, PKDateStyleMedium, PKDateStyleLong, PKDateStyleFull/,
                   fn ->
                     FieldContent.new(%{
                       attributed_value: "2023-05-01",
                       date_style: "InvalidStyle"
                     })
                   end
    end

    test "new/1 allows nil dateStyle" do
      result = FieldContent.new(%{attributed_value: "2023-05-01"})
      assert %FieldContent{attributed_value: "2023-05-01", date_style: nil} = result
      assert Jason.encode!(result) == ~s({"attributedValue":"2023-05-01"})
    end

    test "new/1 raises ArgumentError when dateStyle is not a string" do
      assert_raise ArgumentError, ~r/date_style must be a string/, fn ->
        FieldContent.new(%{attributed_value: "2023-05-01", date_style: :PKDateStyleShort})
      end
    end
  end
end
