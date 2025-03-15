defmodule ExPass.Structs.NFC do
  @moduledoc """
  Represents the near-field communication (NFC) payload the device passes to an Apple Pay terminal.

  ## Fields

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
    field :requires_authentication, boolean(), default: nil
  end

  @doc """
  Creates a new NFC struct.

  ## Parameters

    * `attrs` - A map of attributes for the NFC struct. The map can include the following keys:
      * `:requires_authentication` - (Optional) A Boolean value that indicates whether the NFC pass requires authentication.
        When set to true, it requires the user to authenticate for each use of the NFC pass.
        The default value is nil (not included in the pass).

  ## Returns

    * A new `%NFC{}` struct.

  ## Examples

      iex> NFC.new()
      %NFC{requires_authentication: nil}

      iex> NFC.new(%{requires_authentication: true})
      %NFC{requires_authentication: true}

      iex> NFC.new(%{requires_authentication: false})
      %NFC{requires_authentication: false}

      iex> NFC.new(%{})
      %NFC{requires_authentication: nil}

      iex> NFC.new(%{requires_authentication: nil})
      %NFC{requires_authentication: nil}

      iex> NFC.new(%{requires_authentication: "true"})
      ** (ArgumentError) requires_authentication must be a boolean value (true or false)

  """
  @spec new(map()) :: %__MODULE__{}
  def new(attrs \\ %{}) do
    attrs =
      attrs
      |> validate(
        :requires_authentication,
        &Validators.validate_boolean_field(&1, :requires_authentication)
      )

    struct!(__MODULE__, attrs)
  end
end
