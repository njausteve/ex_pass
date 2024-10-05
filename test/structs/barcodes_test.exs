defmodule ExPass.Structs.BarcodesTest do
  @moduledoc false

  use ExUnit.Case
  alias ExPass.Structs.Barcodes

  doctest Barcodes

  describe "new/0" do
    test "creates an empty Barcodes struct" do
      barcode = Barcodes.new()
      assert %Barcodes{alt_text: nil} = barcode
    end

    test "encodes an empty Barcodes struct as an empty JSON object" do
      barcode = Barcodes.new()
      encoded = Jason.encode!(barcode)
      assert encoded == "{}"
    end
  end

  describe "alt_text" do
    test "creates a valid Barcodes struct with alt_text" do
      barcode =
        Barcodes.new(%{
          alt_text: "Scan this QR code"
        })

      assert %Barcodes{
               alt_text: "Scan this QR code"
             } = barcode

      encoded = Jason.encode!(barcode)
      assert encoded =~ ~s("altText":"Scan this QR code")
    end

    test "creates a valid Barcodes struct without alt_text" do
      barcode = Barcodes.new(%{})

      assert %Barcodes{alt_text: nil} = barcode

      encoded = Jason.encode!(barcode)
      assert encoded == "{}"
    end

    test "raises ArgumentError when alt_text is not a string" do
      assert_raise ArgumentError, "alt_text must be a string if provided", fn ->
        Barcodes.new(%{
          alt_text: 123
        })
      end
    end
  end
end
