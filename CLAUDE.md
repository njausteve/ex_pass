# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

ExPass is an Elixir library for generating and manipulating Apple Wallet passes (`.pkpass`). It models the Apple PassKit JSON schema (pass fields, semantic tags, barcodes, beacons, locations, NFC) as Elixir structs that validate their inputs and serialize to Apple's expected camelCase JSON via `Jason.Encoder`.

The `## Progress` table in README.md tracks which PassKit fields/objects are implemented (`✅`) vs. not yet started (`todo`), each linked to a GitHub issue. Check it before assuming a field exists or picking what to build next.

## Commands

```sh
mix deps.get                              # install dependencies
mix compile --warnings-as-errors          # compile (CI treats warnings as errors)
mix test                                  # run all tests
mix test test/structs/semantic_tags/currency_amount_test.exs        # run one file
mix test test/structs/semantic_tags/currency_amount_test.exs:20     # run one test at a line
mix format                                # auto-format
mix format --check-formatted              # verify formatting (CI gate)
mix credo                                 # lint (CI gate)
mix sobelow                               # security static analysis (CI gate)
mix coveralls.html                        # coverage report (CI enforces >= 97.56%)
```

Elixir 1.17.3 / OTP 27.1.2 per `.tool-versions`. CI (`.github/workflows/elixir-ci.yml`) runs the matrix against OTP 25/Elixir 1.16 and OTP 27/Elixir 1.17; only the 1.17 leg runs credo/sobelow/format/unused-deps checks and coverage.

## Architecture

**Struct pattern** — every pass-related struct (`lib/structs/**`) follows the same shape:

1. `use ExPass.Structs.Base` + `use TypedStruct`, fields declared in a `typedstruct do ... end` block. Required fields get `enforce: true`; optional fields get `default: nil` (or another concrete default).
2. `new/1` takes a map of attrs (default `%{}`), pipes it through `Converter.trim_string_values/1`, then through one `validate(:field, &Validators.some_check/1)` call per field, then `struct!(__MODULE__, attrs)`.
3. Validators return `:ok` or `{:error, "message"}`. The `validate/3` helper (injected by `use ExPass.Structs.Base`) raises `ArgumentError` on the first `{:error, reason}` it hits — so `new/1` fails fast with a human-readable message rather than accumulating errors.
4. `use ExPass.Structs.Base` also auto-derives `Jason.Encoder`: it drops any field whose value is `nil` and camelCases every key (`ExPass.Utils.Converter.camelize_key/1`) before encoding, so struct output matches Apple's expected JSON exactly.

**No struct inheritance** — Elixir has none. `ExPass.Structs.FieldContent` (`lib/structs/field_content.ex`) defines the canonical set of common pass-field attributes (`attributed_value`, `change_message`, `currency_code`, `data_detector_types`, `date_style`, `ignores_time_zone`, `is_relative`, `key`, `label`, `number_style`, `text_alignment`, `time_style`, `value`) and their validators. Structs that Apple's schema says "inherit" these (e.g. `lib/structs/pass_fields/auxiliary_fields.ex`) instead manually re-declare each field plus its own additions (like `row`) and re-run the same `Validators` calls — check `FieldContent` first when adding a new pass-field-group struct so the field list and validators stay consistent.

**Utils** (`lib/utils/`):
- `Validators` — pure `:ok | {:error, reason}` validation functions shared across structs (required/optional strings, enums like date/number/text-alignment styles, the full ISO 4217 currency code list, etc.).
- `PublicKey` — validates the NFC `encryptionPublicKey` field: decodes Base64, parses the DER `SubjectPublicKeyInfo`, and checks it's a P256 ECDH key in compressed (33-byte) or uncompressed (65-byte) point format.
- `Converter` — `trim_string_values/1` (whitespace trimming on map values before validation) and `camelize_key/1` (snake_case atom/string -> camelCase, used by the `Jason.Encoder` in `Base`).

**Directory layout**: `lib/structs/` holds top-level pass objects (barcodes, beacons, locations, nfc, field_content, base); `lib/structs/pass_fields/` holds field-group structs that build on `FieldContent`; `lib/structs/semantic_tags/` holds `SemanticTagType` structs (currency amount, seat, ...). Tests mirror this exactly under `test/`, one `_test.exs` per `lib` file, each starting with `doctest ExPass.Structs.X` followed by `ExUnit` `describe`/`test` blocks.

## Conventions

- Commits/PRs follow Conventional Commits (`feat(scope): ...`, `fix(scope): ...`, `style: ...`), matching `.github/PULL_REQUEST_TEMPLATE.md` and recent commit history.
- Every public function/module has `@moduledoc`/`@doc` with an Apple Developer Documentation link and an `## Examples` section with runnable `iex>` examples, including at least one error-raising example — this doc content is exercised by `doctest` in the corresponding test file, so keep it accurate.

## Multi-agent workflow

`.claude/workflows/implement-feature.js` is a saved Workflow (`Workflow({ name: "implement-feature", args: { description: "..." } })`) that implements a new struct/field end-to-end: an implementer agent writes the `lib/` + `test/` files per the conventions above, two verifier agents run in parallel (a correctness/convention review, and the actual `mix compile/credo/format/sobelow/test` gate), and a fixer agent loops in on any failures (capped at 3 rounds).
