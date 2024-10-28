defmodule ExPass.Structs.Base do
  @moduledoc """
  Base struct for all structs in the ExPass library.
  """

  defmacro __using__(_opts) do
    quote do
      alias ExPass.Utils.Converter

      defp validate(attrs, key, validator) do
        case validator.(attrs[key]) do
          :ok ->
            attrs

          {:error, reason} ->
            raise ArgumentError, reason
        end
      end

      defimpl Jason.Encoder do
        def encode(field_content, opts) do
          field_content
          |> Map.from_struct()
          |> Enum.reduce(%{}, fn
            {_k, nil}, acc -> acc
            {k, v}, acc -> Map.put(acc, Converter.camelize_key(k), v)
          end)
          |> Jason.Encode.map(opts)
        end
      end
    end
  end
end
