defmodule ExPass.Structs.PassFields.HeaderFieldsTest do
  @moduledoc false

  use ExUnit.Case
  alias ExPass.Structs.PassFields.HeaderFields

  doctest HeaderFields

  describe "new/0" do
    test "new/0 raises ArgumentError when called with no arguments" do
      assert_raise ArgumentError, "key is a required field and must be a non-empty string", fn ->
        HeaderFields.new()
      end
    end

    test "creates a new HeaderFields with minimum required fields" do
      header_field = HeaderFields.new(%{key: "header_key", value: "header_value"})

      assert %HeaderFields{
               key: "header_key",
               value: "header_value"
             } = header_field
    end

    test "creates HeaderFields with all inherited FieldContent fields" do
      datetime = ~U[2023-04-15 14:30:00Z]

      header_field =
        HeaderFields.new(%{
          key: "header_key",
          value: datetime,
          attributed_value: "Attributed",
          change_message: "Changed to %@",
          currency_code: "USD",
          data_detector_types: ["PKDataDetectorTypePhoneNumber"],
          date_style: "PKDateStyleShort",
          ignores_time_zone: true,
          is_relative: false,
          label: "Header Label",
          number_style: "PKNumberStyleDecimal",
          text_alignment: "PKTextAlignmentCenter",
          time_style: "PKDateStyleMedium"
        })

      assert header_field.key == "header_key"
      assert header_field.value == datetime
      assert header_field.attributed_value == "Attributed"
      assert header_field.change_message == "Changed to %@"
      assert header_field.currency_code == "USD"
      assert header_field.data_detector_types == ["PKDataDetectorTypePhoneNumber"]
      assert header_field.date_style == "PKDateStyleShort"
      assert header_field.ignores_time_zone == true
      assert header_field.is_relative == false
      assert header_field.label == "Header Label"
      assert header_field.number_style == "PKNumberStyleDecimal"
      assert header_field.text_alignment == "PKTextAlignmentCenter"
      assert header_field.time_style == "PKDateStyleMedium"
    end

    test "does not define a row field" do
      header_field = HeaderFields.new(%{key: "test", value: "value"})

      refute Map.has_key?(header_field, :row)
    end

    test "trims whitespace from string fields" do
      header_field =
        HeaderFields.new(%{
          key: "  test_key  ",
          value: "  test_value  ",
          label: "  label  "
        })

      assert header_field.key == "test_key"
      assert header_field.value == "test_value"
      assert header_field.label == "label"
    end
  end

  describe "JSON encoding" do
    test "encodes HeaderFields to JSON with camelCase keys" do
      header_field =
        HeaderFields.new(%{
          key: "header_key",
          value: "header_value",
          label: "Header",
          change_message: "Changed to %@"
        })

      encoded = Jason.encode!(header_field)
      assert encoded =~ ~s("key":"header_key")
      assert encoded =~ ~s("value":"header_value")
      assert encoded =~ ~s("label":"Header")
      assert encoded =~ ~s("changeMessage":"Changed to %@")
    end

    test "omits nil fields from JSON output" do
      header_field =
        HeaderFields.new(%{
          key: "header_key",
          value: "header_value"
        })

      encoded = Jason.encode!(header_field)

      # Required fields and non-nil fields should be present
      assert encoded =~ ~s("key":"header_key")
      assert encoded =~ ~s("value":"header_value")

      # Nil fields should not be present
      refute encoded =~ ~s("attributedValue")
      refute encoded =~ ~s("changeMessage")
      refute encoded =~ ~s("currencyCode")
      refute encoded =~ ~s("label")
    end

    test "does not encode a row key" do
      header_field = HeaderFields.new(%{key: "header_key", value: "header_value"})

      refute Jason.encode!(header_field) =~ ~s("row")
    end
  end

  describe "field validation" do
    test "validates inherited FieldContent fields correctly" do
      # Test invalid data detector types
      assert_raise ArgumentError,
                   "Invalid data_detector_types: InvalidType. Supported values are: PKDataDetectorTypePhoneNumber, PKDataDetectorTypeLink, PKDataDetectorTypeAddress, PKDataDetectorTypeCalendarEvent",
                   fn ->
                     HeaderFields.new(%{
                       key: "test",
                       value: "test",
                       data_detector_types: ["InvalidType"]
                     })
                   end

      # Test invalid date style
      assert_raise ArgumentError,
                   "Invalid date_style: InvalidStyle. Supported values are: PKDateStyleNone, PKDateStyleShort, PKDateStyleMedium, PKDateStyleLong, PKDateStyleFull",
                   fn ->
                     HeaderFields.new(%{
                       key: "test",
                       value: "test",
                       date_style: "InvalidStyle"
                     })
                   end

      # Test invalid number style
      assert_raise ArgumentError,
                   "Invalid number_style: InvalidStyle. Supported values are: PKNumberStyleDecimal, PKNumberStylePercent, PKNumberStyleScientific, PKNumberStyleSpellOut",
                   fn ->
                     HeaderFields.new(%{
                       key: "test",
                       value: "test",
                       number_style: "InvalidStyle"
                     })
                   end
    end

    test "validates change_message must contain '%@' placeholder" do
      assert_raise ArgumentError,
                   "The change_message must be a string containing the '%@' placeholder for the new value.",
                   fn ->
                     HeaderFields.new(%{
                       key: "test",
                       value: "test",
                       change_message: "No placeholder"
                     })
                   end
    end

    test "accepts valid change_message with '%@' placeholder" do
      header_field =
        HeaderFields.new(%{
          key: "test",
          value: "test",
          change_message: "Value changed to %@"
        })

      assert header_field.change_message == "Value changed to %@"
    end
  end
end
