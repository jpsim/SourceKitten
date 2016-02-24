#!/bin/sh

[ -z "$SRCROOT" ] && exit

cd $SRCROOT/Source/SourceKittenFramework/
converter=$SRCROOT/Source/SourceKittenFramework/library_wrapper/convert_generated_interface_to_wrapper.py

# sourcekitd.framework
$converter library_wrapper/sourcekitd_h.txt sourcekitd.framework/Versions/A/sourcekitd SourceKit > library_wrapper_sourcekitd.swift

# libclang.dylib
for f in CXString Documentation Index; do
    $converter library_wrapper/${f}_h.txt libclang.dylib Clang_C > library_wrapper_${f}.swift
done
