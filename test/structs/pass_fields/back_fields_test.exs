defmodule ExPass.Structs.PassFields.BackFieldsTest do
  @moduledoc false

  use ExUnit.Case
  alias ExPass.Structs.PassFields.BackFields

  doctest BackFields

  describe "new/0" do
    test "new/0 raises ArgumentError when called with no arguments" do
      assert_raise ArgumentError, "key is a required field and must be a non-empty string", fn ->
        BackFields.new()
      end
    end

    test "creates a new BackFields with minimum required fields" do
      back_field = BackFields.new(%{key: "terms", value: "Terms and Conditions"})

      assert %BackFields{
               key: "terms",
               value: "Terms and Conditions"
             } = back_field
    end

    test "creates BackFields with all inherited FieldContent fields" do
      datetime = ~U[2023-04-15 14:30:00Z]

      back_field =
        BackFields.new(%{
          key: "info",
          value: datetime,
          attributed_value: "Attributed",
          change_message: "Changed to %@",
          currency_code: "USD",
          data_detector_types: ["PKDataDetectorTypePhoneNumber"],
          date_style: "PKDateStyleShort",
          ignores_time_zone: true,
          is_relative: false,
          label: "Information",
          number_style: "PKNumberStyleDecimal",
          text_alignment: "PKTextAlignmentCenter",
          time_style: "PKDateStyleMedium"
        })

      assert back_field.key == "info"
      assert back_field.value == datetime
      assert back_field.attributed_value == "Attributed"
      assert back_field.change_message == "Changed to %@"
      assert back_field.currency_code == "USD"
      assert back_field.data_detector_types == ["PKDataDetectorTypePhoneNumber"]
      assert back_field.date_style == "PKDateStyleShort"
      assert back_field.ignores_time_zone == true
      assert back_field.is_relative == false
      assert back_field.label == "Information"
      assert back_field.number_style == "PKNumberStyleDecimal"
      assert back_field.text_alignment == "PKTextAlignmentCenter"
      assert back_field.time_style == "PKDateStyleMedium"
    end
  end

  describe "field trimming" do
    test "trims whitespace from string fields" do
      back_field =
        BackFields.new(%{
          key: "  test_key  ",
          value: "  test_value  ",
          label: "  label  "
        })

      assert back_field.key == "test_key"
      assert back_field.value == "test_value"
      assert back_field.label == "label"
    end
  end

  describe "JSON encoding" do
    test "encodes BackFields to JSON with camelCase keys" do
      back_field =
        BackFields.new(%{
          key: "terms",
          value: "Terms",
          label: "Terms & Conditions"
        })

      encoded = Jason.encode!(back_field)
      assert encoded =~ ~s("key":"terms")
      assert encoded =~ ~s("value":"Terms")
      assert encoded =~ ~s("label":"Terms & Conditions")
    end

    test "omits nil fields from JSON output" do
      back_field =
        BackFields.new(%{
          key: "info",
          value: "Information"
        })

      encoded = Jason.encode!(back_field)

      # Required fields should be present
      assert encoded =~ ~s("key":"info")
      assert encoded =~ ~s("value":"Information")

      # Nil fields should not be present
      refute encoded =~ ~s("attributedValue")
      refute encoded =~ ~s("changeMessage")
      refute encoded =~ ~s("currencyCode")
      refute encoded =~ ~s("label")
    end
  end

  describe "field validation" do
    test "validates inherited FieldContent fields correctly" do
      # Test invalid data detector types
      assert_raise ArgumentError,
                   "Invalid data_detector_types: InvalidType. Supported values are: PKDataDetectorTypePhoneNumber, PKDataDetectorTypeLink, PKDataDetectorTypeAddress, PKDataDetectorTypeCalendarEvent",
                   fn ->
                     BackFields.new(%{
                       key: "test",
                       value: "test",
                       data_detector_types: ["InvalidType"]
                     })
                   end

      # Test invalid date style
      assert_raise ArgumentError,
                   "Invalid date_style: InvalidStyle. Supported values are: PKDateStyleNone, PKDateStyleShort, PKDateStyleMedium, PKDateStyleLong, PKDateStyleFull",
                   fn ->
                     BackFields.new(%{
                       key: "test",
                       value: "test",
                       date_style: "InvalidStyle"
                     })
                   end
    end

    test "validates change_message must contain '%@' placeholder" do
      assert_raise ArgumentError,
                   "The change_message must be a string containing the '%@' placeholder for the new value.",
                   fn ->
                     BackFields.new(%{
                       key: "test",
                       value: "test",
                       change_message: "No placeholder"
                     })
                   end
    end

    test "accepts valid change_message with '%@' placeholder" do
      back_field =
        BackFields.new(%{
          key: "test",
          value: "test",
          change_message: "Value changed to %@"
        })

      assert back_field.change_message == "Value changed to %@"
    end
  end
end
