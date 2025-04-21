defmodule ExPass.Structs.SemanticTags.SeatTest do
  @moduledoc false
  use ExUnit.Case, async: true
  alias ExPass.Structs.SemanticTags.Seat

  doctest Seat

  describe "new/0" do
    test "creates an empty Seat struct" do
      assert %Seat{} = Seat.new()
    end
  end

  describe "new/1 with seat_type" do
    test "creates a valid Seat struct with seat_type" do
      params = %{seat_type: "Reserved seating"}

      assert %Seat{} = seat = Seat.new(params)
      assert seat.seat_type == "Reserved seating"

      encoded = Jason.encode!(seat)
      assert encoded =~ ~s("seatType":"Reserved seating")
    end

    test "creates a valid Seat struct without seat_type" do
      assert %Seat{} = seat = Seat.new(%{})
      refute seat.seat_type

      encoded = Jason.encode!(seat)
      refute encoded =~ "seatType"
    end

    test "trims whitespace from seat_type" do
      params = %{seat_type: "  Reserved seat  "}

      assert %Seat{} = seat = Seat.new(params)
      assert seat.seat_type == "Reserved seat"
    end

    test "returns error for non-string seat_type" do
      params = %{seat_type: 123}

      assert_raise ArgumentError, "seat_type must be a non-empty string if provided", fn ->
        Seat.new(params)
      end
    end

    test "does not allow empty string for seat_type" do
      params = %{seat_type: ""}

      assert_raise ArgumentError, "seat_type must be a non-empty string if provided", fn ->
        Seat.new(params)
      end
    end
  end

  describe "new/1 with seat_description" do
    test "creates a valid Seat struct with seat_description" do
      params = %{seat_description: "Push back seat"}

      assert %Seat{} = seat = Seat.new(params)
      assert seat.seat_description == "Push back seat"

      encoded = Jason.encode!(seat)
      assert encoded =~ ~s("seatDescription":"Push back seat")
    end

    test "creates a valid Seat struct without seat_description" do
      assert %Seat{} = seat = Seat.new(%{})
      refute seat.seat_description

      encoded = Jason.encode!(seat)
      refute encoded =~ "seatDescription"
    end

    test "trims whitespace from seat_description" do
      params = %{seat_description: "  Push back seat  "}

      assert %Seat{} = seat = Seat.new(params)
      assert seat.seat_description == "Push back seat"
    end

    test "returns error for non-string seat_description" do
      params = %{seat_description: 123}

      assert_raise ArgumentError, "seat_description must be a non-empty string if provided", fn ->
        Seat.new(params)
      end
    end

    test "does not allow empty string for seat_description" do
      params = %{seat_description: ""}

      assert_raise ArgumentError, "seat_description must be a non-empty string if provided", fn ->
        Seat.new(params)
      end
    end
  end

  describe "new/1 with seat_identifier" do
    test "creates a valid Seat struct with seat_identifier" do
      params = %{seat_identifier: "Aisle 12, Row 3, Seat 5"}

      assert %Seat{} = seat = Seat.new(params)
      assert seat.seat_identifier == "Aisle 12, Row 3, Seat 5"

      encoded = Jason.encode!(seat)
      assert encoded =~ ~s("seatIdentifier":"Aisle 12, Row 3, Seat 5")
    end

    test "creates a valid Seat struct without seat_identifier" do
      assert %Seat{} = seat = Seat.new(%{})
      refute seat.seat_identifier

      encoded = Jason.encode!(seat)
      refute encoded =~ "seatIdentifier"
    end

    test "trims whitespace from seat_identifier" do
      params = %{seat_identifier: "  Aisle 12, Row 3, Seat 5  "}

      assert %Seat{} = seat = Seat.new(params)
      assert seat.seat_identifier == "Aisle 12, Row 3, Seat 5"
    end

    test "returns error for non-string seat_identifier" do
      params = %{seat_identifier: 123}

      assert_raise ArgumentError, "seat_identifier must be a non-empty string if provided", fn ->
        Seat.new(params)
      end
    end

    test "does not allow empty string for seat_identifier" do
      params = %{seat_identifier: ""}

      assert_raise ArgumentError, "seat_identifier must be a non-empty string if provided", fn ->
        Seat.new(params)
      end
    end
  end

  describe "new/1 with seat_number" do
    test "creates a valid Seat struct with seat_number" do
      params = %{seat_number: "3E"}

      assert %Seat{} = seat = Seat.new(params)
      assert seat.seat_number == "3E"

      encoded = Jason.encode!(seat)
      assert encoded =~ ~s("seatNumber":"3E")
    end

    test "creates a valid Seat struct without seat_number" do
      assert %Seat{} = seat = Seat.new(%{})
      refute seat.seat_number

      encoded = Jason.encode!(seat)
      refute encoded =~ "seatNumber"
    end

    test "trims whitespace from seat_number" do
      params = %{seat_number: "  3E  "}

      assert %Seat{} = seat = Seat.new(params)
      assert seat.seat_number == "3E"
    end

    test "returns error for non-string seat_number" do
      params = %{seat_number: 123}

      assert_raise ArgumentError, "seat_number must be a non-empty string if provided", fn ->
        Seat.new(params)
      end
    end

    test "does not allow empty string for seat_number" do
      params = %{seat_number: ""}

      assert_raise ArgumentError, "seat_number must be a non-empty string if provided", fn ->
        Seat.new(params)
      end
    end
  end

  describe "new/1 with seat_row" do
    test "creates a valid Seat struct with seat_row" do
      params = %{seat_row: "3"}

      assert %Seat{} = seat = Seat.new(params)
      assert seat.seat_row == "3"

      encoded = Jason.encode!(seat)
      assert encoded =~ ~s("seatRow":"3")
    end

    test "creates a valid Seat struct without seat_row" do
      assert %Seat{} = seat = Seat.new(%{})
      refute seat.seat_row

      encoded = Jason.encode!(seat)
      refute encoded =~ "seatRow"
    end

    test "trims whitespace from seat_row" do
      params = %{seat_row: "  3  "}

      assert %Seat{} = seat = Seat.new(params)
      assert seat.seat_row == "3"
    end

    test "returns error for non-string seat_row" do
      params = %{seat_row: 123}

      assert_raise ArgumentError, "seat_row must be a non-empty string if provided", fn ->
        Seat.new(params)
      end
    end

    test "does not allow empty string for seat_row" do
      params = %{seat_row: ""}

      assert_raise ArgumentError, "seat_row must be a non-empty string if provided", fn ->
        Seat.new(params)
      end
    end
  end

  describe "new/1 with seat_section" do
    test "creates a valid Seat struct with seat_section" do
      params = %{seat_section: "Aisle 12"}

      assert %Seat{} = seat = Seat.new(params)
      assert seat.seat_section == "Aisle 12"

      encoded = Jason.encode!(seat)
      assert encoded =~ ~s("seatSection":"Aisle 12")
    end

    test "creates a valid Seat struct without seat_section" do
      assert %Seat{} = seat = Seat.new(%{})
      refute seat.seat_section

      encoded = Jason.encode!(seat)
      refute encoded =~ "seat_section"
    end

    test "trims whitespace from seat_section" do
      params = %{seat_section: "  Aisle 12  "}

      assert %Seat{} = seat = Seat.new(params)
      assert seat.seat_section == "Aisle 12"
    end

    test "returns error for non-string seat_section" do
      params = %{seat_section: 123}

      assert_raise ArgumentError, "seat_section must be a non-empty string if provided", fn ->
        Seat.new(params)
      end
    end

    test "does not allow empty string for seat_section" do
      params = %{seat_section: ""}

      assert_raise ArgumentError, "seat_section must be a non-empty string if provided", fn ->
        Seat.new(params)
      end
    end
  end
end
