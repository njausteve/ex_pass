defmodule ExPass.Structs.BarcodesTest do
  @moduledoc false

  use ExUnit.Case
  alias ExPass.Structs.Barcodes

  doctest Barcodes

  describe "new/0" do
    test "raises ArgumentError when format is not provided" do
      assert_raise ArgumentError, "format is required", fn ->
        Barcodes.new()
      end
    end
  end

  describe "alt_text" do
    test "creates a valid Barcodes struct with alt_text and format" do
      barcode =
        Barcodes.new(%{
          alt_text: "Scan this QR code",
          format: "PKBarcodeFormatQR",
          message: "Test message"
        })

      assert %Barcodes{
               alt_text: "Scan this QR code",
               format: "PKBarcodeFormatQR",
               message: "Test message"
             } = barcode

      encoded = Jason.encode!(barcode)
      assert encoded =~ ~s("altText":"Scan this QR code")
      assert encoded =~ ~s("format":"PKBarcodeFormatQR")
      assert encoded =~ ~s("message":"Test message")
    end

    test "creates a valid Barcodes struct without alt_text" do
      barcode = Barcodes.new(%{format: "PKBarcodeFormatQR", message: "Test message"})

      assert %Barcodes{alt_text: nil, format: "PKBarcodeFormatQR", message: "Test message"} =
               barcode

      encoded = Jason.encode!(barcode)
      assert encoded =~ ~s("format":"PKBarcodeFormatQR")
      assert encoded =~ ~s("message":"Test message")
      refute encoded =~ "altText"
    end

    test "raises ArgumentError when alt_text is not a string" do
      assert_raise ArgumentError, "alt_text must be a string if provided", fn ->
        Barcodes.new(%{
          alt_text: 123,
          format: "PKBarcodeFormatQR",
          message: "Test message"
        })
      end
    end
  end

  describe "format field" do
    test "creates a valid Barcodes struct with format" do
      valid_formats = [
        "PKBarcodeFormatQR",
        "PKBarcodeFormatPDF417",
        "PKBarcodeFormatAztec",
        "PKBarcodeFormatCode128"
      ]

      for format <- valid_formats do
        barcode = Barcodes.new(%{format: format, message: "Test message"})
        assert %Barcodes{format: ^format, message: "Test message"} = barcode
        encoded = Jason.encode!(barcode)
        assert encoded =~ ~s("format":"#{format}")
        assert encoded =~ ~s("message":"Test message")
      end
    end

    test "raises ArgumentError when format is missing" do
      assert_raise ArgumentError, "format is required", fn ->
        Barcodes.new(%{message: "Test message"})
      end
    end

    test "raises ArgumentError when format is not a string" do
      assert_raise ArgumentError, "format must be a string", fn ->
        Barcodes.new(%{format: 123, message: "Test message"})
      end
    end

    test "raises ArgumentError when format is an invalid value" do
      assert_raise ArgumentError,
                   "Invalid format: InvalidFormat. Supported values are: PKBarcodeFormatQR, PKBarcodeFormatPDF417, PKBarcodeFormatAztec, PKBarcodeFormatCode128",
                   fn ->
                     Barcodes.new(%{format: "InvalidFormat", message: "Test message"})
                   end
    end
  end

  describe "message field" do
    test "creates a valid Barcodes struct with message" do
      barcode = Barcodes.new(%{format: "PKBarcodeFormatQR", message: "Test message"})
      assert %Barcodes{format: "PKBarcodeFormatQR", message: "Test message"} = barcode
      encoded = Jason.encode!(barcode)
      assert encoded =~ ~s("message":"Test message")
    end

    test "raises ArgumentError when message is missing" do
      assert_raise ArgumentError,
                   "message is a required field and must be a non-empty string",
                   fn ->
                     Barcodes.new(%{format: "PKBarcodeFormatQR"})
                   end
    end

    test "raises ArgumentError when message is not a string" do
      assert_raise ArgumentError,
                   "message is a required field and must be a non-empty string",
                   fn ->
                     Barcodes.new(%{format: "PKBarcodeFormatQR", message: 123})
                   end
    end

    test "raises ArgumentError when message is an empty string" do
      assert_raise ArgumentError,
                   "message is a required field and must be a non-empty string",
                   fn ->
                     Barcodes.new(%{format: "PKBarcodeFormatQR", message: ""})
                   end
    end
  end
end
