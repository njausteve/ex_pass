defmodule ExPass.Structs.NFCTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ExPass.Structs.NFC

  @valid_p256_public_key "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEHhqHrZCQZA1uXSXKBNJBCl+h3fHzX6qXzjXwNzDDHJKwXzhpUeWi9xR9AbiGZWczKXZkNAWoZXGzxQpCg/v6Ug=="

  describe "new/0" do
    test "raises ArgumentError when encryption_public_key is not provided" do
      assert_raise ArgumentError, ~r/encryption_public_key is required/, fn ->
        NFC.new()
      end
    end
  end

  describe "encryption_public_key field" do
    test "creates a valid NFC struct with encryption_public_key" do
      params = %{encryption_public_key: @valid_p256_public_key}

      assert %NFC{} = nfc = NFC.new(params)
      assert nfc.encryption_public_key == @valid_p256_public_key

      encoded = Jason.encode!(nfc)
      assert encoded =~ ~s("encryptionPublicKey":"#{@valid_p256_public_key}")
    end

    test "raises ArgumentError for various invalid encryption_public_key values" do
      invalid_keys = [
        {123, ~r/encryption_public_key must be a string/},
        {"", ~r/encryption_public_key is required/},
        {"not-a-valid-base64-string", ~r/Invalid Base64 encoding/},
        {Base.encode64("This is not a valid SubjectPublicKeyInfo structure"),
         ~r/Failed to decode SubjectPublicKeyInfo structure. The provided encryption_public_key could not be parsed. Error details/}
      ]

      Enum.each(invalid_keys, fn {key, error_message} ->
        assert_raise ArgumentError, error_message, fn ->
          NFC.new(%{encryption_public_key: key})
        end
      end)
    end

    test "raises ArgumentError for various invalid encryption_public_key configurations" do
      invalid_cases = [
        {
          generate_invalid_algorithm_oid_key(),
          ~r/Invalid algorithm ID for encryption_public_key. Expected ECDH \(id-ecPublicKey\)/
        },
        {
          generate_invalid_curve_oid_key(),
          ~r/Invalid curve for encryption_public_key\. Expected P-256 curve \(prime256v1\)/
        },
        {
          generate_invalid_key_size(),
          ~r/Invalid key size for encryption_public_key\. Expected 65 bytes for uncompressed P-256 public key, but got 60 bytes/
        }
      ]

      Enum.each(invalid_cases, fn {invalid_key, error_message} ->
        assert_raise ArgumentError, error_message, fn ->
          NFC.new(%{encryption_public_key: invalid_key})
        end
      end)
    end

    defp generate_invalid_algorithm_oid_key do
      {public_key, _private_key} = :crypto.generate_key(:ecdh, :secp256r1)

      algorithm_identifier = {
        :AlgorithmIdentifier,
        # Invalid algorithm OID
        {1, 2, 840, 113_549, 1, 1, 1},
        # Valid curve OID
        <<6, 8, 42, 134, 72, 206, 61, 3, 1, 7>>
      }

      encode_subject_public_key_info(algorithm_identifier, public_key)
    end

    defp generate_invalid_curve_oid_key do
      {public_key, _private_key} = :crypto.generate_key(:ecdh, :secp256k1)

      algorithm_identifier = {
        :AlgorithmIdentifier,
        # Valid algorithm OID
        {1, 2, 840, 10_045, 2, 1},
        # Invalid curve OID
        <<6, 5, 43, 129, 4, 0, 10>>
      }

      encode_subject_public_key_info(algorithm_identifier, public_key)
    end

    defp generate_invalid_key_size do
      {public_key, _private_key} = :crypto.generate_key(:ecdh, :secp256r1)
      # Truncate to invalid size
      invalid_public_key = binary_part(public_key, 0, 60)

      algorithm_identifier = {
        :AlgorithmIdentifier,
        # Valid algorithm OID
        {1, 2, 840, 10_045, 2, 1},
        # Valid curve OID
        <<6, 8, 42, 134, 72, 206, 61, 3, 1, 7>>
      }

      encode_subject_public_key_info(algorithm_identifier, invalid_public_key)
    end

    defp encode_subject_public_key_info(algorithm_identifier, public_key) do
      subject_public_key_info = {
        :SubjectPublicKeyInfo,
        algorithm_identifier,
        public_key
      }

      der_encoded = :public_key.der_encode(:SubjectPublicKeyInfo, subject_public_key_info)
      Base.encode64(der_encoded)
    end
  end
end
