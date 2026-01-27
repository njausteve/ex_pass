defmodule ExPass.Structs.SemanticTags.CurrencyAmount do
  @moduledoc """
  Represents a currency amount for use in Apple Wallet pass semantic tags.

  This struct is used to represent monetary values with their associated currency,
  commonly used in semantic tags for balance, price, or other financial information.

  ## Fields

  * `:amount` - (Required) The amount of money as a string.
  * `:currency_code` - (Required) The ISO 4217 currency code for the amount (e.g., "USD", "EUR").

  ## Compatibility

  - iOS 12.0+
  - iPadOS 6.0+
  - watchOS 2.0+

  ## Apple Documentation

  See [Apple's PassKit documentation](https://developer.apple.com/documentation/walletpasses/semantictagtype/currencyamount)
  for more information about currency amounts in passes.
  """

  use ExPass.Structs.Base
  use TypedStruct

  alias ExPass.Utils.Converter
  alias ExPass.Utils.Validators

  typedstruct do
    field :amount, String.t(), enforce: true
    field :currency_code, String.t(), enforce: true
  end

  @doc """
  Creates a new CurrencyAmount struct.

  ## Parameters

    * `attrs` - A map of attributes for the CurrencyAmount struct. The map must include:
      * `:amount` - (Required) The amount of money as a string.
      * `:currency_code` - (Required) The ISO 4217 currency code (e.g., "USD", "EUR", "GBP").

  ## Returns

    * A new `%CurrencyAmount{}` struct.

  ## Examples

      iex> CurrencyAmount.new(%{amount: "10.00", currency_code: "USD"})
      %CurrencyAmount{amount: "10.00", currency_code: "USD"}

      iex> CurrencyAmount.new(%{amount: "25.50", currency_code: :EUR})
      %CurrencyAmount{amount: "25.50", currency_code: "EUR"}

      iex> CurrencyAmount.new(%{amount: "100", currency_code: "JPY"})
      %CurrencyAmount{amount: "100", currency_code: "JPY"}

      iex> CurrencyAmount.new(%{currency_code: "USD"})
      ** (ArgumentError) amount is a required field and must be a non-empty string

      iex> CurrencyAmount.new(%{amount: "10.00"})
      ** (ArgumentError) currency_code is required

      iex> CurrencyAmount.new(%{amount: "10.00", currency_code: "INVALID"})
      ** (ArgumentError) Invalid currency code INVALID

  """
  @spec new(map()) :: %__MODULE__{}
  def new(attrs \\ %{}) do
    attrs =
      attrs
      |> Converter.trim_string_values()
      |> normalize_currency_code()
      |> validate(:amount, &Validators.validate_required_string(&1, :amount))
      |> validate(:currency_code, &validate_required_currency_code/1)

    struct!(__MODULE__, attrs)
  end

  # Normalize currency_code from atom to string if provided as atom
  defp normalize_currency_code(attrs) do
    case Map.get(attrs, :currency_code) do
      code when is_atom(code) and not is_nil(code) ->
        Map.put(attrs, :currency_code, Atom.to_string(code))

      _ ->
        attrs
    end
  end

  # Validates that currency_code is present and valid
  defp validate_required_currency_code(nil) do
    {:error, "currency_code is required"}
  end

  defp validate_required_currency_code(value) do
    Validators.validate_currency_code(value)
  end
end
