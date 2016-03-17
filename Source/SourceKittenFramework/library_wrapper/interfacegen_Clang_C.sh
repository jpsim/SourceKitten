#!/bin/sh

[ -z "$SRCROOT" -o -z "$BUILT_PRODUCTS_DIR" -o -z "$TARGET_BUILD_DIR" -o -z "$TARGET_TEMP_DIR" ] && exit 1

interfacegen=$BUILT_PRODUCTS_DIR/interfacegen

[ -x $interfacegen ] || exit 1

INTERFACEGEN_SOURCE=$TARGET_TEMP_DIR/InterfacegenClangC.swift
INTERFACEGEN_BRIDGING_HEADER=$TARGET_TEMP_DIR/InterfacegenClangC-Bridging-header.h
INTERFACEGEN_MODULE_PATH=$TARGET_TEMP_DIR/InterfacegenClangC.swiftmodule

# clang-c/*.h are modified from original for including to SourceKittenFramework.h
# We need reverted version of them.
cp -pR $SRCROOT/Source/SourceKittenFramework/clang-c $TARGET_TEMP_DIR
for file in $TARGET_TEMP_DIR/clang-c/*.h; do
  sed -i "" -e 's/^#import <SourceKittenFramework\(\/.*\.h\)>/#include "clang-c\1"/' $file
done

cat <<EOF > $INTERFACEGEN_BRIDGING_HEADER
#import "clang-c/Documentation.h"
EOF

echo "import Foundation; import Clang_C" > $INTERFACEGEN_SOURCE

MCPOPT="-module-cache-path $MODULE_CACHE_DIR"

swiftc -v \
 -module-name InterfacegenClangC \
 -Onone \
 -sdk $SDKROOT \
 -target x86_64-apple-macosx10.11 \
 -g \
 $MCPOPT \
 -Xfrontend -serialize-debugging-options -enable-testing \
 -Xcc -I -Xcc $TARGET_BUILD_DIR \
 -I $TARGET_BUILD_DIR \
 -Xcc -F -Xcc $TARGET_BUILD_DIR \
 -F $TARGET_BUILD_DIR \
 -Xcc -I -Xcc $TARGET_TEMP_DIR \
 -I $TARGET_TEMP_DIR \
 -c -j4 $INTERFACEGEN_SOURCE \
 -emit-module -emit-module-path $INTERFACEGEN_MODULE_PATH \
 -import-objc-header $INTERFACEGEN_BRIDGING_HEADER

SOURCEKIT_LOGGING=0 $interfacegen \
 -module Clang_C.$1 -- \
 -target x86_64-apple-macosx10.11 \
 -module-name InterfacegenClangC \
 -sdk $SDKROOT \
 $MCPOPT \
 -Xcc -I -Xcc $TARGET_TEMP_DIR \
 -I $TARGET_TEMP_DIR \
 -import-objc-header $INTERFACEGEN_BRIDGING_HEADER
