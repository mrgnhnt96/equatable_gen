#!/usr/bin/env bash
# Test equatable_gen with each major analyzer version.
# Ensures code generation and compilation work across analyzer releases.

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GEN_DIR="$ROOT/equatable_gen"
TEST_DIR="$ROOT/e2e_tests"
GEN_OVERRIDES="$GEN_DIR/pubspec_overrides.yaml"
TEST_OVERRIDES="$TEST_DIR/pubspec_overrides.yaml"
GEN_OVERRIDES_BAK="$GEN_DIR/pubspec_overrides.yaml.bak"
TEST_OVERRIDES_BAK="$TEST_DIR/pubspec_overrides.yaml.bak"

# One version per major branch supported by build/build_runner (>=8.0.0 <11.0.0).
# Using later minors for compatibility with build_runner 2.12.x.
VERSIONS=(8.4.1 9.0.0 10.0.0)

restore_overrides() {
  if [[ -f "$GEN_OVERRIDES_BAK" ]]; then
    mv "$GEN_OVERRIDES_BAK" "$GEN_OVERRIDES"
  fi
  if [[ -f "$TEST_OVERRIDES_BAK" ]]; then
    mv "$TEST_OVERRIDES_BAK" "$TEST_OVERRIDES"
  fi
}

trap restore_overrides EXIT

run_test() {
  local version=$1
  echo ""
  echo "========================================"
  echo "Testing analyzer $version"
  echo "========================================"

  # dart_style 3.1.3 supports analyzer 8-9; 3.1.4+ supports analyzer 10+.
  # Must pin dart_style per analyzer to avoid incompatible resolution.
  local dart_style_override=""
  if [[ "$version" == 10.* ]]; then
    dart_style_override="
  dart_style: ^3.1.4"
  else
    dart_style_override="
  dart_style: 3.1.3"
  fi

  # Write overrides with analyzer pin (both packages must use same version)
  cat > "$GEN_OVERRIDES" << EOF
dependency_overrides:
  equatable_annotations:
    path: ../equatable_annotations
  analyzer: "$version"$dart_style_override
EOF
  cat > "$TEST_OVERRIDES" << EOF
dependency_overrides:
  equatable_annotations:
    path: ../equatable_annotations
  equatable_gen:
    path: ../equatable_gen
  analyzer: "$version"$dart_style_override
EOF

  # Resolve dependencies
  cd "$ROOT/equatable_annotations" && dart pub get
  cd "$GEN_DIR" && dart pub get
  cd "$TEST_DIR" && dart pub get

  # Build generator package
  cd "$GEN_DIR" && dart run build_runner build --delete-conflicting-outputs

  # Generate code in e2e_tests (mirrors test:e2e flow)
  sh "$ROOT/scripts/create_tests.sh"
  cd "$TEST_DIR" && dart run build_runner build --delete-conflicting-outputs

  # Run tests
  cd "$GEN_DIR" && dart test
  cd "$TEST_DIR" && dart test --test-randomize-ordering-seed=random

  echo "✓ analyzer $version: build and tests passed"
}

# Backup original overrides
cp "$GEN_OVERRIDES" "$GEN_OVERRIDES_BAK"
cp "$TEST_OVERRIDES" "$TEST_OVERRIDES_BAK"

echo "Testing equatable_gen with analyzer versions: ${VERSIONS[*]}"
for v in "${VERSIONS[@]}"; do
  run_test "$v"
done

restore_overrides
trap - EXIT

echo ""
echo "All analyzer versions passed!"
