defmodule ExPass.Structs.FieldContentTest do
  @moduledoc false

  use ExUnit.Case

  alias ExPass.Structs.FieldContent

  describe "field struct" do
    test "new/1 creates an empty FieldContent struct when no attributes are provided" do
      assert %FieldContent{attributed_value: nil} = FieldContent.new()
    end

    test "new/1 creates a valid FieldContent struct with string" do
      input_string = "Hello, World!"
      result = FieldContent.new(%{attributed_value: input_string})

      assert result.attributed_value == input_string
    end

    test "new/1 creates a valid FieldContent struct with number" do
      input_number = 42
      result = FieldContent.new(%{attributed_value: input_number})

      assert result.attributed_value == input_number
    end

    test "new/1 raises ArgumentError for invalid attributed_value types" do
      invalid_values = [%{}, [1, 2, 3], self(), :stephen]

      for invalid_value <- invalid_values do
        assert_raise ArgumentError, ~r/Invalid attributed_value:/, fn ->
          FieldContent.new(%{attributed_value: invalid_value})
        end
      end
    end

    test "new/1 creates a valid FieldContent struct with DateTime" do
      input_time = DateTime.utc_now()
      result = FieldContent.new(%{attributed_value: input_time})

      assert result.attributed_value == input_time
    end

    test "new/1 creates a valid FieldContent struct with Date" do
      input_date = Date.utc_today()
      result = FieldContent.new(%{attributed_value: input_date})

      assert result.attributed_value == input_date
    end

    test "new/1 raises ArgumentError for attributed_value with unsupported HTML tag" do
      input_value = "<span>Unsupported tag</span>"

      assert_raise ArgumentError, ~r/Invalid attributed_value:/, fn ->
        FieldContent.new(%{attributed_value: input_value})
      end
    end
  end
end
