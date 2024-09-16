defmodule ExPass.Utils.Converter do
  @moduledoc """
  Provides utility functions for converting data structures,
  focusing on key format conversions.
  """

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
