# CLAUDE.md — jsonnet-path-utils

This file provides guidance for AI assistants working in this repository.

## Project Overview

`jsonnet-path-utils` is a Jsonnet utility library that provides functions for overriding and patching values at specific dot-notation paths and array indexes within nested data structures. It is designed for composable, declarative configuration management.

**Current version:** 2.0.0
**License:** MIT
**Package registry:** Jsonnet Bundler (`jb`)

---

## Repository Structure

```
jsonnet-path-utils/
├── path-utils/
│   ├── main.libsonnet      # Core library (the only source file)
│   └── BUILD               # Bazel build target: //path-utils:main
├── tests/
│   ├── test1-7.jsonnet     # Test cases
│   ├── test1-7_golden.json # Expected outputs (golden files)
│   └── BUILD               # Bazel test targets
├── vendor/
│   └── github.com/jsonnet-libs/docsonnet/  # Vendored doc-util dependency
├── docs/
│   └── README.md           # Auto-generated API docs (do not edit manually)
├── .github/
│   └── workflows/
│       ├── test.yml        # Run `bazel test tests/...` on push/PR
│       ├── lint.yml        # GitHub Actions linting via actionlint
│       ├── semantic-pr.yml # Enforce conventional commit format on PRs
│       └── release.yml     # Automated release via release-please
├── MODULE.bazel            # Bazel module: depends on rules_jsonnet v0.6.0
├── jsonnetfile.json        # Jsonnet Bundler manifest
├── jsonnetfile.lock.json   # Jsonnet Bundler lock file
├── docs.jsonnet            # Documentation generation entrypoint
├── .pre-commit-config.yaml # Pre-commit hooks
├── .tool-versions          # Requires bazelisk 1.20.0
├── README.md               # User-facing documentation with examples
└── CHANGELOG.md            # Semantic version history
```

---

## Core Library: `path-utils/main.libsonnet`

The entire library lives in a single file. It exports:

### Public Functions

| Function | Purpose |
|---|---|
| `withValueAtPath(path, override)` | Replace the value at a dot-notation path |
| `withValueAtPathMixin(path, override)` | Merge/patch the value at a dot-notation path |
| `withArrayItemAtPath(path, matcherFn, override)` | Replace array items matching a criterion |
| `withArrayItemAtPathMixin(path, matcherFn, override)` | Merge/patch array items matching a criterion |

### `matchers` Namespace (semi-private via `::`)

| Matcher | Purpose |
|---|---|
| `matchers.allItems()` | Matches every item in an array |
| `matchers.itemAtIndex(n)` | Matches item at a specific index |
| `matchers.objectKeyInItem(key)` | Matches objects containing a specific key |
| `matchers.objectKeyValueInItem({key: val})` | Matches objects with an exact key-value pair |
| `matchers.stringItem(str)` | Matches string items by value (replace only, no mixin) |

### Internal Helpers (local, not exported)

- `pathHelper(path)` — Converts a dot-notation string or array to a string array. Errors on invalid input.
- `overrideValue(item, override, mixin)` — Applies either `item + override` (mixin) or `override` (replace).
- `overrideArrayItem(arr, matcherFn, override, mixin)` — Maps over an array applying matcher logic.

### Key Design Patterns

- **Path traversal** uses recursive `depth` tracking. Intermediate keys use `+:` (patch) semantics; the final key uses either `:` (replace) or `+:` (mixin).
- **Mixin convention:** Functions ending in `Mixin` call the base function with `mixin=true`.
- **Matchers are closures** with signature `function(index, item, mixin) -> bool`.
- **`super` is available** in override objects to reference the existing value being replaced (useful for copying and modifying fields).
- **Path can be a string** (`"key1.key2"`) or an **array of strings** (`["key1", "key2"]`). Use array form when keys contain literal dots.

---

## Development Workflow

### Prerequisites

- [bazelisk](https://github.com/bazelbuild/bazelisk) 1.20.0 (manages Bazel versions automatically)
- [jsonnet](https://github.com/google/go-jsonnet) (for pre-commit formatting and doc generation)
- [jb](https://github.com/jsonnet-bundler/jsonnet-bundler) (Jsonnet Bundler, for dependency management)
- [pre-commit](https://pre-commit.com/) (for local hook enforcement)

### Running Tests

```bash
bazel test tests/...
```

Tests use the `jsonnet_to_json_test` rule: each test compiles a `.jsonnet` file to JSON and diffs against its `_golden.json` file.

To run a single test:

```bash
bazel test tests:test1
```

### Adding a New Test

1. Create `tests/testN.jsonnet` with your test case.
2. Run `bazel run tests:testN` to generate initial output, or manually create `tests/testN_golden.json`.
3. Add a `jsonnet_to_json_test` entry in `tests/BUILD` following the existing pattern (name, src, golden, deps, timeout).

### Updating Golden Files

If library behavior changes intentionally, regenerate golden files by running the test in update mode or by manually diffing and updating the JSON.

### Generating Documentation

```bash
jsonnet -J vendor -S -c -m docs/ docs.jsonnet
```

This is run automatically by the pre-commit `docsonnet` hook. **Do not manually edit `docs/README.md`** — it is always overwritten.

### Pre-commit Hooks

Install hooks with:

```bash
pre-commit install
```

Hooks enforce:
- Trailing whitespace removal
- JSON validity
- YAML validity
- No large files, no private keys, no merge conflict markers
- Jsonnet formatting via `jsonnet-format` (go-jsonnet v0.20.0)
- GitHub Actions linting via `actionlint` (v1.6.27)
- `docs/README.md` regeneration via `docsonnet`

---

## Code Conventions

### Jsonnet Style

- Use `local` for private helpers at file scope.
- Use `::` (hidden fields) for namespace objects (`matchers`) that are public but not directly serialized.
- Annotate all public functions and namespaces with docsonnet comments (`'#'` fields and `d.fn()`/`d.obj()` calls).
- Use named parameters (`mixin=`, `depth=`) for optional arguments with defaults.
- Assert input types at the top of each function with descriptive error messages.

### Naming

- Replace operations: `withValueAtPath`, `withArrayItemAtPath`
- Merge/patch operations: `withValueAtPathMixin`, `withArrayItemAtPathMixin`
- Matchers: noun-phrase describing what is matched (`objectKeyInItem`, `itemAtIndex`, etc.)

### Commit Messages

This repository enforces [Conventional Commits](https://www.conventionalcommits.org/) on all PRs. PRs must have a single commit with a semantic message. Examples:

```
feat: add new matcher for regex string matching
fix: handle empty path array correctly
docs: update advanced usage example
chore: bump rules_jsonnet to 0.7.0
```

Breaking changes require `!` or a `BREAKING CHANGE:` footer:

```
feat!: rename utils/ subdirectory to path-utils/
```

---

## CI/CD

| Workflow | Trigger | Action |
|---|---|---|
| `test.yml` | push to `main`, PRs | `bazel test tests/...` |
| `lint.yml` | push to `main`, PRs | `actionlint` on workflow files |
| `semantic-pr.yml` | PR open/edit/sync | Validates conventional commit format |
| `release.yml` | push to `main` | Automated release via `release-please` |

Releases are fully automated: merging a `feat:` commit bumps the minor version, `fix:` bumps the patch, and `feat!:` or `BREAKING CHANGE:` bumps the major version.

---

## Known Issues and Limitations

- **Path key expansion:** Every key in a dot-notation path is expanded as a patch (`+:`). This means the final key in the path is patched, not replaced. To replace a nested key, stop one level above and include the target key in the override object:

  ```jsonnet
  // Replaces key2's value entirely:
  + u.withValueAtPath('key1', { key2: { test: 'value' } })

  // Does NOT work as a clean replace of key2:
  + u.withValueAtPath('key1.key2', { test: 'value' })
  ```

- **`stringItem` does not support mixin:** Replacing string values in arrays must use `withArrayItemAtPath` (not `withArrayItemAtPathMixin`). The matcher will assert and error if mixin is attempted.

- **Chaining for multi-level arrays:** To traverse two nested arrays, chain `withArrayItemAtPath` calls — pass the inner call as the `override` to the outer call. See `tests/test7.jsonnet` for a real-world Prometheus alert example.

---

## Dependency Management

**Bazel deps** — edit `MODULE.bazel` and run `bazel mod tidy` if needed.

**Jsonnet deps** — managed via `jb`:
```bash
jb install   # install from jsonnetfile.lock.json
jb update    # update and regenerate lock file
```

The only runtime Jsonnet dependency is `docsonnet` (used only for doc generation, not by library consumers).

Dependabot is configured to open weekly PRs for GitHub Actions version bumps, using conventional commit format.
