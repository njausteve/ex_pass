defmodule ExPass.Structs.BeaconsTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ExPass.Structs.Beacons

  describe "new/0" do
    test "raises an error for missing proximity_UUID" do
      assert_raise ArgumentError, "proximity_UUID is required", fn ->
        Beacons.new()
      end
    end
  end

  describe "new/1 with minor field" do
    test "creates a valid Beacons struct with minor field" do
      params = %{proximity_UUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", minor: 50}

      assert %Beacons{} = beacon = Beacons.new(params)
      assert beacon.minor == params.minor
      assert beacon.major == nil
      encoded = Jason.encode!(beacon)
      assert encoded =~ ~s("minor":50)
      assert encoded =~ ~s("proximityUUID":"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
    end

    test "creates a valid Beacons struct with minor field set to 0" do
      params = %{proximity_UUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", minor: 0}

      assert %Beacons{} = beacon = Beacons.new(params)
      assert beacon.minor == 0
      encoded = Jason.encode!(beacon)
      assert encoded =~ ~s("minor":0)
      assert encoded =~ ~s("proximityUUID":"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
    end

    test "creates a valid Beacons struct with minor field set to 65535 (max value)" do
      params = %{proximity_UUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", minor: 65_535}

      assert %Beacons{} = beacon = Beacons.new(params)
      assert beacon.minor == 65_535
      encoded = Jason.encode!(beacon)
      assert encoded =~ ~s("minor":65535)
      assert encoded =~ ~s("proximityUUID":"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
    end

    test "returns error for invalid minor (negative value)" do
      params = %{proximity_UUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", minor: -1}

      assert_raise ArgumentError, "minor must be a 16-bit unsigned integer (0-65_535)", fn ->
        Beacons.new(params)
      end
    end

    test "returns error for invalid minor (value too large)" do
      params = %{proximity_UUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", minor: 65_536}

      assert_raise ArgumentError, "minor must be a 16-bit unsigned integer (0-65_535)", fn ->
        Beacons.new(params)
      end
    end

    test "returns error for invalid minor (non-integer value)" do
      params = %{proximity_UUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", minor: "50"}

      assert_raise ArgumentError, "minor must be a 16-bit unsigned integer (0-65_535)", fn ->
        Beacons.new(params)
      end
    end
  end

  describe "new/1 with major field" do
    test "creates a valid Beacons struct with major field" do
      params = %{proximity_UUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", major: 100}

      assert %Beacons{} = beacon = Beacons.new(params)
      assert beacon.major == params.major
      assert beacon.minor == nil
      encoded = Jason.encode!(beacon)
      assert encoded =~ ~s("major":100)
      assert encoded =~ ~s("proximityUUID":"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
    end
  end

  describe "new/1 with proximity_UUID field" do
    test "creates a valid Beacons struct with proximity_UUID field" do
      params = %{proximity_UUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"}

      assert %Beacons{} = beacon = Beacons.new(params)
      assert beacon.proximity_UUID == params.proximity_UUID
      assert beacon.major == nil
      assert beacon.minor == nil
      encoded = Jason.encode!(beacon)
      assert encoded =~ ~s("proximityUUID":"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
    end

    test "returns error for invalid proximity_UUID (not a UUID)" do
      params = %{proximity_UUID: "not-a-uuid"}

      assert_raise ArgumentError, "proximity_UUID must be a valid UUID string", fn ->
        Beacons.new(params)
      end
    end

    test "returns error for missing proximity_UUID" do
      params = %{major: 100, minor: 50}

      assert_raise ArgumentError, "proximity_UUID is required", fn ->
        Beacons.new(params)
      end
    end

    test "returns error for invalid proximity_UUID (non-string value)" do
      params = %{proximity_UUID: 12_345}

      assert_raise ArgumentError, "proximity_UUID must be a valid UUID string", fn ->
        Beacons.new(params)
      end
    end

    test "returns error for invalid proximity_UUID (nil value)" do
      params = %{proximity_UUID: nil}

      assert_raise ArgumentError, "proximity_UUID is required", fn ->
        Beacons.new(params)
      end
    end
  end

  describe "new/1 with relevant_text field" do
    test "creates a valid Beacons struct with relevant_text field" do
      params = %{
        proximity_UUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0",
        relevant_text: "Nearby store"
      }

      assert %Beacons{} = beacon = Beacons.new(params)
      assert beacon.relevant_text == params.relevant_text
      encoded = Jason.encode!(beacon)
      assert encoded =~ ~s("relevantText":"Nearby store")
      assert encoded =~ ~s("proximityUUID":"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
    end

    test "creates a valid Beacons struct with all fields" do
      params = %{
        proximity_UUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0",
        major: 100,
        minor: 50,
        relevant_text: "Nearby store"
      }

      assert %Beacons{} = beacon = Beacons.new(params)
      assert beacon.major == params.major
      assert beacon.minor == params.minor
      assert beacon.relevant_text == params.relevant_text
      encoded = Jason.encode!(beacon)
      assert encoded =~ ~s("major":100)
      assert encoded =~ ~s("minor":50)
      assert encoded =~ ~s("relevantText":"Nearby store")
      assert encoded =~ ~s("proximityUUID":"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
    end

    test "raises an error for invalid relevant_text" do
      params = %{
        proximity_UUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0",
        relevant_text: 123
      }

      assert_raise ArgumentError, "relevant_text must be a non-empty string if provided", fn ->
        Beacons.new(params)
      end
    end
  end
end
