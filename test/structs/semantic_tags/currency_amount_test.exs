defmodule ExPass.Structs.SemanticTags.CurrencyAmountTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ExPass.Structs.SemanticTags.CurrencyAmount

  doctest ExPass.Structs.SemanticTags.CurrencyAmount

  describe "new/0" do
    test "raises an error when called without arguments" do
      assert_raise ArgumentError,
                   "amount is a required field and must be a non-empty string",
                   fn ->
                     CurrencyAmount.new()
                   end
    end
  end

  describe "new/1 with required fields" do
    test "creates a valid CurrencyAmount struct with required fields" do
      params = %{
        amount: "10.00",
        currency_code: "USD"
      }

      currency_amount = CurrencyAmount.new(params)

      assert %CurrencyAmount{
               amount: "10.00",
               currency_code: "USD"
             } = currency_amount

      encoded = Jason.encode!(currency_amount)
      assert encoded =~ ~s("amount":"10.00")
      assert encoded =~ ~s("currencyCode":"USD")
    end

    test "raises an error for missing amount" do
      assert_raise ArgumentError,
                   "amount is a required field and must be a non-empty string",
                   fn ->
                     CurrencyAmount.new(%{currency_code: "USD"})
                   end
    end

    test "raises an error for missing currency_code" do
      assert_raise ArgumentError, "currency_code is required", fn ->
        CurrencyAmount.new(%{amount: "10.00"})
      end
    end
  end

  describe "new/1 with amount field" do
    test "accepts valid amount strings" do
      assert %CurrencyAmount{amount: "10.00"} =
               CurrencyAmount.new(%{amount: "10.00", currency_code: "USD"})

      assert %CurrencyAmount{amount: "0"} =
               CurrencyAmount.new(%{amount: "0", currency_code: "USD"})

      assert %CurrencyAmount{amount: "1000000.99"} =
               CurrencyAmount.new(%{amount: "1000000.99", currency_code: "USD"})
    end

    test "trims whitespace from amount" do
      currency_amount = CurrencyAmount.new(%{amount: "  10.00  ", currency_code: "USD"})
      assert currency_amount.amount == "10.00"
    end

    test "raises an error for empty amount" do
      assert_raise ArgumentError,
                   "amount is a required field and must be a non-empty string",
                   fn ->
                     CurrencyAmount.new(%{amount: "", currency_code: "USD"})
                   end
    end

    test "raises an error for non-string amount" do
      assert_raise ArgumentError,
                   "amount is a required field and must be a non-empty string",
                   fn ->
                     CurrencyAmount.new(%{amount: 10.00, currency_code: "USD"})
                   end
    end

    test "raises an error for nil amount" do
      assert_raise ArgumentError,
                   "amount is a required field and must be a non-empty string",
                   fn ->
                     CurrencyAmount.new(%{amount: nil, currency_code: "USD"})
                   end
    end
  end

  describe "new/1 with currency_code field" do
    test "accepts valid ISO 4217 currency codes as strings" do
      assert %CurrencyAmount{currency_code: "USD"} =
               CurrencyAmount.new(%{amount: "10.00", currency_code: "USD"})

      assert %CurrencyAmount{currency_code: "EUR"} =
               CurrencyAmount.new(%{amount: "10.00", currency_code: "EUR"})

      assert %CurrencyAmount{currency_code: "GBP"} =
               CurrencyAmount.new(%{amount: "10.00", currency_code: "GBP"})

      assert %CurrencyAmount{currency_code: "JPY"} =
               CurrencyAmount.new(%{amount: "10.00", currency_code: "JPY"})

      assert %CurrencyAmount{currency_code: "MYR"} =
               CurrencyAmount.new(%{amount: "10.00", currency_code: "MYR"})
    end

    test "accepts valid ISO 4217 currency codes as atoms and converts to strings" do
      currency_amount = CurrencyAmount.new(%{amount: "10.00", currency_code: :EUR})
      assert currency_amount.currency_code == "EUR"
    end

    test "raises an error for invalid currency code" do
      assert_raise ArgumentError, "Invalid currency code INVALID", fn ->
        CurrencyAmount.new(%{amount: "10.00", currency_code: "INVALID"})
      end
    end

    test "raises an error for nil currency_code" do
      assert_raise ArgumentError, "currency_code is required", fn ->
        CurrencyAmount.new(%{amount: "10.00", currency_code: nil})
      end
    end

    test "raises an error for empty currency_code" do
      assert_raise ArgumentError, "currency_code is required", fn ->
        CurrencyAmount.new(%{amount: "10.00", currency_code: ""})
      end
    end

    test "raises an error for whitespace-only currency_code" do
      assert_raise ArgumentError, "currency_code is required", fn ->
        CurrencyAmount.new(%{amount: "10.00", currency_code: "   "})
      end
    end
  end

  describe "JSON encoding" do
    test "encodes to JSON with camelCase keys" do
      currency_amount = CurrencyAmount.new(%{amount: "25.50", currency_code: "EUR"})
      encoded = Jason.encode!(currency_amount)

      assert encoded =~ ~s("amount":"25.50")
      assert encoded =~ ~s("currencyCode":"EUR")
      refute encoded =~ "currency_code"
    end

    test "produces valid JSON that can be decoded" do
      currency_amount = CurrencyAmount.new(%{amount: "100", currency_code: "JPY"})
      encoded = Jason.encode!(currency_amount)
      decoded = Jason.decode!(encoded)

      assert decoded["amount"] == "100"
      assert decoded["currencyCode"] == "JPY"
    end
  end
end
