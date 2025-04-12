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
          message: "Test message",
          message_encoding: "ISO-8859-1"
        })

      assert %Barcodes{
               alt_text: "Scan this QR code",
               format: "PKBarcodeFormatQR",
               message: "Test message",
               message_encoding: "ISO-8859-1"
             } = barcode

      encoded = Jason.encode!(barcode)
      assert encoded =~ ~s("altText":"Scan this QR code")
      assert encoded =~ ~s("format":"PKBarcodeFormatQR")
      assert encoded =~ ~s("message":"Test message")
      assert encoded =~ ~s("messageEncoding":"ISO-8859-1")
    end

    test "creates a valid Barcodes struct without alt_text" do
      barcode =
        Barcodes.new(%{
          format: "PKBarcodeFormatQR",
          message: "Test message",
          message_encoding: "ISO-8859-1"
        })

      assert %Barcodes{
               alt_text: nil,
               format: "PKBarcodeFormatQR",
               message: "Test message",
               message_encoding: "ISO-8859-1"
             } =
               barcode

      encoded = Jason.encode!(barcode)
      assert encoded =~ ~s("format":"PKBarcodeFormatQR")
      assert encoded =~ ~s("message":"Test message")
      assert encoded =~ ~s("messageEncoding":"ISO-8859-1")
      refute encoded =~ "altText"
    end

    test "raises ArgumentError when alt_text is not a string" do
      assert_raise ArgumentError, "alt_text must be a non-empty string if provided", fn ->
        Barcodes.new(%{
          alt_text: 123,
          format: "PKBarcodeFormatQR",
          message: "Test message",
          message_encoding: "ISO-8859-1"
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
        barcode =
          Barcodes.new(%{format: format, message: "Test message", message_encoding: "ISO-8859-1"})

        assert %Barcodes{format: ^format, message: "Test message", message_encoding: "ISO-8859-1"} =
                 barcode

        encoded = Jason.encode!(barcode)
        assert encoded =~ ~s("format":"#{format}")
        assert encoded =~ ~s("message":"Test message")
        assert encoded =~ ~s("messageEncoding":"ISO-8859-1")
      end
    end

    test "raises ArgumentError when format is missing" do
      assert_raise ArgumentError, "format is required", fn ->
        Barcodes.new(%{message: "Test message", message_encoding: "ISO-8859-1"})
      end
    end

    test "raises ArgumentError when format is not a string" do
      assert_raise ArgumentError, "format must be a string", fn ->
        Barcodes.new(%{format: 123, message: "Test message", message_encoding: "ISO-8859-1"})
      end
    end

    test "raises ArgumentError when format is an invalid value" do
      assert_raise ArgumentError,
                   "Invalid format: InvalidFormat. Supported values are: PKBarcodeFormatQR, PKBarcodeFormatPDF417, PKBarcodeFormatAztec, PKBarcodeFormatCode128",
                   fn ->
                     Barcodes.new(%{
                       format: "InvalidFormat",
                       message: "Test message",
                       message_encoding: "ISO-8859-1"
                     })
                   end
    end
  end

  describe "message field" do
    test "creates a valid Barcodes struct with message" do
      barcode =
        Barcodes.new(%{
          format: "PKBarcodeFormatQR",
          message: "Test message",
          message_encoding: "ISO-8859-1"
        })

      assert %Barcodes{
               format: "PKBarcodeFormatQR",
               message: "Test message",
               message_encoding: "ISO-8859-1"
             } = barcode

      encoded = Jason.encode!(barcode)
      assert encoded =~ ~s("message":"Test message")
      assert encoded =~ ~s("messageEncoding":"ISO-8859-1")
    end

    test "raises ArgumentError when message is missing" do
      assert_raise ArgumentError,
                   "message is a required field and must be a non-empty string",
                   fn ->
                     Barcodes.new(%{format: "PKBarcodeFormatQR", message_encoding: "ISO-8859-1"})
                   end
    end

    test "raises ArgumentError when message is not a string" do
      assert_raise ArgumentError,
                   "message is a required field and must be a non-empty string",
                   fn ->
                     Barcodes.new(%{
                       format: "PKBarcodeFormatQR",
                       message: 123,
                       message_encoding: "ISO-8859-1"
                     })
                   end
    end

    test "raises ArgumentError when message is an empty string" do
      assert_raise ArgumentError,
                   "message is a required field and must be a non-empty string",
                   fn ->
                     Barcodes.new(%{
                       format: "PKBarcodeFormatQR",
                       message: "",
                       message_encoding: "ISO-8859-1"
                     })
                   end
    end
  end

  describe "message_encoding field" do
    test "creates a valid Barcodes struct with message_encoding" do
      barcode =
        Barcodes.new(%{
          format: "PKBarcodeFormatQR",
          message: "Test message",
          message_encoding: "ISO-8859-1"
        })

      assert %Barcodes{
               format: "PKBarcodeFormatQR",
               message: "Test message",
               message_encoding: "ISO-8859-1"
             } = barcode

      encoded = Jason.encode!(barcode)
      assert encoded =~ ~s("messageEncoding":"ISO-8859-1")
    end

    test "raises ArgumentError when message_encoding is missing" do
      assert_raise ArgumentError, "message_encoding is required", fn ->
        Barcodes.new(%{format: "PKBarcodeFormatQR", message: "Test message"})
      end
    end

    test "raises ArgumentError when message_encoding is not a string" do
      assert_raise ArgumentError, "message_encoding must be a string", fn ->
        Barcodes.new(%{
          format: "PKBarcodeFormatQR",
          message: "Test message",
          message_encoding: 123
        })
      end
    end

    test "raises ArgumentError when message_encoding is an empty string" do
      assert_raise ArgumentError,
                   "Invalid message_encoding: . Supported values are: US-ASCII, ISO-8859-1, ISO-8859-2, ISO-8859-3, ISO-8859-4, ISO-8859-5, ISO-8859-6, ISO-8859-7, ISO-8859-8, ISO-8859-9, ISO-8859-10, Shift_JIS, EUC-JP, ISO-2022-KR, EUC-KR, ISO-2022-JP, ISO-2022-JP-2, ISO-8859-6-E, ISO-8859-6-I, ISO-8859-8-E, ISO-8859-8-I, GB2312, Big5, KOI8-R",
                   fn ->
                     Barcodes.new(%{
                       format: "PKBarcodeFormatQR",
                       message: "Test message",
                       message_encoding: ""
                     })
                   end
    end

    test "accepts valid IANA character set names" do
      valid_encodings = [
        "US-ASCII",
        "ISO-8859-1",
        "ISO-8859-2",
        "ISO-8859-3",
        "ISO-8859-4",
        "ISO-8859-5",
        "ISO-8859-6",
        "ISO-8859-7",
        "ISO-8859-8",
        "ISO-8859-9",
        "ISO-8859-10",
        "Shift_JIS",
        "EUC-JP",
        "ISO-2022-KR",
        "EUC-KR",
        "ISO-2022-JP",
        "ISO-2022-JP-2",
        "ISO-8859-6-E",
        "ISO-8859-6-I",
        "ISO-8859-8-E",
        "ISO-8859-8-I",
        "GB2312",
        "Big5",
        "KOI8-R"
      ]

      for encoding <- valid_encodings do
        barcode =
          Barcodes.new(%{
            format: "PKBarcodeFormatQR",
            message: "Test message",
            message_encoding: encoding
          })

        assert %Barcodes{message_encoding: ^encoding} = barcode
      end
    end

    test "raises ArgumentError for invalid message_encoding" do
      assert_raise ArgumentError,
                   "Invalid message_encoding: invalid-encoding. Supported values are: US-ASCII, ISO-8859-1, ISO-8859-2, ISO-8859-3, ISO-8859-4, ISO-8859-5, ISO-8859-6, ISO-8859-7, ISO-8859-8, ISO-8859-9, ISO-8859-10, Shift_JIS, EUC-JP, ISO-2022-KR, EUC-KR, ISO-2022-JP, ISO-2022-JP-2, ISO-8859-6-E, ISO-8859-6-I, ISO-8859-8-E, ISO-8859-8-I, GB2312, Big5, KOI8-R",
                   fn ->
                     Barcodes.new(%{
                       format: "PKBarcodeFormatQR",
                       message: "Test message",
                       message_encoding: "invalid-encoding"
                     })
                   end
    end
  end
end
