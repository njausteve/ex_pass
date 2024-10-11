defmodule ExPass.Structs.LocationsTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ExPass.Structs.Locations

  describe "new/0" do
    test "throws exception when no latitude is provided" do
      assert_raise ArgumentError, "latitude is a required field and cannot be nil", fn ->
        Locations.new()
      end
    end
  end

  describe "new/1 with altitude field" do
    test "creates a valid Locations struct with altitude field" do
      params = %{altitude: 100.5, latitude: 37.7749}

      assert %Locations{} = location = Locations.new(params)
      assert location.altitude == 100.5
      assert location.latitude == 37.7749
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("altitude":100.5)
      assert encoded =~ ~s("latitude":37.7749)
    end

    test "creates a valid Locations struct with altitude field set to 0" do
      params = %{altitude: 0.0, latitude: -45.0}

      assert %Locations{} = location = Locations.new(params)
      assert location.altitude == 0.0
      assert location.latitude == -45.0
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("altitude":0.0)
      assert encoded =~ ~s("latitude":-45.0)
    end

    test "creates a valid Locations struct with altitude field set to negative value" do
      params = %{altitude: -50.75, latitude: 90.0}

      assert %Locations{} = location = Locations.new(params)
      assert location.altitude == -50.75
      assert location.latitude == 90.0
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("altitude":-50.75)
      assert encoded =~ ~s("latitude":90.0)
    end

    test "returns error for invalid altitude (integer value)" do
      params = %{altitude: 100, latitude: 0.0}

      assert_raise ArgumentError, "altitude must be a float", fn ->
        Locations.new(params)
      end
    end

    test "returns error for invalid altitude (non-numeric value)" do
      params = %{altitude: "100.5", latitude: 0.0}

      assert_raise ArgumentError, "altitude must be a float", fn ->
        Locations.new(params)
      end
    end
  end

  describe "new/1 with latitude field" do
    test "creates a valid Locations struct with latitude field" do
      params = %{latitude: 37.7749}

      assert %Locations{} = location = Locations.new(params)
      assert location.latitude == 37.7749
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("latitude":37.7749)
    end

    test "creates a valid Locations struct with latitude field at minimum value" do
      params = %{latitude: -90.0}

      assert %Locations{} = location = Locations.new(params)
      assert location.latitude == -90.0
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("latitude":-90.0)
    end

    test "creates a valid Locations struct with latitude field at maximum value" do
      params = %{latitude: 90.0}

      assert %Locations{} = location = Locations.new(params)
      assert location.latitude == 90.0
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("latitude":90.0)
    end

    test "returns error for invalid latitude (below minimum)" do
      params = %{latitude: -90.1}

      assert_raise ArgumentError, "latitude must be between -90 and 90", fn ->
        Locations.new(params)
      end
    end

    test "returns error for invalid latitude (above maximum)" do
      params = %{latitude: 90.1}

      assert_raise ArgumentError, "latitude must be between -90 and 90", fn ->
        Locations.new(params)
      end
    end

    test "returns error for invalid latitude (non-float value)" do
      params = %{latitude: "37.7749"}

      assert_raise ArgumentError, "latitude must be a float", fn ->
        Locations.new(params)
      end
    end

    test "returns error when latitude is missing" do
      params = %{}

      assert_raise ArgumentError, "latitude is a required field and cannot be nil", fn ->
        Locations.new(params)
      end
    end
  end
end
