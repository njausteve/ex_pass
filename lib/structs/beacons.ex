defmodule ExPass.Structs.Beacons do
  @moduledoc """
  Represents the identity of a Bluetooth Low Energy beacon used to show a relevant pass.

  ## Fields

  * `:major` - 16-bit unsigned integer. The major identifier of a Bluetooth Low Energy location beacon.
  * `:minor` - 16-bit unsigned integer. The minor identifier of a Bluetooth Low Energy location beacon.

  ## Compatibility

  - iOS 7.0+
  - iPadOS 6.0+
  - watchOS 2.0+
  """

  use TypedStruct

  alias ExPass.Utils.Converter
  alias ExPass.Utils.Validators

  typedstruct do
    field :major, integer()
    field :minor, integer()
  end

  @doc """
  Creates a new Beacons struct.

  ## Parameters

    * `attrs` - A map of attributes for the Beacons struct. The map can include the following keys:
      * `:major` - (Optional) The major identifier of a Bluetooth Low Energy location beacon.
      * `:minor` - (Optional) The minor identifier of a Bluetooth Low Energy location beacon.

  ## Returns

    * A new `%Beacons{}` struct.

  ## Examples

      iex> Beacons.new(%{major: 12_345, minor: 6_789})
      %Beacons{major: 12_345, minor: 6_789}

      iex> Beacons.new(%{major: 12_345})
      %Beacons{major: 12_345, minor: nil}

      iex> Beacons.new(%{minor: 6_789})
      %Beacons{major: nil, minor: 6_789}

      iex> Beacons.new(%{})
      %Beacons{major: nil, minor: nil}

  """
  @spec new(map()) :: %__MODULE__{}
  def new(attrs \\ %{}) do
    attrs =
      attrs
      |> validate(:major, &Validators.validate_optional_16bit_unsigned_integer(&1, :major))
      |> validate(:minor, &Validators.validate_optional_16bit_unsigned_integer(&1, :minor))

    struct!(__MODULE__, attrs)
  end

  defp validate(attrs, key, validator) do
    case validator.(attrs[key]) do
      :ok ->
        attrs

      {:error, reason} ->
        raise ArgumentError, reason
    end
  end

  defimpl Jason.Encoder do
    def encode(field_content, opts) do
      field_content
      |> Map.from_struct()
      |> Enum.reduce(%{}, fn
        {_k, nil}, acc -> acc
        {k, v}, acc -> Map.put(acc, Converter.camelize_key(k), v)
      end)
      |> Jason.Encode.map(opts)
    end
  end
end
