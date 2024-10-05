defmodule ExPass.Structs.BeaconsTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ExPass.Structs.Beacons

  describe "new/0" do
    test "raises an error for missing proximityUUID" do
      assert_raise ArgumentError, "proximityUUID is required", fn ->
        Beacons.new()
      end
    end
  end

  describe "new/1 with minor field" do
    test "creates a valid Beacons struct with minor field" do
      params = %{proximityUUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", minor: 50}

      assert %Beacons{} = beacon = Beacons.new(params)
      assert beacon.minor == params.minor
      assert beacon.major == nil
      encoded = Jason.encode!(beacon)
      assert encoded =~ ~s("minor":50)
      assert encoded =~ ~s("proximityuuid":"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
    end

    test "creates a valid Beacons struct with minor field set to 0" do
      params = %{proximityUUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", minor: 0}

      assert %Beacons{} = beacon = Beacons.new(params)
      assert beacon.minor == 0
      encoded = Jason.encode!(beacon)
      assert encoded =~ ~s("minor":0)
      assert encoded =~ ~s("proximityuuid":"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
    end

    test "creates a valid Beacons struct with minor field set to 65535 (max value)" do
      params = %{proximityUUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", minor: 65_535}

      assert %Beacons{} = beacon = Beacons.new(params)
      assert beacon.minor == 65_535
      encoded = Jason.encode!(beacon)
      assert encoded =~ ~s("minor":65535)
      assert encoded =~ ~s("proximityuuid":"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
    end

    test "returns error for invalid minor (negative value)" do
      params = %{proximityUUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", minor: -1}

      assert_raise ArgumentError, "minor must be a 16-bit unsigned integer (0-65_535)", fn ->
        Beacons.new(params)
      end
    end

    test "returns error for invalid minor (value too large)" do
      params = %{proximityUUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", minor: 65_536}

      assert_raise ArgumentError, "minor must be a 16-bit unsigned integer (0-65_535)", fn ->
        Beacons.new(params)
      end
    end

    test "returns error for invalid minor (non-integer value)" do
      params = %{proximityUUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", minor: "50"}

      assert_raise ArgumentError, "minor must be a 16-bit unsigned integer (0-65_535)", fn ->
        Beacons.new(params)
      end
    end
  end

  describe "new/1 with major field" do
    test "creates a valid Beacons struct with major field" do
      params = %{proximityUUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", major: 100}

      assert %Beacons{} = beacon = Beacons.new(params)
      assert beacon.major == params.major
      assert beacon.minor == nil
      encoded = Jason.encode!(beacon)
      assert encoded =~ ~s("major":100)
      assert encoded =~ ~s("proximityuuid":"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
    end
  end

  describe "new/1 with proximityUUID field" do
    test "creates a valid Beacons struct with proximityUUID field" do
      params = %{proximityUUID: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"}

      assert %Beacons{} = beacon = Beacons.new(params)
      assert beacon.proximityUUID == params.proximityUUID
      assert beacon.major == nil
      assert beacon.minor == nil
      encoded = Jason.encode!(beacon)
      assert encoded =~ ~s("proximityuuid":"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
    end

    test "returns error for invalid proximityUUID (not a UUID)" do
      params = %{proximityUUID: "not-a-uuid"}

      assert_raise ArgumentError, "proximityUUID must be a valid UUID string", fn ->
        Beacons.new(params)
      end
    end

    test "returns error for missing proximityUUID" do
      params = %{major: 100, minor: 50}

      assert_raise ArgumentError, "proximityUUID is required", fn ->
        Beacons.new(params)
      end
    end
  end
end
