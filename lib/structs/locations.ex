defmodule ExPass.Structs.Locations do
  @moduledoc """
  Represents a location that the system uses to show a relevant pass.

  ## Fields

  * `:altitude` - The altitude, in meters, of the location. This is a double-precision floating-point number.
  * `:latitude` - (Required) The latitude, in degrees, of the location. This is a double-precision floating-point number between -90 and 90.
  * `:longitude` - (Required) The longitude, in degrees, of the location. This is a double-precision floating-point number between -180 and 180.
  * `:relevant_text` - The text to display on the lock screen when the pass is relevant. For example, a description of a nearby location, such as "Store nearby on 1st and Main".

  ## Compatibility

  - iOS 6.0+
  - iPadOS 6.0+
  - watchOS 2.0+
  """

  use ExPass.Structs.Base
  use TypedStruct

  alias ExPass.Utils.Validators

  typedstruct do
    field :altitude, float()
    field :latitude, float(), enforce: true
    field :longitude, float(), enforce: true
    field :relevant_text, String.t()
  end

  @doc """
  Creates a new Locations struct.

  ## Parameters

    * `attrs` - A map of attributes for the Locations struct. The map can include the following keys:
      * `:altitude` - (Optional) The altitude, in meters, of the location. This should be a double-precision floating-point number.
      * `:latitude` - (Required) The latitude, in degrees, of the location. This should be a double-precision floating-point number between -90 and 90.
      * `:longitude` - (Required) The longitude, in degrees, of the location. This should be a double-precision floating-point number between -180 and 180.
      * `:relevant_text` - (Optional) The text to display on the lock screen when the pass is relevant.

  ## Returns

    * A new `%Locations{}` struct.

  ## Examples

      iex> Locations.new(%{latitude: 37.7749, longitude: -122.4194})
      %Locations{altitude: nil, latitude: 37.7749, longitude: -122.4194, relevant_text: nil}

      iex> Locations.new(%{altitude: 100.5, latitude: 37.7749, longitude: -122.4194, relevant_text: "Store nearby on 1st and Main"})
      %Locations{altitude: 100.5, latitude: 37.7749, longitude: -122.4194, relevant_text: "Store nearby on 1st and Main"}

      iex> Locations.new(%{latitude: -50.75, longitude: 165.3})
      %Locations{altitude: nil, latitude: -50.75, longitude: 165.3, relevant_text: nil}

      iex> Locations.new(%{latitude: "invalid", longitude: 0.0})
      ** (ArgumentError) latitude must be a float

      iex> Locations.new(%{latitude: 37.7749})
      ** (ArgumentError) longitude is required

      iex> Locations.new(%{latitude: 91.0, longitude: 0.0})
      ** (ArgumentError) latitude must be between -90 and 90

      iex> Locations.new(%{latitude: 37.7749, longitude: 181.0})
      ** (ArgumentError) longitude must be between -180 and 180

      iex> Locations.new(%{latitude: 37.7749, longitude: -122.4194, relevant_text: 123})
      ** (ArgumentError) relevant_text must be a string

  """
  @spec new(map()) :: %__MODULE__{}
  def new(attrs \\ %{}) do
    attrs =
      attrs
      |> Converter.trim_string_values()
      |> validate(:altitude, &Validators.validate_optional_float(&1, :altitude))
      |> validate(:latitude, &Validators.validate_latitude(&1, :latitude))
      |> validate(:longitude, &Validators.validate_longitude(&1, :longitude))
      |> validate(:relevant_text, &Validators.validate_optional_string(&1, :relevant_text))

    struct!(__MODULE__, attrs)
  end
end
