defmodule ExPass.Structs.PassFields.AuxiliaryFieldsTest do
  @moduledoc false

  use ExUnit.Case
  alias ExPass.Structs.PassFields.AuxiliaryFields

  doctest AuxiliaryFields

  describe "new/0" do
    test "new/0 raises ArgumentError when called with no arguments" do
      assert_raise ArgumentError, "key is a required field and must be a non-empty string", fn ->
        AuxiliaryFields.new()
      end
    end

    test "creates a new AuxiliaryFields with minimum required fields" do
      auxiliary_field = AuxiliaryFields.new(%{key: "aux_key", value: "aux_value"})
      
      assert %AuxiliaryFields{
        key: "aux_key",
        value: "aux_value",
        row: 0
      } = auxiliary_field
    end

    test "creates AuxiliaryFields with all inherited FieldContent fields" do
      datetime = ~U[2023-04-15 14:30:00Z]
      
      auxiliary_field = AuxiliaryFields.new(%{
        key: "aux_key",
        value: datetime,
        attributed_value: "Attributed",
        change_message: "Changed to %@",
        currency_code: "USD",
        data_detector_types: ["PKDataDetectorTypePhoneNumber"],
        date_style: "PKDateStyleShort",
        ignores_time_zone: true,
        is_relative: false,
        label: "Auxiliary Label",
        number_style: "PKNumberStyleDecimal",
        text_alignment: "PKTextAlignmentCenter",
        time_style: "PKDateStyleMedium"
      })
      
      assert auxiliary_field.key == "aux_key"
      assert auxiliary_field.value == datetime
      assert auxiliary_field.attributed_value == "Attributed"
      assert auxiliary_field.change_message == "Changed to %@"
      assert auxiliary_field.currency_code == "USD"
      assert auxiliary_field.data_detector_types == ["PKDataDetectorTypePhoneNumber"]
      assert auxiliary_field.date_style == "PKDateStyleShort"
      assert auxiliary_field.ignores_time_zone == true
      assert auxiliary_field.is_relative == false
      assert auxiliary_field.label == "Auxiliary Label"
      assert auxiliary_field.number_style == "PKNumberStyleDecimal"
      assert auxiliary_field.text_alignment == "PKTextAlignmentCenter"
      assert auxiliary_field.time_style == "PKDateStyleMedium"
      assert auxiliary_field.row == 0
    end
  end

  describe "row field" do
    test "defaults to 0 when not specified" do
      auxiliary_field = AuxiliaryFields.new(%{key: "test", value: "value"})
      assert auxiliary_field.row == 0
    end

    test "accepts 0 as a valid row value" do
      auxiliary_field = AuxiliaryFields.new(%{key: "test", value: "value", row: 0})
      assert auxiliary_field.row == 0
    end

    test "accepts 1 as a valid row value" do
      auxiliary_field = AuxiliaryFields.new(%{key: "test", value: "value", row: 1})
      assert auxiliary_field.row == 1
    end

    test "raises ArgumentError for invalid row values" do
      assert_raise ArgumentError, "row must be 0 or 1", fn ->
        AuxiliaryFields.new(%{key: "test", value: "value", row: 2})
      end

      assert_raise ArgumentError, "row must be 0 or 1", fn ->
        AuxiliaryFields.new(%{key: "test", value: "value", row: -1})
      end

      assert_raise ArgumentError, "row must be 0 or 1", fn ->
        AuxiliaryFields.new(%{key: "test", value: "value", row: "invalid"})
      end
    end

    test "trims whitespace from string fields" do
      auxiliary_field = AuxiliaryFields.new(%{
        key: "  test_key  ",
        value: "  test_value  ",
        label: "  label  "
      })
      
      assert auxiliary_field.key == "test_key"
      assert auxiliary_field.value == "test_value"
      assert auxiliary_field.label == "label"
    end
  end

  describe "JSON encoding" do
    test "encodes AuxiliaryFields to JSON with camelCase keys" do
      auxiliary_field = AuxiliaryFields.new(%{
        key: "aux_key",
        value: "aux_value",
        label: "Auxiliary",
        row: 1
      })
      
      encoded = Jason.encode!(auxiliary_field)
      assert encoded =~ ~s("key":"aux_key")
      assert encoded =~ ~s("value":"aux_value")
      assert encoded =~ ~s("label":"Auxiliary")
      assert encoded =~ ~s("row":1)
    end

    test "encodes AuxiliaryFields with default row value" do
      auxiliary_field = AuxiliaryFields.new(%{
        key: "aux_key",
        value: "aux_value"
      })
      
      encoded = Jason.encode!(auxiliary_field)
      assert encoded =~ ~s("key":"aux_key")
      assert encoded =~ ~s("value":"aux_value")
      assert encoded =~ ~s("row":0)
    end

    test "omits nil fields from JSON output" do
      auxiliary_field = AuxiliaryFields.new(%{
        key: "aux_key",
        value: "aux_value",
        row: 1
      })
      
      encoded = Jason.encode!(auxiliary_field)
      
      # Required fields and non-nil fields should be present
      assert encoded =~ ~s("key":"aux_key")
      assert encoded =~ ~s("value":"aux_value")
      assert encoded =~ ~s("row":1)
      
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
                     AuxiliaryFields.new(%{
                       key: "test",
                       value: "test",
                       data_detector_types: ["InvalidType"]
                     })
                   end

      # Test invalid date style
      assert_raise ArgumentError,
                   "Invalid date_style: InvalidStyle. Supported values are: PKDateStyleNone, PKDateStyleShort, PKDateStyleMedium, PKDateStyleLong, PKDateStyleFull",
                   fn ->
                     AuxiliaryFields.new(%{
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
                     AuxiliaryFields.new(%{
                       key: "test",
                       value: "test",
                       change_message: "No placeholder"
                     })
                   end
    end

    test "accepts valid change_message with '%@' placeholder" do
      auxiliary_field = AuxiliaryFields.new(%{
        key: "test",
        value: "test",
        change_message: "Value changed to %@"
      })
      
      assert auxiliary_field.change_message == "Value changed to %@"
    end
  end
end