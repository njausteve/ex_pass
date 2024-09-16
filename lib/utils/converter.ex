defmodule ExPass.Utils.Converter do
  @moduledoc """
  Provides utility functions for converting data structures,
  focusing on key format conversions.
  """

  @doc """
  Trims whitespace from string values in a map while preserving non-string values.

  This function iterates through the key-value pairs of the input map. For each pair,
  if the value is a string, it trims leading and trailing whitespace. Non-string
  values are left unchanged.

  ## Parameters

    * `attrs` - A map containing key-value pairs to be processed.

  ## Returns

    * A new map with the same keys as the input, but with string values trimmed.

  ## Examples

      iex> attrs = %{name: "  John Doe  ", age: 30, email: " john@example.com "}
      iex> ExPass.Utils.Converter.trim_string_values(attrs)
      %{name: "John Doe", age: 30, email: "john@example.com"}

  """
  @spec trim_string_values(map()) :: map()
  def trim_string_values(attrs) do
    Map.new(attrs, fn {key, value} ->
      trimmed_value = if is_binary(value), do: String.trim(value), else: value
      {key, trimmed_value}
    end)
  end

  @doc """
  Converts a key (atom or string) to camelCase format.

  ## Examples

      iex> ExPass.Utils.Converter.camelize_key(:user_name)
      :userName

      iex> ExPass.Utils.Converter.camelize_key("first_name")
      "firstName"

  """
  @spec camelize_key(atom | String.t()) :: atom | String.t()
  def camelize_key(key) when is_atom(key) do
    key
    |> Atom.to_string()
    |> camelize_string()
    |> String.to_atom()
  end

  def camelize_key(key) when is_binary(key) do
    camelize_string(key)
  end

  defp camelize_string(string) do
    string
    |> String.split("_")
    |> Enum.map_join("", &capitalize_or_preserve/1)
    |> lcfirst()
  end

  defp capitalize_or_preserve(segment) do
    if String.upcase(segment) == segment do
      segment
    else
      String.capitalize(segment)
    end
  end

  defp lcfirst(<<first::utf8, rest::binary>>), do: String.downcase(<<first::utf8>>) <> rest
end
