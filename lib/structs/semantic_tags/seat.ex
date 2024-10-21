defmodule ExPass.Structs.SemanticTags.Seat do
  @moduledoc """
  Represents  the identification of a seat for a transit journey or an event.

  ## Fields

  * `:seat_type` - Optional. The type of seat, such as “Reserved seating”.

  ## Compatibility

  - iOS 12.0+
  - iPadOS 6.0+
  - watchOS 2.0+
  """

  use TypedStruct

  alias ExPass.Utils.Converter
  alias ExPass.Utils.Validators

  typedstruct do
    field :seat_type, String.t()
  end

  @doc """
  Creates a new Seat struct.

  ## Parameters

    * `attrs` - A map of attributes for the Seat struct. The map can include the following keys:
      * `:seat_type` - (Optional) The type of seat, such as “Reserved seating”.

  ## Returns

    * A new `%Seat{}` struct.

  ## Examples

      iex> Seat.new(%{seat_type: "Reserved seating"})
      %Seat{seat_type: "Reserved seating"}

      iex> Seat.new(%{seat_type: 123})
      ** (ArgumentError) seat_type must be a string

  """
  @spec new(map()) :: %__MODULE__{}
  def new(attrs \\ %{}) do
    attrs =
      attrs
      |> Converter.trim_string_values()
      |> validate(:seat_type, &Validators.validate_optional_string(&1, :seat_type))

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
    def encode(seat, opts) do
      seat
      |> Map.from_struct()
      |> Enum.reduce(%{}, fn
        {_k, nil}, acc -> acc
        {k, v}, acc -> Map.put(acc, Converter.camelize_key(k), v)
      end)
      |> Jason.Encode.map(opts)
    end
  end
end
