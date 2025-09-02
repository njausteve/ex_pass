defmodule ExPass.Structs.PassFields.SecondaryFieldsTest do
  @moduledoc false

  use ExUnit.Case
  alias ExPass.Structs.PassFields.SecondaryFields

  doctest SecondaryFields

  describe "new/0" do
    test "new/0 raises ArgumentError when called with no arguments" do
      assert_raise ArgumentError, "key is a required field and must be a non-empty string", fn ->
        SecondaryFields.new()
      end
    end

    test "creates a new SecondaryFields with minimum required fields" do
      secondary_field = SecondaryFields.new(%{key: "passenger", value: "John Doe"})

      assert %SecondaryFields{
               key: "passenger",
               value: "John Doe"
             } = secondary_field
    end

    test "creates SecondaryFields with all inherited FieldContent fields" do
      datetime = ~U[2023-04-15 14:30:00Z]

      secondary_field =
        SecondaryFields.new(%{
          key: "boarding_time",
          value: datetime,
          attributed_value: "Attributed",
          change_message: "Changed to %@",
          currency_code: "USD",
          data_detector_types: ["PKDataDetectorTypePhoneNumber"],
          date_style: "PKDateStyleShort",
          ignores_time_zone: true,
          is_relative: false,
          label: "Boarding",
          number_style: "PKNumberStyleDecimal",
          text_alignment: "PKTextAlignmentCenter",
          time_style: "PKDateStyleMedium"
        })

      assert secondary_field.key == "boarding_time"
      assert secondary_field.value == datetime
      assert secondary_field.attributed_value == "Attributed"
      assert secondary_field.change_message == "Changed to %@"
      assert secondary_field.currency_code == "USD"
      assert secondary_field.data_detector_types == ["PKDataDetectorTypePhoneNumber"]
      assert secondary_field.date_style == "PKDateStyleShort"
      assert secondary_field.ignores_time_zone == true
      assert secondary_field.is_relative == false
      assert secondary_field.label == "Boarding"
      assert secondary_field.number_style == "PKNumberStyleDecimal"
      assert secondary_field.text_alignment == "PKTextAlignmentCenter"
      assert secondary_field.time_style == "PKDateStyleMedium"
    end
  end

  describe "field trimming" do
    test "trims whitespace from string fields" do
      secondary_field =
        SecondaryFields.new(%{
          key: "  test_key  ",
          value: "  test_value  ",
          label: "  label  "
        })

      assert secondary_field.key == "test_key"
      assert secondary_field.value == "test_value"
      assert secondary_field.label == "label"
    end
  end

  describe "JSON encoding" do
    test "encodes SecondaryFields to JSON with camelCase keys" do
      secondary_field =
        SecondaryFields.new(%{
          key: "class",
          value: "Business",
          label: "Class"
        })

      encoded = Jason.encode!(secondary_field)
      assert encoded =~ ~s("key":"class")
      assert encoded =~ ~s("value":"Business")
      assert encoded =~ ~s("label":"Class")
    end

    test "encodes date values correctly" do
      datetime = ~U[2023-04-15 14:30:00Z]

      secondary_field =
        SecondaryFields.new(%{
          key: "departure",
          value: datetime,
          date_style: "PKDateStyleShort"
        })

      encoded = Jason.encode!(secondary_field)
      assert encoded =~ ~s("key":"departure")
      assert encoded =~ ~s("value":"2023-04-15T14:30:00Z")
      assert encoded =~ ~s("dateStyle":"PKDateStyleShort")
    end

    test "omits nil fields from JSON output" do
      secondary_field =
        SecondaryFields.new(%{
          key: "venue",
          value: "Madison Square Garden"
        })

      encoded = Jason.encode!(secondary_field)

      # Required fields should be present
      assert encoded =~ ~s("key":"venue")
      assert encoded =~ ~s("value":"Madison Square Garden")

      # Nil fields should not be present
      refute encoded =~ ~s("attributedValue")
      refute encoded =~ ~s("changeMessage")
      refute encoded =~ ~s("currencyCode")
      refute encoded =~ ~s("label")
    end
  end

  describe "field validation" do
    test "validates inherited FieldContent fields correctly" do
      # Test invalid time style
      assert_raise ArgumentError,
                   "Invalid time_style: InvalidStyle. Supported values are: PKDateStyleNone, PKDateStyleShort, PKDateStyleMedium, PKDateStyleLong, PKDateStyleFull",
                   fn ->
                     SecondaryFields.new(%{
                       key: "test",
                       value: ~U[2023-04-15 14:30:00Z],
                       time_style: "InvalidStyle"
                     })
                   end

      # Test empty key
      assert_raise ArgumentError,
                   "key is a required field and must be a non-empty string",
                   fn ->
                     SecondaryFields.new(%{
                       key: "",
                       value: "test"
                     })
                   end
    end

    test "validates change_message must contain '%@' placeholder" do
      assert_raise ArgumentError,
                   "The change_message must be a string containing the '%@' placeholder for the new value.",
                   fn ->
                     SecondaryFields.new(%{
                       key: "test",
                       value: "test",
                       change_message: "No placeholder"
                     })
                   end
    end

    test "accepts valid change_message with '%@' placeholder" do
      secondary_field =
        SecondaryFields.new(%{
          key: "test",
          value: "test",
          change_message: "Passenger changed to %@"
        })

      assert secondary_field.change_message == "Passenger changed to %@"
    end

    test "validates boolean fields" do
      secondary_field =
        SecondaryFields.new(%{
          key: "test",
          value: "test",
          ignores_time_zone: false,
          is_relative: true
        })

      assert secondary_field.ignores_time_zone == false
      assert secondary_field.is_relative == true
    end
  end
end
