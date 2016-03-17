#!/bin/sh

[ -z "$SRCROOT" -o -z "$BUILT_PRODUCTS_DIR" -o -z "$TARGET_BUILD_DIR" -o -z "$TARGET_TEMP_DIR" ] && exit 1

interfacegen=$BUILT_PRODUCTS_DIR/interfacegen

[ -x $interfacegen ] || exit 1

HEADER_PATH=$SRCROOT/Source/SourceKittenFramework
HEADER=$HEADER_PATH/sourcekitd.h
INTERFACEGEN_TEMPORARY_SOURCE=$TARGET_TEMP_DIR/interfacegen_sourcekitd.m

echo "#include \"$HEADER\"" > $INTERFACEGEN_TEMPORARY_SOURCE
$interfacegen -header $HEADER -- -fsyntax-only $INTERFACEGEN_TEMPORARY_SOURCE -I $HEADER_PATH
