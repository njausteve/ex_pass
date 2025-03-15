defmodule ExPass.Structs.NFCTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ExPass.Structs.NFC

  doctest ExPass.Structs.NFC

  describe "new/0" do
    test "creates a valid NFC struct with default values when called without arguments" do
      assert %NFC{} = nfc = NFC.new()
      assert nfc.requires_authentication == nil
      encoded = Jason.encode!(nfc)
      refute encoded =~ "requiresAuthentication"
    end
  end

  describe "new/1 with requiresAuthentication field" do
    test "creates a valid NFC struct with requiresAuthentication set to true" do
      params = %{requires_authentication: true}

      assert %NFC{} = nfc = NFC.new(params)
      assert nfc.requires_authentication == true
      encoded = Jason.encode!(nfc)
      assert encoded =~ ~s("requiresAuthentication":true)
    end

    test "creates a valid NFC struct with requiresAuthentication set to false" do
      params = %{requires_authentication: false}

      assert %NFC{} = nfc = NFC.new(params)
      assert nfc.requires_authentication == false
      encoded = Jason.encode!(nfc)
      assert encoded =~ ~s("requiresAuthentication":false)
    end

    test "creates a valid NFC struct with requiresAuthentication defaulting to nil when not provided" do
      params = %{}

      assert %NFC{} = nfc = NFC.new(params)
      assert nfc.requires_authentication == nil
      encoded = Jason.encode!(nfc)
      refute encoded =~ "requiresAuthentication"
    end

    test "creates a valid NFC struct with requiresAuthentication set to nil" do
      params = %{requires_authentication: nil}

      assert %NFC{} = nfc = NFC.new(params)
      assert nfc.requires_authentication == nil
      encoded = Jason.encode!(nfc)
      refute encoded =~ "requiresAuthentication"
    end

    test "raises an error for invalid requiresAuthentication (non-boolean value)" do
      params = %{requires_authentication: "true"}

      assert_raise ArgumentError,
                   "requires_authentication must be a boolean value (true or false)",
                   fn ->
                     NFC.new(params)
                   end
    end
  end
end
