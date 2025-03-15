defmodule ExPass.Structs.NFC do
  @moduledoc """
  Represents the near-field communication (NFC) payload the device passes to an Apple Pay terminal.

  ## Fields

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

  typedstruct do
    field :message, String.t(), enforce: true
    field :requires_authentication, boolean(), default: nil
  end

  @doc """
  Creates a new NFC struct.

  ## Parameters

    * `attrs` - A map of attributes for the NFC struct. The map can include the following keys:
      * `:message` - (Required) The payload the device transmits to the Apple Pay terminal.
        The size needs to be no more than 64 bytes. The system truncates messages longer than 64 bytes.
      * `:requires_authentication` - (Optional) A Boolean value that indicates whether the NFC pass requires authentication.
        When set to true, it requires the user to authenticate for each use of the NFC pass.
        The default value is nil (not included in the pass).

  ## Returns

    * A new `%NFC{}` struct.

  ## Examples

      iex> NFC.new(%{message: "test message"})
      %NFC{message: "test message", requires_authentication: nil}

      iex> NFC.new(%{message: "test message", requires_authentication: true})
      %NFC{message: "test message", requires_authentication: true}

      iex> NFC.new(%{})
      ** (ArgumentError) message is required

      iex> NFC.new(%{message: String.duplicate("a", 65)})
      ** (ArgumentError) message must be no more than 64 bytes

  """
  @spec new(map()) :: %__MODULE__{}
  def new(attrs \\ %{}) do
    attrs =
      attrs
      |> validate(:message, &Validators.validate_message_length(&1, 64, :message))
      |> validate(
        :requires_authentication,
        &Validators.validate_boolean_field(&1, :requires_authentication)
      )

    struct!(__MODULE__, attrs)
  end
end
