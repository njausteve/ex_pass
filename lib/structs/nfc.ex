defmodule ExPass.Structs.NFC do
  @moduledoc """
  Represents the near-field communication (NFC) payload the device passes to an Apple Pay terminal.

  ## Fields

  * `:encryption_public_key` - (Required) The public encryption key the Value Added Services protocol uses.
    Use a Base64-encoded X.509 SubjectPublicKeyInfo structure that contains an ECDH public key for group P256.
  * `:message` - (Required) The payload the device transmits to the Apple Pay terminal.
    The size needs to be no more than 64 bytes. The system truncates messages longer than 64 bytes.
  * `:requires_authentication` - (Optional) A Boolean value that indicates whether the NFC pass requires authentication.
    When set to true, it requires the user to authenticate for each use of the NFC pass.
    The default value is nil (not included in the pass).

  ## Compatibility

  - iOS 13.1+
  - iPadOS 13.1+
  - watchOS 2.0+
  """

  use ExPass.Structs.Base
  use TypedStruct

  alias ExPass.Utils.Validators
  alias ExPass.Utils.PublicKey

  typedstruct do
    field :encryption_public_key, String.t(), enforce: true
    field :message, String.t(), enforce: true
    field :requires_authentication, boolean(), default: nil
  end

  @doc """
  Creates a new NFC struct.

  ## Parameters

    * `attrs` - A map of attributes for the NFC struct. The map can include the following keys:
      * `:encryption_public_key` - (Required) The public encryption key the Value Added Services protocol uses.
        Use a Base64-encoded X.509 SubjectPublicKeyInfo structure that contains an ECDH public key for group P256.
      * `:message` - (Required) The payload the device transmits to the Apple Pay terminal.
        The size needs to be no more than 64 bytes. The system truncates messages longer than 64 bytes.
      * `:requires_authentication` - (Optional) A Boolean value that indicates whether the NFC pass requires authentication.
        When set to true, it requires the user to authenticate for each use of the NFC pass.
        The default value is nil (not included in the pass).

  ## Returns

    * A new `%NFC{}` struct.

  ## Examples

      iex> valid_key = "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAELUJ7jY8VfBkjJdHEiOZuX8sSYFTJ1sFR+VNgC2Vd5SYJx1x1F9QJD+hkXjE4wP4IaRyQF5s8zCPgKmXCuPGvdA=="
      iex> NFC.new(%{message: "test message", encryption_public_key: valid_key})
      %NFC{message: "test message", encryption_public_key: "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAELUJ7jY8VfBkjJdHEiOZuX8sSYFTJ1sFR+VNgC2Vd5SYJx1x1F9QJD+hkXjE4wP4IaRyQF5s8zCPgKmXCuPGvdA==", requires_authentication: nil}

      iex> valid_key = "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAELUJ7jY8VfBkjJdHEiOZuX8sSYFTJ1sFR+VNgC2Vd5SYJx1x1F9QJD+hkXjE4wP4IaRyQF5s8zCPgKmXCuPGvdA=="
      iex> NFC.new(%{message: "test message", encryption_public_key: valid_key, requires_authentication: true})
      %NFC{message: "test message", encryption_public_key: "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAELUJ7jY8VfBkjJdHEiOZuX8sSYFTJ1sFR+VNgC2Vd5SYJx1x1F9QJD+hkXjE4wP4IaRyQF5s8zCPgKmXCuPGvdA==", requires_authentication: true}

      iex> NFC.new(%{})
      ** (ArgumentError) message is required

      iex> NFC.new(%{message: "test message"})
      ** (ArgumentError) encryption_public_key is required

  """
  @spec new(map()) :: %__MODULE__{}
  def new(attrs \\ %{}) do
    attrs =
      attrs
      |> validate(:message, &Validators.validate_message_length(&1, 64, :message))
      |> validate(
        :encryption_public_key,
        &PublicKey.validate_encryption_public_key(&1, :encryption_public_key)
      )
      |> validate(
        :requires_authentication,
        &Validators.validate_boolean_field(&1, :requires_authentication)
      )

    struct!(__MODULE__, attrs)
  end
end
