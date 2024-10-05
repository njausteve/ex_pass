defmodule ExPass.Structs.Beacons do
  @moduledoc """
  Represents the identity of a Bluetooth Low Energy beacon used to show a relevant pass.

  ## Fields

  * `:major` - 16-bit unsigned integer. The major identifier of a Bluetooth Low Energy location beacon.

  ## Compatibility

  - iOS 7.0+
  - iPadOS 6.0+
  - watchOS 2.0+
  """

  use TypedStruct

  alias ExPass.Utils.Validators

  typedstruct do
    field :major, integer()
  end

  @doc """
  Creates a new Beacons struct.

  ## Parameters

    * `attrs` - A map of attributes for the Beacons struct. The map can include the following key:
      * `:major` - (Optional) The major identifier of a Bluetooth Low Energy location beacon.

  ## Returns

    * A new `%Beacons{}` struct.

  ## Examples

      iex> Beacons.new(%{major: 12_345})
      %Beacons{major: 12_345}

      iex> Beacons.new(%{})
      %Beacons{major: nil}

  """
  @spec new(map()) :: %__MODULE__{}
  def new(attrs \\ %{}) do
    attrs = validate(:major, attrs, &Validators.validate_optional_16bit_unsigned_integer/1)
    struct!(__MODULE__, attrs)
  end

  defp validate(key, attrs, validator) do
    case validator.(attrs[key]) do
      :ok -> attrs
      {:error, reason} -> raise ArgumentError, "Invalid #{key}: #{reason}"
    end
  end

  defimpl Jason.Encoder do
    def encode(beacons, opts) do
      beacons
      |> Map.from_struct()
      |> Enum.reject(fn {_, v} -> is_nil(v) end)
      |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, Atom.to_string(k), v) end)
      |> Jason.Encode.map(opts)
    end
  end
end
