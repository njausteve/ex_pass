defmodule ExPass.Utils.PublicKeyTest do
  @moduledoc """
  Tests for the PublicKey utility module.

  These tests verify the validation functions for public key formats used in ExPass,
  particularly focusing on the validation of encryption public keys.
  """

  use ExUnit.Case, async: true
  alias ExPass.Utils.PublicKey

  # Sample valid P256 ECDH public key in SubjectPublicKeyInfo format (Base64 encoded)
  @valid_p256_key "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAELUJ7jY8VfBkjJdHEiOZuX8sSYFTJ1sFR+VNgC2Vd5SYJx1x1F9QJD+hkXjE4wP4IaRyQF5s8zCPgKmXCuPGvdA=="

  # Sample valid compressed P256 ECDH public key in SubjectPublicKeyInfo format
  @valid_compressed_key "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAELUJ7jY8VfBkjJdHEiOZuX8sSYFTJ1sFR+VNgC2Vd5SYJx1x1F9QJD+hkXjE4wP4IaRyQF5s8zCPgKmXCuPGvdA=="

  # Invalid algorithm key - this is a real SubjectPublicKeyInfo structure but with RSA algorithm instead of ECDH
  @invalid_algorithm_key "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu1SU1LfVLPHCozMxH2Mo4lgOEePzNm0tRgeLezV6ffAt0gunVTLw7onLRnrq0/IzW7yWR7QkrmBL7jTKEn5u+qKhbwKfBstIs+bMY2Zkp18gnTxKLxoS2tFczGkPLPgizskuemMghRniWaoLcyehkd3qqGElvW/VDL5AaWTg0nLVkjRo9z+40RQzuVaE8AkAFmxZzow3x+VJYKdjykkJ0iT9wCS0DRTXu269V264Vf/3jvredZiKRkgwlL9xNAwxXFg0x/XFw005UWVRIkdgcKWTjpBP2dPwVZ4WWC+9aGVd+Gyn1o0CLelf4rEjGoXbAAEgAqeGUxrcIlbjXfbcmwIDAQAB"

  describe "validate_encryption_public_key/2" do
    test "returns :ok when it is a valid P256 ECDH public key" do
      assert PublicKey.validate_encryption_public_key(@valid_p256_key, :encryption_public_key) ==
               :ok
    end

    test "returns :ok when it is a valid compressed P256 ECDH public key" do
      assert PublicKey.validate_encryption_public_key(
               @valid_compressed_key,
               :encryption_public_key
             ) == :ok
    end

    test "returns error when value is nil" do
      assert PublicKey.validate_encryption_public_key(nil, :encryption_public_key) ==
               {:error, "encryption_public_key is required"}
    end

    test "returns error when value is not a string" do
      assert PublicKey.validate_encryption_public_key(123, :encryption_public_key) ==
               {:error, "encryption_public_key must be a string"}
    end

    test "returns error when value is an empty string" do
      assert PublicKey.validate_encryption_public_key("", :encryption_public_key) ==
               {:error, "encryption_public_key is required"}
    end

    test "returns error when value is a string with only whitespace" do
      assert PublicKey.validate_encryption_public_key("   ", :encryption_public_key) ==
               {:error, "encryption_public_key is required"}
    end

    test "returns error when value is not a valid Base64 string" do
      assert PublicKey.validate_encryption_public_key(
               "not a base64 string!",
               :encryption_public_key
             ) ==
               {:error, "encryption_public_key must be a valid Base64 string"}
    end

    test "returns error when value is Base64 but not a valid X.509 SubjectPublicKeyInfo" do
      # Valid Base64 but not a valid X.509 SubjectPublicKeyInfo
      invalid_base64 = Base.encode64("this is valid base64 but not a valid X.509 structure")

      assert PublicKey.validate_encryption_public_key(invalid_base64, :encryption_public_key) ==
               {:error,
                "encryption_public_key is not a valid X.509 SubjectPublicKeyInfo structure"}
    end

    test "returns error with specific message when algorithm is invalid" do
      assert PublicKey.validate_encryption_public_key(
               @invalid_algorithm_key,
               :encryption_public_key
             ) ==
               {:error,
                "encryption_public_key has an invalid algorithm. Expected ECDH P256 algorithm"}
    end

    test "returns error with specific message when key format is invalid" do
      assert PublicKey.validate_encryption_public_key(
               generate_invalid_key_format(),
               :encryption_public_key
             ) ==
               {:error,
                "encryption_public_key has an invalid key format. Expected uncompressed (65 bytes) or compressed (33 bytes) EC point"}
    end

    test "uses the provided field name in error messages" do
      assert PublicKey.validate_encryption_public_key(nil, :custom_field) ==
               {:error, "custom_field is required"}

      assert PublicKey.validate_encryption_public_key(123, :another_field) ==
               {:error, "another_field must be a string"}
    end

    test "returns error when X.509 structure is decoded but not a SubjectPublicKeyInfo" do
      # Create a valid DER-encoded sequence that's not a SubjectPublicKeyInfo
      simple_sequence = <<48, 10, 6, 3, 85, 4, 3, 12, 4, 116, 101, 115, 116>>
      simple_sequence_base64 = Base.encode64(simple_sequence)

      assert PublicKey.validate_encryption_public_key(
               simple_sequence_base64,
               :encryption_public_key
             ) ==
               {:error,
                "encryption_public_key is not a valid X.509 SubjectPublicKeyInfo structure"}
    end

    test "returns error when compressed key has invalid size" do
      # First, we need to generate the SubjectPublicKeyInfo structure
      {:ok, der} = Base.decode64(@valid_compressed_key, padding: false)
      {:SubjectPublicKeyInfo, algorithm, _} = :public_key.der_decode(:SubjectPublicKeyInfo, der)

      # Create an invalid compressed key - use a valid header (0x02 or 0x03) but wrong size
      # Should be 33 bytes but we'll make it shorter
      invalid_compressed_key = <<0x02, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10>>

      # Re-encode with the same algorithm but invalid key format
      spki = {:SubjectPublicKeyInfo, algorithm, invalid_compressed_key}
      der = :public_key.der_encode(:SubjectPublicKeyInfo, spki)
      invalid_base64 = Base.encode64(der)

      assert PublicKey.validate_encryption_public_key(invalid_base64, :encryption_public_key) ==
               {:error,
                "encryption_public_key has an invalid key format. Expected uncompressed (65 bytes) or compressed (33 bytes) EC point"}
    end

    test "returns error when key has invalid header byte" do
      # First, we need to generate the SubjectPublicKeyInfo structure
      {:ok, der} = Base.decode64(@valid_p256_key, padding: false)
      {:SubjectPublicKeyInfo, algorithm, _} = :public_key.der_decode(:SubjectPublicKeyInfo, der)

      # Create a key with an invalid header byte (not 0x04, 0x02, or 0x03)
      # Using 0x05 which isn't a valid EC point format
      invalid_header_key =
        <<0x05, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,
          24, 25, 26, 27, 28, 29, 30, 31, 32>>

      # Re-encode with the same algorithm but invalid key format
      spki = {:SubjectPublicKeyInfo, algorithm, invalid_header_key}
      der = :public_key.der_encode(:SubjectPublicKeyInfo, spki)
      invalid_base64 = Base.encode64(der)

      assert PublicKey.validate_encryption_public_key(invalid_base64, :encryption_public_key) ==
               {:error,
                "encryption_public_key has an invalid key format. Expected uncompressed (65 bytes) or compressed (33 bytes) EC point"}
    end
  end

  defp generate_invalid_key_format do
    {:ok, der} = Base.decode64(@valid_p256_key, padding: false)
    {:SubjectPublicKeyInfo, algorithm, _} = :public_key.der_decode(:SubjectPublicKeyInfo, der)

    # Create an invalid public key with wrong size (just 10 bytes with uncompressed header)
    invalid_key = <<0x04, 1, 2, 3, 4, 5, 6, 7, 8, 9>>

    # Re-encode with the same algorithm but invalid key format
    spki = {:SubjectPublicKeyInfo, algorithm, invalid_key}
    der = :public_key.der_encode(:SubjectPublicKeyInfo, spki)
    Base.encode64(der)
  end
end
