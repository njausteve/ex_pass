defmodule ExPass.Utils.PublicKey do
  @moduledoc """
  Provides validation functions for public key formats used in ExPass.

  This module specifically handles validation of encryption public keys used in NFC
  and other cryptographic contexts, ensuring they meet the required format and
  structure specifications.
  """

  @ec_public_key_oid {1, 2, 840, 10_045, 2, 1}
  @p256_curve_oid_binary <<6, 8, 42, 134, 72, 206, 61, 3, 1, 7>>

  @uncompressed_key_header 0x04
  # 1-byte header + 32-byte X coord + 32-byte Y coord
  @compressed_key_headers [0x02, 0x03]
  # 1-byte header + 32-byte compressed point
  @uncompressed_key_size 65
  @compressed_key_size 33

  @doc """
  Validates that a value is a Base64-encoded X.509 SubjectPublicKeyInfo structure
  containing an ECDH public key for group P256.

  ## Parameters
    * `value` - The value to validate
    * `field_name` - The name of the field being validated

  ## Returns
    * `:ok` if the value is valid
    * `{:error, reason}` if the value is invalid, where reason is a string explaining the error

  ## Examples

      iex> validate_encryption_public_key("BASE64_ENCODED_VALID_KEY==", :encryption_public_key)
      :ok

      iex> validate_encryption_public_key(nil, :encryption_public_key)
      {:error, "encryption_public_key is required"}

      iex> validate_encryption_public_key("invalid base64!", :encryption_public_key)
      {:error, "encryption_public_key must be a valid Base64 string"}

  """
  @spec validate_encryption_public_key(String.t() | nil, atom()) :: :ok | {:error, String.t()}
  def validate_encryption_public_key(nil, field_name),
    do: {:error, "#{field_name} is required"}

  def validate_encryption_public_key(value, field_name) do
    cond do
      not is_binary(value) ->
        {:error, "#{field_name} must be a string"}

      String.trim(value) == "" ->
        {:error, "#{field_name} is required"}

      not base64?(value) ->
        {:error, "#{field_name} must be a valid Base64 string"}

      true ->
        validate_x509_spki_with_p256_ecdh(value, field_name)
    end
  end

  defp base64?(str) do
    case Base.decode64(str) do
      {:ok, _decoded} -> true
      :error -> false
    end
  end

  defp validate_x509_spki_with_p256_ecdh(base64_str, field_name) do
    try do
      {:ok, der} = Base.decode64(base64_str, padding: false)

      case :public_key.der_decode(:SubjectPublicKeyInfo, der) do
        {:SubjectPublicKeyInfo, algorithm, public_key} ->
          cond do
            not valid_ecdh_p256_algorithm?(algorithm) ->
              {:error, "#{field_name} has an invalid algorithm. Expected ECDH P256 algorithm"}

            not valid_ecdh_p256_key_format?(public_key) ->
              {:error,
               "#{field_name} has an invalid key format. Expected uncompressed (65 bytes) or compressed (33 bytes) EC point"}

            true ->
              :ok
          end
      end
    rescue
      _ ->
        {:error, "#{field_name} is not a valid X.509 SubjectPublicKeyInfo structure"}
    end
  end

  defp valid_ecdh_p256_algorithm?(algorithm) do
    match?({:AlgorithmIdentifier, @ec_public_key_oid, @p256_curve_oid_binary}, algorithm)
  end

  defp valid_ecdh_p256_key_format?(public_key) do
    case public_key do
      <<@uncompressed_key_header, _::binary>> ->
        byte_size(public_key) == @uncompressed_key_size

      <<prefix::size(8), _::binary>> when prefix in @compressed_key_headers ->
        byte_size(public_key) == @compressed_key_size

      _ ->
        false
    end
  end
end
