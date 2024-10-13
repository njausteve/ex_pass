defmodule ExPass.Structs.NFC do
  @moduledoc """
  Represents NFC-specific information for a pass.

  ## Fields

  * `:encryption_public_key` - (Required) The public encryption key used by the Value Added Services protocol.
    This should be a Base64 encoded X.509 SubjectPublicKeyInfo structure containing a ECDH public key for the P256 curve.

  ## Compatibility

  - iOS 9.0+
  - iPadOS 9.0+
  - watchOS 2.0+
  """

  use ExPass.Structs.BaseStruct
  use TypedStruct

  alias ExPass.Utils.Converter
  alias ExPass.Utils.Validators

  typedstruct do
    field :encryption_public_key, String.t(), enforce: true
  end

  @doc """
  Creates a new NFC struct.

  ## Parameters

    * `attrs` - A map of attributes for the NFC struct. The map must include the following key:
      * `:encryption_public_key` - (Required) The public encryption key used by the Value Added Services protocol.

  ## Returns

    * A new `%NFC{}` struct.

  ## Examples

      iex> NFC.new(%{encryption_public_key: "Base64EncodedPublicKey=="})
      %NFC{encryption_public_key: "Base64EncodedPublicKey=="}

      iex> NFC.new(%{})
      ** (ArgumentError) encryption_public_key is required

      iex> NFC.new(%{encryption_public_key: ""})
      ** (ArgumentError) encryption_public_key cannot be an empty string

  """
  @spec new(map()) :: %__MODULE__{}
  def new(attrs \\ %{}) do
    attrs =
      attrs
      |> Converter.trim_string_values()
      |> validate(
        :encryption_public_key,
        &Validators.validate_required_encryption_public_key_string(&1, :encryption_public_key)
      )

    struct!(__MODULE__, attrs)
  end
end
