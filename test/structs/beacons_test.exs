defmodule ExPass.Structs.BeaconsTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ExPass.Structs.Beacons

  describe "new/0" do
    test "creates a valid Beacons struct with default arguments" do
      beacons = Beacons.new()
      assert %Beacons{major: nil} = beacons
    end
  end

  describe "major field" do
    test "accepts valid major values" do
      assert %Beacons{major: 0} = Beacons.new(%{major: 0})
      assert %Beacons{major: 32768} = Beacons.new(%{major: 32768})
      assert %Beacons{major: 65535} = Beacons.new(%{major: 65535})
    end

    test "raises ArgumentError for invalid major values" do
      assert_raise ArgumentError,
                   "Invalid major: must be a 16-bit unsigned integer (0-65535)",
                   fn ->
                     Beacons.new(%{major: 70000})
                   end

      assert_raise ArgumentError,
                   "Invalid major: must be a 16-bit unsigned integer (0-65535)",
                   fn ->
                     Beacons.new(%{major: -1})
                   end

      assert_raise ArgumentError,
                   "Invalid major: must be a 16-bit unsigned integer (0-65535)",
                   fn ->
                     Beacons.new(%{major: "invalid"})
                   end
    end

    test "encodes to JSON with valid major values" do
      assert Jason.encode!(Beacons.new(%{major: 0})) == ~s({"major":0})
      assert Jason.encode!(Beacons.new(%{major: 12345})) == ~s({"major":12345})
      assert Jason.encode!(Beacons.new(%{major: 65535})) == ~s({"major":65535})
    end

    test "encodes to JSON without major" do
      assert Jason.encode!(Beacons.new(%{})) == ~s({})
    end
  end
end
