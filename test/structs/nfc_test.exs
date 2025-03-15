defmodule ExPass.Structs.NFCTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ExPass.Structs.NFC

  doctest ExPass.Structs.NFC

  describe "new/0" do
    test "creates a valid NFC struct with default values when called without arguments" do
      nfc = NFC.new()
      assert %NFC{requires_authentication: nil} = nfc
      refute Jason.encode!(nfc) =~ "requiresAuthentication"
    end
  end

  describe "new/1 with requiresAuthentication field" do
    test "creates a valid NFC struct with requiresAuthentication set to true" do
      nfc = NFC.new(%{requires_authentication: true})
      assert %NFC{requires_authentication: true} = nfc
      assert Jason.encode!(nfc) =~ ~s("requiresAuthentication":true)
    end

    test "creates a valid NFC struct with requiresAuthentication set to false" do
      nfc = NFC.new(%{requires_authentication: false})
      assert %NFC{requires_authentication: false} = nfc
      assert Jason.encode!(nfc) =~ ~s("requiresAuthentication":false)
    end

    test "creates a valid NFC struct with requiresAuthentication defaulting to nil when not provided" do
      nfc = NFC.new(%{})
      assert %NFC{requires_authentication: nil} = nfc
      refute Jason.encode!(nfc) =~ "requiresAuthentication"
    end

    test "creates a valid NFC struct with requiresAuthentication set to nil" do
      nfc = NFC.new(%{requires_authentication: nil})
      assert %NFC{requires_authentication: nil} = nfc
      refute Jason.encode!(nfc) =~ "requiresAuthentication"
    end

    test "raises an error for invalid requiresAuthentication (non-boolean value)" do
      assert_raise ArgumentError,
                   "requires_authentication must be a boolean value (true or false)",
                   fn ->
                     NFC.new(%{requires_authentication: "true"})
                   end
    end
  end
end
