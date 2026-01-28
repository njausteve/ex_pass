defmodule ExPass.Structs.PassFields.PrimaryFieldsTest do
  @moduledoc false

  use ExUnit.Case
  alias ExPass.Structs.PassFields.PrimaryFields

  doctest PrimaryFields

  describe "new/0" do
    test "new/0 raises ArgumentError when called with no arguments" do
      assert_raise ArgumentError, "key is a required field and must be a non-empty string", fn ->
        PrimaryFields.new()
      end
    end

    test "creates a new PrimaryFields with minimum required fields" do
      primary_field = PrimaryFields.new(%{key: "origin", value: "SFO"})

      assert %PrimaryFields{
               key: "origin",
               value: "SFO"
             } = primary_field
    end

    test "creates PrimaryFields with all inherited FieldContent fields" do
      datetime = ~U[2023-04-15 14:30:00Z]

      primary_field =
        PrimaryFields.new(%{
          key: "event_date",
          value: datetime,
          attributed_value: "Attributed",
          change_message: "Changed to %@",
          currency_code: "USD",
          data_detector_types: ["PKDataDetectorTypePhoneNumber"],
          date_style: "PKDateStyleShort",
          ignores_time_zone: true,
          is_relative: false,
          label: "Event Date",
          number_style: "PKNumberStyleDecimal",
          text_alignment: "PKTextAlignmentCenter",
          time_style: "PKDateStyleMedium"
        })

      assert primary_field.key == "event_date"
      assert primary_field.value == datetime
      assert primary_field.attributed_value == "Attributed"
      assert primary_field.change_message == "Changed to %@"
      assert primary_field.currency_code == "USD"
      assert primary_field.data_detector_types == ["PKDataDetectorTypePhoneNumber"]
      assert primary_field.date_style == "PKDateStyleShort"
      assert primary_field.ignores_time_zone == true
      assert primary_field.is_relative == false
      assert primary_field.label == "Event Date"
      assert primary_field.number_style == "PKNumberStyleDecimal"
      assert primary_field.text_alignment == "PKTextAlignmentCenter"
      assert primary_field.time_style == "PKDateStyleMedium"
    end
  end

  describe "field trimming" do
    test "trims whitespace from string fields" do
      primary_field =
        PrimaryFields.new(%{
          key: "  test_key  ",
          value: "  test_value  ",
          label: "  label  "
        })

      assert primary_field.key == "test_key"
      assert primary_field.value == "test_value"
      assert primary_field.label == "label"
    end
  end

  describe "JSON encoding" do
    test "encodes PrimaryFields to JSON with camelCase keys" do
      primary_field =
        PrimaryFields.new(%{
          key: "origin",
          value: "LAX",
          label: "Los Angeles"
        })

      encoded = Jason.encode!(primary_field)
      assert encoded =~ ~s("key":"origin")
      assert encoded =~ ~s("value":"LAX")
      assert encoded =~ ~s("label":"Los Angeles")
    end

    test "encodes numeric values correctly" do
      primary_field =
        PrimaryFields.new(%{
          key: "balance",
          value: 125.50,
          currency_code: "USD"
        })

      encoded = Jason.encode!(primary_field)
      assert encoded =~ ~s("key":"balance")
      assert encoded =~ ~s("value":125.5)
      assert encoded =~ ~s("currencyCode":"USD")
    end

    test "omits nil fields from JSON output" do
      primary_field =
        PrimaryFields.new(%{
          key: "destination",
          value: "JFK"
        })

      encoded = Jason.encode!(primary_field)

      # Required fields should be present
      assert encoded =~ ~s("key":"destination")
      assert encoded =~ ~s("value":"JFK")

      # Nil fields should not be present
      refute encoded =~ ~s("attributedValue")
      refute encoded =~ ~s("changeMessage")
      refute encoded =~ ~s("currencyCode")
      refute encoded =~ ~s("label")
    end
  end

  describe "field validation" do
    test "validates inherited FieldContent fields correctly" do
      # Test invalid text alignment
      assert_raise ArgumentError,
                   "Invalid text_alignment: InvalidAlignment. Supported values are: PKTextAlignmentLeft, PKTextAlignmentCenter, PKTextAlignmentRight, PKTextAlignmentNatural",
                   fn ->
                     PrimaryFields.new(%{
                       key: "test",
                       value: "test",
                       text_alignment: "InvalidAlignment"
                     })
                   end

      # Test invalid currency code
      assert_raise ArgumentError,
                   "Invalid currency code US",
                   fn ->
                     PrimaryFields.new(%{
                       key: "test",
                       value: 100,
                       currency_code: "US"
                     })
                   end
    end

    test "validates change_message must contain '%@' placeholder" do
      assert_raise ArgumentError,
                   "The change_message must be a string containing the '%@' placeholder for the new value.",
                   fn ->
                     PrimaryFields.new(%{
                       key: "test",
                       value: "test",
                       change_message: "No placeholder"
                     })
                   end
    end

    test "accepts valid change_message with '%@' placeholder" do
      primary_field =
        PrimaryFields.new(%{
          key: "test",
          value: "test",
          change_message: "Destination changed to %@"
        })

      assert primary_field.change_message == "Destination changed to %@"
    end
  end
end
