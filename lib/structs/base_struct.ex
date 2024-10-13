defmodule ExPass.Structs.BaseStruct do
  @moduledoc """
  A base module for ExPass structs that provides common functionality.

  This module is designed to be used with `use` in other struct modules.
  It injects helper functions and implementations that are commonly needed
  across different structs in the ExPass library.

  ## Usage

  Add `use ExPass.Structs.BaseStruct` to your struct module:

      `use ExPass.Structs.BaseStruct`

  ## What gets injected

  When you use this module, the following are injected into your struct:

  1. A private `validate/3` function for attribute validation
  2. A Jason.Encoder implementation for JSON serialization

  ### The validate/3 function

  This function is used to validate struct attributes:

      defp validate(attrs, key, validator) do
        case validator.(attrs[key]) do
          :ok ->
            attrs
          {:error, reason} ->
            raise ArgumentError, reason
        end
      end

  ### Jason.Encoder implementation

  This implementation allows for easy JSON serialization of your struct:

  - It removes nil values
  - It camelizes keys using `ExPass.Utils.Converter.camelize_key/1`
  - It uses the Jason library for encoding

  Example usage:

      iex> struct = %YourStruct{field1: "value1", field2: nil, snake_case_field: "value3"}
      iex> Jason.encode!(struct)
      "{\\"field1\\":\\"value1\\",\\"snakeCaseField\\":\\"value3\\"}"

  Note: Ensure that you have the Jason library in your dependencies for JSON encoding to work.
  """

  defmacro __using__(_opts) do
    quote do
      defp validate(attrs, key, validator) do
        case validator.(attrs[key]) do
          :ok ->
            attrs

          {:error, reason} ->
            raise ArgumentError, reason
        end
      end

      defimpl Jason.Encoder do
        def encode(struct, opts) do
          struct
          |> Map.from_struct()
          |> Enum.reduce(%{}, fn
            {_k, nil}, acc -> acc
            {k, v}, acc -> Map.put(acc, ExPass.Utils.Converter.camelize_key(k), v)
          end)
          |> Jason.Encode.map(opts)
        end
      end
    end
  end
end
