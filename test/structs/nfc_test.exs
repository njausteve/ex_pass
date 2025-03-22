defmodule ExPass.Structs.NFCTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ExPass.Structs.NFC

  @valid_p256_key "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAELUJ7jY8VfBkjJdHEiOZuX8sSYFTJ1sFR+VNgC2Vd5SYJx1x1F9QJD+hkXjE4wP4IaRyQF5s8zCPgKmXCuPGvdA=="

  doctest ExPass.Structs.NFC

  describe "new/0" do
    test "raises an error when called without arguments" do
      assert_raise ArgumentError, "message is required", fn ->
        NFC.new()
      end
    end
  end

  describe "new/1 with required fields" do
    test "creates a valid NFC struct with required fields" do
      params = %{
        message: "test message",
        encryption_public_key: @valid_p256_key
      }

      nfc = NFC.new(params)

      assert %NFC{
               message: "test message",
               encryption_public_key: @valid_p256_key,
               requires_authentication: nil
             } = nfc

      encoded = Jason.encode!(nfc)
      assert encoded =~ ~s("message":"test message")
      assert encoded =~ ~s("encryptionPublicKey":"#{@valid_p256_key}")
      refute encoded =~ "requiresAuthentication"
    end

    test "raises an error for missing message" do
      assert_raise ArgumentError, "message is required", fn ->
        NFC.new(%{encryption_public_key: @valid_p256_key})
      end
    end

    test "raises an error for missing encryption_public_key" do
      assert_raise ArgumentError, "encryption_public_key is required", fn ->
        NFC.new(%{message: "test message"})
      end
    end
  end

  describe "new/1 with message field" do
    test "raises an error for message exceeding 64 bytes" do
      long_message = String.duplicate("a", 65)

      assert_raise ArgumentError, "message must be no more than 64 bytes", fn ->
        NFC.new(%{
          message: long_message,
          encryption_public_key: @valid_p256_key
        })
      end
    end

    test "raises an error for non-string message" do
      assert_raise ArgumentError, "message must be a string", fn ->
        NFC.new(%{
          message: 123,
          encryption_public_key: @valid_p256_key
        })
      end
    end

    test "accepts a message of exactly 64 bytes" do
      message_64_bytes = String.duplicate("a", 64)

      nfc =
        NFC.new(%{
          message: message_64_bytes,
          encryption_public_key: @valid_p256_key
        })

      assert %NFC{message: ^message_64_bytes} = nfc
      encoded = Jason.encode!(nfc)
      assert encoded =~ ~s("message":"#{message_64_bytes}")
    end
  end

  describe "new/1 with encryption_public_key field" do
    test "raises an error for non-string encryption_public_key" do
      assert_raise ArgumentError, "encryption_public_key must be a string", fn ->
        NFC.new(%{
          message: "test message",
          encryption_public_key: 123
        })
      end
    end

    test "raises an error for empty encryption_public_key" do
      assert_raise ArgumentError, "encryption_public_key is required", fn ->
        NFC.new(%{
          message: "test message",
          encryption_public_key: ""
        })
      end
    end
  end

  describe "new/1 with requiresAuthentication field" do
    test "creates a valid NFC struct with requiresAuthentication set to true" do
      nfc =
        NFC.new(%{
          message: "test message",
          encryption_public_key: @valid_p256_key,
          requires_authentication: true
        })

      assert %NFC{
               message: "test message",
               encryption_public_key: @valid_p256_key,
               requires_authentication: true
             } = nfc

      encoded = Jason.encode!(nfc)
      assert encoded =~ ~s("message":"test message")
      assert encoded =~ ~s("encryptionPublicKey":"#{@valid_p256_key}")
      assert encoded =~ ~s("requiresAuthentication":true)
    end

    test "creates a valid NFC struct with requiresAuthentication set to false" do
      nfc =
        NFC.new(%{
          message: "test message",
          encryption_public_key: @valid_p256_key,
          requires_authentication: false
        })

      assert %NFC{
               message: "test message",
               encryption_public_key: @valid_p256_key,
               requires_authentication: false
             } = nfc

      encoded = Jason.encode!(nfc)
      assert encoded =~ ~s("message":"test message")
      assert encoded =~ ~s("encryptionPublicKey":"#{@valid_p256_key}")
      assert encoded =~ ~s("requiresAuthentication":false)
    end

    test "creates a valid NFC struct with requiresAuthentication defaulting to nil when not provided" do
      nfc =
        NFC.new(%{
          message: "test message",
          encryption_public_key: @valid_p256_key
        })

      assert %NFC{
               message: "test message",
               encryption_public_key: @valid_p256_key,
               requires_authentication: nil
             } = nfc

      encoded = Jason.encode!(nfc)
      assert encoded =~ ~s("message":"test message")
      assert encoded =~ ~s("encryptionPublicKey":"#{@valid_p256_key}")
      refute encoded =~ "requiresAuthentication"
    end

    test "creates a valid NFC struct with requiresAuthentication set to nil" do
      nfc =
        NFC.new(%{
          message: "test message",
          encryption_public_key: @valid_p256_key,
          requires_authentication: nil
        })

      assert %NFC{
               message: "test message",
               encryption_public_key: @valid_p256_key,
               requires_authentication: nil
             } = nfc

      encoded = Jason.encode!(nfc)
      assert encoded =~ ~s("message":"test message")
      assert encoded =~ ~s("encryptionPublicKey":"#{@valid_p256_key}")
      refute encoded =~ "requiresAuthentication"
    end

    test "raises an error for invalid requiresAuthentication (non-boolean value)" do
      assert_raise ArgumentError,
                   "requires_authentication must be a boolean value (true or false)",
                   fn ->
                     NFC.new(%{
                       message: "test message",
                       encryption_public_key: @valid_p256_key,
                       requires_authentication: "true"
                     })
                   end
    end
  end
end
