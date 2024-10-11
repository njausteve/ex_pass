defmodule ExPass.Structs.LocationsTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ExPass.Structs.Locations

  describe "new/0" do
    test "creates a valid Locations struct with default values" do
      assert %Locations{altitude: nil} = location = Locations.new()
      assert "{}" = Jason.encode!(location)
    end
  end

  describe "new/1 with altitude field" do
    test "creates a valid Locations struct with altitude field" do
      params = %{altitude: 100.5}

      assert %Locations{} = location = Locations.new(params)
      assert location.altitude == 100.5
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("altitude":100.5)
    end

    test "creates a valid Locations struct with altitude field set to 0" do
      params = %{altitude: 0.0}

      assert %Locations{} = location = Locations.new(params)
      assert location.altitude == 0.0
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("altitude":0.0)
    end

    test "creates a valid Locations struct with altitude field set to negative value" do
      params = %{altitude: -50.75}

      assert %Locations{} = location = Locations.new(params)
      assert location.altitude == -50.75
      encoded = Jason.encode!(location)
      assert encoded =~ ~s("altitude":-50.75)
    end

    test "returns error for invalid altitude (integer value)" do
      params = %{altitude: 100}

      assert_raise ArgumentError, "altitude must be a float", fn ->
        Locations.new(params)
      end
    end

    test "returns error for invalid altitude (non-numeric value)" do
      params = %{altitude: "100.5"}

      assert_raise ArgumentError, "altitude must be a float", fn ->
        Locations.new(params)
      end
    end
  end
end
