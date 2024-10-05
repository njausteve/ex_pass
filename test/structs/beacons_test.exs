defmodule ExPass.Structs.BeaconsTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ExPass.Structs.Beacons

  describe "new/0" do
    test "creates an empty Beacons struct" do
      assert %Beacons{} = beacon = Beacons.new()
      assert beacon.major == nil
      assert beacon.minor == nil
      assert Jason.encode!(beacon) == "{}"
    end
  end

  describe "new/1 with minor field" do
    test "creates a valid Beacons struct with minor field" do
      params = %{minor: 50}

      assert %Beacons{} = beacon = Beacons.new(params)
      assert beacon.minor == params.minor
      assert beacon.major == nil
      assert Jason.encode!(beacon) == "{\"minor\":50}"
    end

    test "creates a valid Beacons struct with minor field set to 0" do
      params = %{minor: 0}

      assert %Beacons{} = beacon = Beacons.new(params)
      assert beacon.minor == 0
      assert Jason.encode!(beacon) == "{\"minor\":0}"
    end

    test "creates a valid Beacons struct with minor field set to 65535 (max value)" do
      params = %{minor: 65_535}

      assert %Beacons{} = beacon = Beacons.new(params)
      assert beacon.minor == 65_535
      assert Jason.encode!(beacon) == "{\"minor\":65535}"
    end

    test "returns error for invalid minor (negative value)" do
      params = %{minor: -1}

      assert_raise ArgumentError, "minor must be a 16-bit unsigned integer (0-65_535)", fn ->
        Beacons.new(params)
      end
    end

    test "returns error for invalid minor (value too large)" do
      params = %{minor: 65_536}

      assert_raise ArgumentError, "minor must be a 16-bit unsigned integer (0-65_535)", fn ->
        Beacons.new(params)
      end
    end

    test "returns error for invalid minor (non-integer value)" do
      params = %{minor: "50"}

      assert_raise ArgumentError, "minor must be a 16-bit unsigned integer (0-65_535)", fn ->
        Beacons.new(params)
      end
    end
  end

  describe "new/1 with major field" do
    test "creates a valid Beacons struct with major field" do
      params = %{major: 100}

      assert %Beacons{} = beacon = Beacons.new(params)
      assert beacon.major == params.major
      assert beacon.minor == nil
      assert Jason.encode!(beacon) == "{\"major\":100}"
    end
  end
end
