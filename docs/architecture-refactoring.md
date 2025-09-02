# ExPass Architecture Refactoring Plan

## Executive Summary

This document outlines a comprehensive refactoring plan for the ExPass library to address architectural issues identified during the implementation of PassField types (Issues #64-69). The primary goals are to improve maintainability, reduce code duplication, and establish clear patterns for future development.

## Current Architecture Analysis

### Issues Identified

1. **Monolithic Validators Module** (1084 lines)
   - Single file containing all validation logic
   - Difficult to maintain and test
   - No clear separation of concerns
   - Hard to find specific validators

2. **Missing Abstractions**
   - No PassFields collection module (blocking 5 pass types)
   - No factory/builder patterns for object creation
   - No clear inheritance hierarchy

3. **Code Duplication** (~800 lines)
   - Each PassField type duplicates FieldContent functionality
   - Repeated validation pipelines
   - Duplicated Jason.Encoder implementations
   - Repeated TypedStruct definitions

4. **Inconsistent Patterns**
   - Mixed validation approaches
   - Inconsistent error messages
   - No standardized field inheritance

## Proposed Architecture

### 1. Modularized Validators

Split the monolithic `validators.ex` into domain-specific modules:

```elixir
lib/
└── utils/
    └── validators/
        ├── base.ex           # Common validation functions
        ├── string.ex         # String validators
        ├── number.ex         # Numeric validators
        ├── date_time.ex      # Date/time validators
        ├── currency.ex       # Currency validators
        ├── location.ex       # GPS/location validators
        ├── barcode.ex        # Barcode-specific validators
        └── pass_specific.ex  # Pass-specific validators
```

### 2. FieldBase Macro Module

Create a macro-based inheritance system to eliminate duplication:

```elixir
defmodule ExPass.Structs.FieldBase do
  defmacro __using__(opts) do
    parent_module = Keyword.get(opts, :inherit_from)
    additional_fields = Keyword.get(opts, :fields, [])
    validators = Keyword.get(opts, :validators, [])
    
    quote do
      use TypedStruct
      import ExPass.Utils.Validators.Base
      
      # Inherit parent fields if specified
      unquote(if parent_module do
        quote do
          # Copy parent typedstruct fields
          unquote(parent_module).__struct_fields__()
          |> Enum.each(fn {field_name, field_spec} ->
            field field_name, field_spec.type, field_spec.opts
          end)
        end
      end)
      
      # Add additional fields
      typedstruct do
        unquote(additional_fields)
      end
      
      # Standard new/1 function with validation pipeline
      def new(attrs \\ %{}) do
        attrs
        |> apply_defaults()
        |> validate_fields()
        |> case do
          {:ok, validated} -> {:ok, struct(__MODULE__, validated)}
          error -> error
        end
      end
      
      # Jason.Encoder with camelCase conversion
      defimpl Jason.Encoder do
        def encode(struct, opts) do
          struct
          |> Map.from_struct()
          |> Map.drop([:__struct__, :__meta__])
          |> ExPass.Utils.Converter.to_camel_case()
          |> Jason.Encode.map(opts)
        end
      end
      
      # Allow modules to override
      defoverridable [new: 1, apply_defaults: 1, validate_fields: 1]
    end
  end
end
```

### 3. PassFields Collection Module

Implement the missing PassFields module to unblock pass types:

```elixir
defmodule ExPass.Structs.PassFields do
  use ExPass.Structs.FieldBase
  
  typedstruct do
    field :auxiliary_fields, list(AuxiliaryFields.t()), default: []
    field :back_fields, list(BackFields.t()), default: []
    field :header_fields, list(HeaderFields.t()), default: []
    field :primary_fields, list(PrimaryFields.t()), default: []
    field :secondary_fields, list(SecondaryFields.t()), default: []
  end
  
  def validate_fields(attrs) do
    with {:ok, auxiliary} <- validate_field_list(attrs[:auxiliary_fields], AuxiliaryFields),
         {:ok, back} <- validate_field_list(attrs[:back_fields], BackFields),
         {:ok, header} <- validate_field_list(attrs[:header_fields], HeaderFields),
         {:ok, primary} <- validate_field_list(attrs[:primary_fields], PrimaryFields),
         {:ok, secondary} <- validate_field_list(attrs[:secondary_fields], SecondaryFields) do
      {:ok, %{
        auxiliary_fields: auxiliary,
        back_fields: back,
        header_fields: header,
        primary_fields: primary,
        secondary_fields: secondary
      }}
    end
  end
  
  defp validate_field_list(nil, _module), do: {:ok, []}
  defp validate_field_list([], _module), do: {:ok, []}
  defp validate_field_list(fields, module) when is_list(fields) do
    fields
    |> Enum.reduce_while({:ok, []}, fn field, {:ok, acc} ->
      case module.new(field) do
        {:ok, validated} -> {:cont, {:ok, acc ++ [validated]}}
        error -> {:halt, error}
      end
    end)
  end
end
```

### 4. Simplified PassField Implementation

With the FieldBase macro, PassField types become concise:

```elixir
defmodule ExPass.Structs.PassFields.AuxiliaryFields do
  use ExPass.Structs.FieldBase,
    inherit_from: ExPass.Structs.FieldContent,
    fields: quote do
      field :row, integer(), default: 0
    end,
    validators: [:validate_row]
  
  defp validate_row(%{row: row} = attrs) when row in [0, 1], do: {:ok, attrs}
  defp validate_row(%{row: nil} = attrs), do: {:ok, Map.put(attrs, :row, 0)}
  defp validate_row(_), do: {:error, "row must be 0 or 1"}
end

defmodule ExPass.Structs.PassFields.BackFields do
  use ExPass.Structs.FieldBase,
    inherit_from: ExPass.Structs.FieldContent
  # No additional fields needed
end

defmodule ExPass.Structs.PassFields.HeaderFields do
  use ExPass.Structs.FieldBase,
    inherit_from: ExPass.Structs.FieldContent
  # No additional fields needed
end

defmodule ExPass.Structs.PassFields.PrimaryFields do
  use ExPass.Structs.FieldBase,
    inherit_from: ExPass.Structs.FieldContent
  # No additional fields needed
end

defmodule ExPass.Structs.PassFields.SecondaryFields do
  use ExPass.Structs.FieldBase,
    inherit_from: ExPass.Structs.FieldContent
  # No additional fields needed
end
```

### 5. Factory Pattern for Test Data

Implement factories for easier testing:

```elixir
defmodule ExPass.Factory do
  def build(:field_content, attrs \\ %{}) do
    defaults = %{
      key: "field_#{System.unique_integer([:positive])}",
      value: "Test Value",
      label: "Test Label"
    }
    
    Map.merge(defaults, attrs)
  end
  
  def build(:auxiliary_fields, attrs \\ %{}) do
    attrs
    |> Map.put_new(:row, 0)
    |> build(:field_content)
  end
  
  def build(:pass_fields, attrs \\ %{}) do
    %{
      auxiliary_fields: attrs[:auxiliary_fields] || [],
      back_fields: attrs[:back_fields] || [],
      header_fields: attrs[:header_fields] || [],
      primary_fields: attrs[:primary_fields] || [],
      secondary_fields: attrs[:secondary_fields] || []
    }
  end
  
  def build(:boarding_pass, attrs \\ %{}) do
    %{
      transit_type: attrs[:transit_type] || "PKTransitTypeAir",
      pass_fields: build(:pass_fields, attrs[:pass_fields] || %{})
    }
    |> Map.merge(build(:pass, attrs))
  end
end
```

### 6. Builder Pattern for Complex Objects

Implement builders for step-by-step construction:

```elixir
defmodule ExPass.Builder.PassBuilder do
  defstruct pass: %{}, errors: []
  
  def new(type \\ :generic) do
    %__MODULE__{pass: %{pass_type: type}}
  end
  
  def add_field(builder, field_type, field_data) do
    case validate_field(field_type, field_data) do
      {:ok, field} ->
        updated_pass = update_in(
          builder.pass,
          [field_type],
          &((&1 || []) ++ [field])
        )
        %{builder | pass: updated_pass}
      
      {:error, reason} ->
        %{builder | errors: builder.errors ++ [{field_type, reason}]}
    end
  end
  
  def add_barcode(builder, barcode_data) do
    # Specialized method for barcode
  end
  
  def add_location(builder, location_data) do
    # Specialized method for location
  end
  
  def build(%{errors: []} = builder) do
    Pass.new(builder.pass)
  end
  
  def build(%{errors: errors}) do
    {:error, errors}
  end
end

# Usage
{:ok, pass} = PassBuilder.new(:boarding_pass)
  |> PassBuilder.add_field(:primary_fields, %{key: "gate", value: "A12"})
  |> PassBuilder.add_field(:auxiliary_fields, %{key: "seat", value: "14F", row: 0})
  |> PassBuilder.add_barcode(%{format: "PKBarcodeFormatQR", message: "..."})
  |> PassBuilder.build()
```

## Implementation Roadmap

### Phase 1: Foundation (Week 1)
1. Create FieldBase macro module
2. Modularize validators into separate files
3. Update existing PassField types to use FieldBase
4. Write comprehensive tests

### Phase 2: PassFields Collection (Week 2)
1. Implement PassFields collection module
2. Add validation for field collections
3. Update tests
4. Document usage patterns

### Phase 3: Pass Types (Week 3-4)
1. Implement BoardingPass (#70)
2. Implement Coupon (#71)
3. Implement EventTicket (#72)
4. Implement Generic (#73)
5. Implement StoreCard (#74)

### Phase 4: Testing Infrastructure (Week 5)
1. Implement Factory pattern
2. Implement Builder pattern
3. Update all tests to use factories
4. Add property-based tests

### Phase 5: Documentation & Migration (Week 6)
1. Document all new patterns
2. Create migration guide
3. Update README with examples
4. Add architectural decision records (ADRs)

## Benefits

1. **Reduced Code Size**: ~800 lines eliminated through macro-based inheritance
2. **Better Organization**: Clear separation of concerns
3. **Easier Testing**: Factory and Builder patterns
4. **Improved Maintainability**: Modular structure
5. **Clear Patterns**: Established conventions for future development
6. **Unblocked Features**: Can implement all 5 pass types

## Migration Strategy

1. **Backward Compatibility**: Keep existing API during transition
2. **Incremental Migration**: Module by module approach
3. **Feature Flags**: Toggle between old/new implementations
4. **Comprehensive Testing**: Ensure no regressions
5. **Documentation**: Clear migration guides for users

## Success Metrics

- [ ] Validators module split into 8+ focused modules
- [ ] PassField types reduced from ~200 lines to ~20 lines each
- [ ] All 5 pass types implemented
- [ ] Test coverage maintained at >95%
- [ ] Documentation coverage at 100%
- [ ] Build time reduced by 20%

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Breaking changes | High | Maintain backward compatibility layer |
| Macro complexity | Medium | Comprehensive documentation and examples |
| Migration effort | Medium | Phased approach with feature flags |
| Test coverage gaps | Low | Property-based testing |

## Conclusion

This refactoring plan addresses the core architectural issues discovered during the PassField implementation. By introducing macro-based inheritance, modularizing validators, and establishing clear patterns, we can significantly improve the maintainability and extensibility of the ExPass library while reducing code duplication by approximately 75%.

The phased approach ensures minimal disruption while delivering incremental value. Each phase builds upon the previous one, creating a solid foundation for future development.

## Appendix: Code Examples

### Before: Duplicated PassField Implementation
```elixir
# ~200 lines per PassField type
defmodule ExPass.Structs.PassFields.SecondaryFields do
  use TypedStruct
  # ... all FieldContent fields duplicated ...
  # ... all validation logic duplicated ...
  # ... Jason.Encoder duplicated ...
end
```

### After: Macro-based PassField Implementation
```elixir
# ~20 lines per PassField type
defmodule ExPass.Structs.PassFields.SecondaryFields do
  use ExPass.Structs.FieldBase,
    inherit_from: ExPass.Structs.FieldContent
end
```

This represents a 90% reduction in code per PassField type while maintaining full functionality.
EOF < /dev/null