defmodule ExPass.Structs.SemanticTags.PersonNameComponents do
  @moduledoc """
  Represents the components of a person's name for use in Apple Wallet pass semantic tags.

  This struct is used to represent a person's name broken down into its constituent parts,
  commonly used in semantic tags for passenger names, attendee information, or other
  person-related data on passes.

  ## Fields

  * `:family_name` - (Optional) The person's family name or last name.
  * `:given_name` - (Optional) The person's given name or first name.
  * `:middle_name` - (Optional) The person's middle name.
  * `:name_prefix` - (Optional) The prefix for the person's name, such as "Dr".
  * `:name_suffix` - (Optional) The suffix for the person's name, such as "Junior".
  * `:nickname` - (Optional) The person's nickname.
  * `:phonetic_representation` - (Optional) The phonetic representation of the person's name.

  ## Compatibility

  - iOS 12.0+
  - iPadOS 6.0+
  - watchOS 2.0+

  ## Apple Documentation

  See [Apple's PassKit documentation](https://developer.apple.com/documentation/walletpasses/semantictagtype/personnamecomponents)
  for more information about person name components in passes.
  """

  use ExPass.Structs.Base
  use TypedStruct

  alias ExPass.Utils.Converter
  alias ExPass.Utils.Validators

  typedstruct do
    field :family_name, String.t()
    field :given_name, String.t()
    field :middle_name, String.t()
    field :name_prefix, String.t()
    field :name_suffix, String.t()
    field :nickname, String.t()
    field :phonetic_representation, String.t()
  end

  @doc """
  Creates a new PersonNameComponents struct.

  ## Parameters

    * `attrs` - A map of attributes for the PersonNameComponents struct. All fields are optional:
      * `:family_name` - The person's family name or last name.
      * `:given_name` - The person's given name or first name.
      * `:middle_name` - The person's middle name.
      * `:name_prefix` - The prefix for the person's name, such as "Dr".
      * `:name_suffix` - The suffix for the person's name, such as "Junior".
      * `:nickname` - The person's nickname.
      * `:phonetic_representation` - The phonetic representation of the person's name.

  ## Returns

    * A new `%PersonNameComponents{}` struct.

  ## Examples

      iex> PersonNameComponents.new(%{given_name: "John", family_name: "Doe"})
      %PersonNameComponents{given_name: "John", family_name: "Doe", middle_name: nil, name_prefix: nil, name_suffix: nil, nickname: nil, phonetic_representation: nil}

      iex> PersonNameComponents.new(%{name_prefix: "Dr", given_name: "Jane", middle_name: "Marie", family_name: "Smith", name_suffix: "PhD"})
      %PersonNameComponents{name_prefix: "Dr", given_name: "Jane", middle_name: "Marie", family_name: "Smith", name_suffix: "PhD", nickname: nil, phonetic_representation: nil}

      iex> PersonNameComponents.new(%{})
      %PersonNameComponents{family_name: nil, given_name: nil, middle_name: nil, name_prefix: nil, name_suffix: nil, nickname: nil, phonetic_representation: nil}

      iex> PersonNameComponents.new(%{given_name: 123})
      ** (ArgumentError) given_name must be a non-empty string if provided

  """
  @spec new(map()) :: %__MODULE__{}
  def new(attrs \\ %{}) do
    attrs =
      attrs
      |> Converter.trim_string_values()
      |> validate(:family_name, &Validators.validate_optional_string(&1, :family_name))
      |> validate(:given_name, &Validators.validate_optional_string(&1, :given_name))
      |> validate(:middle_name, &Validators.validate_optional_string(&1, :middle_name))
      |> validate(:name_prefix, &Validators.validate_optional_string(&1, :name_prefix))
      |> validate(:name_suffix, &Validators.validate_optional_string(&1, :name_suffix))
      |> validate(:nickname, &Validators.validate_optional_string(&1, :nickname))
      |> validate(
        :phonetic_representation,
        &Validators.validate_optional_string(&1, :phonetic_representation)
      )

    struct!(__MODULE__, attrs)
  end
end
