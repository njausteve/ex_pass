defmodule ExPass.Structs.NFCTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ExPass.Structs.NFC

  doctest ExPass.Structs.NFC

  describe "new/0" do
    test "raises an error when called without arguments" do
      assert_raise ArgumentError, "message is required", fn ->
        NFC.new()
      end
    end
  end

  describe "new/1 with message field" do
    test "creates a valid NFC struct with message field" do
      nfc = NFC.new(%{message: "test message"})
      assert %NFC{message: "test message", requires_authentication: nil} = nfc
      encoded = Jason.encode!(nfc)
      assert encoded =~ ~s("message":"test message")
      refute encoded =~ "requiresAuthentication"
    end

    test "raises an error for missing message" do
      assert_raise ArgumentError, "message is required", fn ->
        NFC.new(%{requires_authentication: true})
      end
    end

    test "raises an error for message exceeding 64 bytes" do
      long_message = String.duplicate("a", 65)

      assert_raise ArgumentError, "message must be no more than 64 bytes", fn ->
        NFC.new(%{message: long_message})
      end
    end

    test "raises an error for non-string message" do
      assert_raise ArgumentError, "message must be a string", fn ->
        NFC.new(%{message: 123})
      end
    end

    test "accepts a message of exactly 64 bytes" do
      message_64_bytes = String.duplicate("a", 64)

      nfc = NFC.new(%{message: message_64_bytes})
      assert %NFC{message: ^message_64_bytes} = nfc
      encoded = Jason.encode!(nfc)
      assert encoded =~ ~s("message":"#{message_64_bytes}")
    end
  end

  describe "new/1 with requiresAuthentication field" do
    test "creates a valid NFC struct with requiresAuthentication set to true" do
      nfc = NFC.new(%{message: "test message", requires_authentication: true})
      assert %NFC{message: "test message", requires_authentication: true} = nfc
      encoded = Jason.encode!(nfc)
      assert encoded =~ ~s("message":"test message")
      assert encoded =~ ~s("requiresAuthentication":true)
    end

    test "creates a valid NFC struct with requiresAuthentication set to false" do
      nfc = NFC.new(%{message: "test message", requires_authentication: false})
      assert %NFC{message: "test message", requires_authentication: false} = nfc
      encoded = Jason.encode!(nfc)
      assert encoded =~ ~s("message":"test message")
      assert encoded =~ ~s("requiresAuthentication":false)
    end

    test "creates a valid NFC struct with requiresAuthentication defaulting to nil when not provided" do
      nfc = NFC.new(%{message: "test message"})
      assert %NFC{message: "test message", requires_authentication: nil} = nfc
      encoded = Jason.encode!(nfc)
      assert encoded =~ ~s("message":"test message")
      refute encoded =~ "requiresAuthentication"
    end

    test "creates a valid NFC struct with requiresAuthentication set to nil" do
      nfc = NFC.new(%{message: "test message", requires_authentication: nil})
      assert %NFC{message: "test message", requires_authentication: nil} = nfc
      encoded = Jason.encode!(nfc)
      assert encoded =~ ~s("message":"test message")
      refute encoded =~ "requiresAuthentication"
    end

    test "raises an error for invalid requiresAuthentication (non-boolean value)" do
      assert_raise ArgumentError,
                   "requires_authentication must be a boolean value (true or false)",
                   fn ->
                     NFC.new(%{message: "test message", requires_authentication: "true"})
                   end
    end
  end
end
