#!/bin/sh

[ -z "$SRCROOT" -o -z "$TARGET_TEMP_DIR" ] && exit 1

cd $SRCROOT/Source/SourceKittenFramework/
converter=$SRCROOT/Source/SourceKittenFramework/library_wrapper/convert_generated_interface_to_wrapper.py
interfacegen_sourcekitd=$SRCROOT/Source/SourceKittenFramework/library_wrapper/interfacegen_sourcekitd.sh
interfacegen_Clang_C=$SRCROOT/Source/SourceKittenFramework/library_wrapper/interfacegen_Clang_C.sh

# # sourcekitd.framework
# SOURCEKITD_GENERATED_INTERFACE=$TARGET_TEMP_DIR/sourcekitd_h.txt
# $interfacegen_sourcekitd > $SOURCEKITD_GENERATED_INTERFACE || exit 1
# $converter $SOURCEKITD_GENERATED_INTERFACE sourcekitd.framework/Versions/A/sourcekitd SourceKit > library_wrapper_sourcekitd.swift

# # libclang.dylib
# for f in CXString Documentation Index; do
#   Clang_C_GENERATED_INTERFACE=$TARGET_TEMP_DIR/${f}_h.txt
#   $interfacegen_Clang_C $f > $Clang_C_GENERATED_INTERFACE || exit 1
#   $converter $Clang_C_GENERATED_INTERFACE libclang.dylib Clang_C > library_wrapper_${f}.swift
# done
