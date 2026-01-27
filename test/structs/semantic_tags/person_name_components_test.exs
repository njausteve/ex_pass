defmodule ExPass.Structs.SemanticTags.PersonNameComponentsTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ExPass.Structs.SemanticTags.PersonNameComponents

  doctest ExPass.Structs.SemanticTags.PersonNameComponents

  describe "new/0" do
    test "creates an empty struct when called without arguments" do
      person = PersonNameComponents.new()

      assert %PersonNameComponents{
               family_name: nil,
               given_name: nil,
               middle_name: nil,
               name_prefix: nil,
               name_suffix: nil,
               nickname: nil,
               phonetic_representation: nil
             } = person
    end
  end

  describe "new/1 with valid fields" do
    test "creates a struct with given_name and family_name" do
      person = PersonNameComponents.new(%{given_name: "John", family_name: "Doe"})

      assert person.given_name == "John"
      assert person.family_name == "Doe"
    end

    test "creates a struct with all fields populated" do
      attrs = %{
        family_name: "Smith",
        given_name: "Jane",
        middle_name: "Marie",
        name_prefix: "Dr",
        name_suffix: "PhD",
        nickname: "JJ",
        phonetic_representation: "Jane Smith"
      }

      person = PersonNameComponents.new(attrs)

      assert person.family_name == "Smith"
      assert person.given_name == "Jane"
      assert person.middle_name == "Marie"
      assert person.name_prefix == "Dr"
      assert person.name_suffix == "PhD"
      assert person.nickname == "JJ"
      assert person.phonetic_representation == "Jane Smith"
    end

    test "trims whitespace from string values" do
      person = PersonNameComponents.new(%{given_name: "  John  ", family_name: "  Doe  "})

      assert person.given_name == "John"
      assert person.family_name == "Doe"
    end
  end

  describe "new/1 field validations" do
    test "raises an error for non-string family_name" do
      assert_raise ArgumentError,
                   "family_name must be a non-empty string if provided",
                   fn ->
                     PersonNameComponents.new(%{family_name: 123})
                   end
    end

    test "raises an error for non-string given_name" do
      assert_raise ArgumentError,
                   "given_name must be a non-empty string if provided",
                   fn ->
                     PersonNameComponents.new(%{given_name: 123})
                   end
    end

    test "raises an error for non-string middle_name" do
      assert_raise ArgumentError,
                   "middle_name must be a non-empty string if provided",
                   fn ->
                     PersonNameComponents.new(%{middle_name: 123})
                   end
    end

    test "raises an error for non-string name_prefix" do
      assert_raise ArgumentError,
                   "name_prefix must be a non-empty string if provided",
                   fn ->
                     PersonNameComponents.new(%{name_prefix: 123})
                   end
    end

    test "raises an error for non-string name_suffix" do
      assert_raise ArgumentError,
                   "name_suffix must be a non-empty string if provided",
                   fn ->
                     PersonNameComponents.new(%{name_suffix: 123})
                   end
    end

    test "raises an error for non-string nickname" do
      assert_raise ArgumentError,
                   "nickname must be a non-empty string if provided",
                   fn ->
                     PersonNameComponents.new(%{nickname: 123})
                   end
    end

    test "raises an error for non-string phonetic_representation" do
      assert_raise ArgumentError,
                   "phonetic_representation must be a non-empty string if provided",
                   fn ->
                     PersonNameComponents.new(%{phonetic_representation: 123})
                   end
    end

    test "raises an error for empty string fields" do
      assert_raise ArgumentError,
                   "given_name must be a non-empty string if provided",
                   fn ->
                     PersonNameComponents.new(%{given_name: ""})
                   end
    end
  end

  describe "JSON encoding" do
    test "encodes to JSON with camelCase keys" do
      person =
        PersonNameComponents.new(%{
          given_name: "John",
          family_name: "Doe",
          middle_name: "William"
        })

      encoded = Jason.encode!(person)

      assert encoded =~ ~s("givenName":"John")
      assert encoded =~ ~s("familyName":"Doe")
      assert encoded =~ ~s("middleName":"William")
      refute encoded =~ "given_name"
      refute encoded =~ "family_name"
      refute encoded =~ "middle_name"
    end

    test "omits nil fields from JSON output" do
      person = PersonNameComponents.new(%{given_name: "John"})
      encoded = Jason.encode!(person)

      assert encoded =~ ~s("givenName":"John")
      refute encoded =~ "familyName"
      refute encoded =~ "middleName"
      refute encoded =~ "namePrefix"
      refute encoded =~ "nameSuffix"
      refute encoded =~ "nickname"
      refute encoded =~ "phoneticRepresentation"
    end

    test "produces valid JSON that can be decoded" do
      person =
        PersonNameComponents.new(%{
          name_prefix: "Dr",
          given_name: "Jane",
          family_name: "Smith",
          name_suffix: "PhD"
        })

      encoded = Jason.encode!(person)
      decoded = Jason.decode!(encoded)

      assert decoded["namePrefix"] == "Dr"
      assert decoded["givenName"] == "Jane"
      assert decoded["familyName"] == "Smith"
      assert decoded["nameSuffix"] == "PhD"
    end
  end
end
