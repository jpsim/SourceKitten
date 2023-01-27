#!/usr/bin/env bash

set -euo pipefail

# build
bazel build //... \
  --features swift.index_while_building \
  --features swift.use_global_index_store \
  --output_groups=+swift_index_store

# Set up temporary index store directory
readonly index_store_path="$(mktemp -d)"
rm -rf "$index_store_path"
trap "rm -rf ${index_store_path}" EXIT

# remap index store
ARCHS="arm64"
BAZEL_WORKSPACE_ROOT="$PWD"
DEVELOPER_DIR="$(xcode-select -p)"
SRCROOT="$PWD"
readonly bazel_root="^/private/var/tmp/_bazel_.+?/.+?/execroot/[^/]+"
readonly bazel_bin="^(?:$bazel_root/)?bazel-out/.+?/bin"
readonly bazel_external="$bazel_root/external"
readonly xcode_external="$BAZEL_WORKSPACE_ROOT/bazel-$(basename "$SRCROOT")/external"
readonly remote_developer_dir="^/.*/.+?\.app/Contents/Developer"
readonly local_developer_dir="$DEVELOPER_DIR"

# Installed from https://github.com/MobileNativeFoundation/index-import
index-import \
    -parallel-stride 10 \
    -undo-rules_swift-renames \
    -remap "$remote_developer_dir=$local_developer_dir" \
    -remap "$bazel_external=$xcode_external" \
    -remap "$bazel_root=$BAZEL_WORKSPACE_ROOT" \
    -remap "^([^//])=$BAZEL_WORKSPACE_ROOT/\$1" \
    "$SRCROOT/bazel-out/_global_index_store" \
    "$index_store_path"

# analyze for dead code
# Build SwiftLint from https://github.com/realm/SwiftLint/compare/jp-deadcode-2
# with `bazel build --config release swiftlint`
SWIFTLINT="$HOME/src/SwiftLint/bazel-bin/swiftlint"
"$SWIFTLINT" dead-code \
  --index-store-path "$index_store_path"
