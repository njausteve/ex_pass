defmodule ExPass.Utils.Validators do
  @moduledoc """
  Provides validation functions for ExPass data types.

  This module contains utility functions to validate different types of data
  used in pass creation and management, ensuring they meet required formats
  and constraints.

  These validators are primarily used internally by other ExPass modules.
  """

  @doc """
  Validates the type of the attributed value.

  This function checks if the given value is of a valid type for an attributed value.
  Valid types include numbers, strings, DateTime, and Date.

  ## Parameters

    * `value` - The value to be validated.

  ## Returns

    * `:ok` if the value is of a valid type.
    * `{:error, "invalid attributed_value type"}` if the value is not of a valid type.

  ## Examples

      iex> validate_attributed_value(42)
      :ok

      iex> validate_attributed_value("string")
      :ok

      iex> validate_attributed_value(DateTime.utc_now())
      :ok

      iex> validate_attributed_value(Date.utc_today())
      :ok

      iex> validate_attributed_value(%{})
      {:error, "invalid attributed_value type"}

  """
  @spec validate_attributed_value(String.t() | number() | DateTime.t() | Date.t() | nil) ::
          :ok | {:error, String.t()}
  def validate_attributed_value(nil), do: :ok
  def validate_attributed_value(value) when is_number(value), do: :ok

  def validate_attributed_value(value) when is_binary(value) do
    case contains_unsupported_html_tags?(value) do
      true -> {:error, "contains unsupported HTML tags"}
      false -> :ok
    end
  end

  def validate_attributed_value(%DateTime{} = value) do
    DateTime.to_iso8601(value)

    :ok
  end

  def validate_attributed_value(%Date{} = value) do
    Date.to_iso8601(value)

    :ok
  end

  def validate_attributed_value(_), do: {:error, "invalid attributed_value type"}

  defp contains_unsupported_html_tags?(string) do
    # Remove all valid anchor tags
    string_without_anchors = String.replace(string, ~r{<a\s[^>]*>.*?</a>|<a\s[^>]*/>}, "")

    # Check if any HTML tags remain
    Regex.match?(~r{<[^>]+>}, string_without_anchors)
  end
end
