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

    test "throws exception when no longitude is provided" do
      assert_raise ArgumentError, "longitude is a required field and cannot be nil", fn ->
        Locations.new(%{latitude: 0.0})
      end
    end
  end

  describe "new/1 with altitude field" do
    test "creates a valid Locations struct with altitude field" do
      params = %{altitude: 100.5, latitude: 37.7749, longitude: -122.4194}

      assert %Locations{} = location = Locations.new(params)
      assert location.altitude == 100.5
      assert location.latitude == 37.7749
      assert location.longitude == -122.4194
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("altitude":100.5)
      assert encoded =~ ~s("latitude":37.7749)
      assert encoded =~ ~s("longitude":-122.4194)
    end

    test "creates a valid Locations struct with altitude field set to 0" do
      params = %{altitude: 0.0, latitude: -45.0, longitude: 170.5}

      assert %Locations{} = location = Locations.new(params)
      assert location.altitude == 0.0
      assert location.latitude == -45.0
      assert location.longitude == 170.5
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("altitude":0.0)
      assert encoded =~ ~s("latitude":-45.0)
      assert encoded =~ ~s("longitude":170.5)
    end

    test "creates a valid Locations struct with altitude field set to negative value" do
      params = %{altitude: -50.75, latitude: 90.0, longitude: 0.0}

      assert %Locations{} = location = Locations.new(params)
      assert location.altitude == -50.75
      assert location.latitude == 90.0
      assert location.longitude == 0.0
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("altitude":-50.75)
      assert encoded =~ ~s("latitude":90.0)
      assert encoded =~ ~s("longitude":0.0)
    end

    test "returns error for invalid altitude (integer value)" do
      params = %{altitude: 100, latitude: 0.0, longitude: 0.0}

      assert_raise ArgumentError, "altitude must be a float", fn ->
        Locations.new(params)
      end
    end

    test "returns error for invalid altitude (non-numeric value)" do
      params = %{altitude: "100.5", latitude: 0.0, longitude: 0.0}

      assert_raise ArgumentError, "altitude must be a float", fn ->
        Locations.new(params)
      end
    end
  end

  describe "new/1 with latitude field" do
    test "creates a valid Locations struct with latitude field" do
      params = %{latitude: 37.7749, longitude: -122.4194}

      assert %Locations{} = location = Locations.new(params)
      assert location.latitude == 37.7749
      assert location.longitude == -122.4194
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("latitude":37.7749)
      assert encoded =~ ~s("longitude":-122.4194)
    end

    test "creates a valid Locations struct with latitude field at minimum value" do
      params = %{latitude: -90.0, longitude: 0.0}

      assert %Locations{} = location = Locations.new(params)
      assert location.latitude == -90.0
      assert location.longitude == 0.0
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("latitude":-90.0)
      assert encoded =~ ~s("longitude":0.0)
    end

    test "creates a valid Locations struct with latitude field at maximum value" do
      params = %{latitude: 90.0, longitude: 180.0}

      assert %Locations{} = location = Locations.new(params)
      assert location.latitude == 90.0
      assert location.longitude == 180.0
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("latitude":90.0)
      assert encoded =~ ~s("longitude":180.0)
    end

    test "returns error for invalid latitude (below minimum)" do
      params = %{latitude: -90.1, longitude: 0.0}

      assert_raise ArgumentError, "latitude must be between -90 and 90", fn ->
        Locations.new(params)
      end
    end

    test "returns error for invalid latitude (above maximum)" do
      params = %{latitude: 90.1, longitude: 0.0}

      assert_raise ArgumentError, "latitude must be between -90 and 90", fn ->
        Locations.new(params)
      end
    end

    test "returns error for invalid latitude (non-float value)" do
      params = %{latitude: "37.7749", longitude: 0.0}

      assert_raise ArgumentError, "latitude must be a float", fn ->
        Locations.new(params)
      end
    end

    test "returns error when latitude is missing" do
      params = %{longitude: 0.0}

      assert_raise ArgumentError, "latitude is a required field and cannot be nil", fn ->
        Locations.new(params)
      end
    end
  end

  describe "new/1 with longitude field" do
    test "creates a valid Locations struct with longitude field" do
      params = %{latitude: 37.7749, longitude: -122.4194}

      assert %Locations{} = location = Locations.new(params)
      assert location.latitude == 37.7749
      assert location.longitude == -122.4194
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("latitude":37.7749)
      assert encoded =~ ~s("longitude":-122.4194)
    end

    test "creates a valid Locations struct with longitude field at minimum value" do
      params = %{latitude: 0.0, longitude: -180.0}

      assert %Locations{} = location = Locations.new(params)
      assert location.latitude == 0.0
      assert location.longitude == -180.0
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("latitude":0.0)
      assert encoded =~ ~s("longitude":-180.0)
    end

    test "creates a valid Locations struct with longitude field at maximum value" do
      params = %{latitude: 0.0, longitude: 180.0}

      assert %Locations{} = location = Locations.new(params)
      assert location.latitude == 0.0
      assert location.longitude == 180.0
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("latitude":0.0)
      assert encoded =~ ~s("longitude":180.0)
    end

    test "returns error for invalid longitude (below minimum)" do
      params = %{latitude: 0.0, longitude: -180.1}

      assert_raise ArgumentError, "longitude must be between -180 and 180", fn ->
        Locations.new(params)
      end
    end

    test "returns error for invalid longitude (above maximum)" do
      params = %{latitude: 0.0, longitude: 180.1}

      assert_raise ArgumentError, "longitude must be between -180 and 180", fn ->
        Locations.new(params)
      end
    end

    test "returns error for invalid longitude (non-float value)" do
      params = %{latitude: 0.0, longitude: "-122.4194"}

      assert_raise ArgumentError, "longitude must be a float", fn ->
        Locations.new(params)
      end
    end

    test "returns error when longitude is missing" do
      params = %{latitude: 0.0}

      assert_raise ArgumentError, "longitude is a required field and cannot be nil", fn ->
        Locations.new(params)
      end
    end
  end

  describe "relevantText" do
    test "creates a valid Locations struct with relevantText" do
      params = %{
        latitude: 37.7749,
        longitude: -122.4194,
        relevant_text: "Store nearby on 1st and Main"
      }

      assert %Locations{} = location = Locations.new(params)
      assert location.latitude == 37.7749
      assert location.longitude == -122.4194
      assert location.relevant_text == "Store nearby on 1st and Main"
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("relevantText":"Store nearby on 1st and Main")
    end

    test "creates a valid Locations struct without relevantText" do
      params = %{latitude: 37.7749, longitude: -122.4194}

      assert %Locations{} = location = Locations.new(params)
      assert location.latitude == 37.7749
      assert location.longitude == -122.4194
      assert location.relevant_text == nil
      encoded = Jason.encode!(location)
      refute encoded =~ "relevantText"
    end

    test "trims whitespace from relevantText" do
      params = %{latitude: 37.7749, longitude: -122.4194, relevant_text: "  Store nearby  "}

      assert %Locations{} = location = Locations.new(params)
      assert location.relevant_text == "Store nearby"
    end

    test "returns error for non-string relevantText" do
      params = %{latitude: 37.7749, longitude: -122.4194, relevant_text: 123}

      assert_raise ArgumentError, "relevant_text must be a non-empty string if provided", fn ->
        Locations.new(params)
      end
    end

    test "does not allow empty string for relevantText" do
      params = %{latitude: 37.7749, longitude: -122.4194, relevant_text: ""}

      assert_raise ArgumentError, "relevant_text must be a non-empty string if provided", fn ->
        Locations.new(params)
      end
    end
  end
end
