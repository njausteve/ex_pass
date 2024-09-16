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
end
