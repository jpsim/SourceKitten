//
//  main.swift
//  interfacegen
//
//  Created by Norio Nomura on 2/24/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//
// swiftlint:disable missing_docs
// swiftlint:disable variable_name

// Refs: https://github.com/apple/swift/blob/master/tools%2FSourceKit%2Ftools%2Fcomplete-test%2Fcomplete-test.cpp
// Refs: https://github.com/apple/swift/blob/master/test%2FSourceKit%2FInterfaceGen%2Fgen_header.swift

import Foundation

extension String {
    var absolutePath: String {
        return (self as NSString).absolutePath ? self :
            NSString.pathWithComponents([NSFileManager.defaultManager().currentDirectoryPath, self])
    }
}

// arguments
let moduleName = NSUserDefaults.standardUserDefaults().stringForKey("module")
let headerPath = NSUserDefaults.standardUserDefaults().stringForKey("header")?.absolutePath
let compilerArgs = Process.arguments.indexOf("--").map {
    Process.arguments.suffixFrom($0.advancedBy(1, limit: Process.arguments.endIndex))
}

// Setup uid of sourcekitd
let KeyRequest = sourcekitd_uid_get_from_cstr("key.request")
let KeyCompilerArgs = sourcekitd_uid_get_from_cstr("key.compilerargs")
let KeyModuleName = sourcekitd_uid_get_from_cstr("key.modulename")
let KeyName = sourcekitd_uid_get_from_cstr("key.name")
let KeyFilePath = sourcekitd_uid_get_from_cstr("key.filepath")
let KeySourceText = sourcekitd_uid_get_from_cstr("key.sourcetext")
let RequestEditorOpenInterface = sourcekitd_uid_get_from_cstr("source.request.editor.open.interface")
let RequestEditorOpenHeaderInterface = sourcekitd_uid_get_from_cstr("source.request.editor.open.interface.header")

let interfaceGenDocumentName = "/<interface-gen>"

// start
sourcekitd_initialize()
defer { sourcekitd_shutdown() }

// setup request
let request = sourcekitd_request_dictionary_create(nil, nil, 0)
defer { sourcekitd_request_release(request) }

if let moduleName = moduleName {
    sourcekitd_request_dictionary_set_uid(request, KeyRequest, RequestEditorOpenInterface)
} else if let headerPath = headerPath {
    sourcekitd_request_dictionary_set_uid(request, KeyRequest, RequestEditorOpenHeaderInterface)
}

sourcekitd_request_dictionary_set_string(request, KeyName, interfaceGenDocumentName)

if let compilerArgs = compilerArgs {
    let args = sourcekitd_request_array_create(nil, 0)
    compilerArgs.forEach { sourcekitd_request_array_set_string(args, -1, $0) }
    sourcekitd_request_dictionary_set_value(request, KeyCompilerArgs, args)
    sourcekitd_request_release(args)
}
if let moduleName = moduleName {
    sourcekitd_request_dictionary_set_string(request, KeyModuleName, moduleName)
}
if let headerPath = headerPath {
    sourcekitd_request_dictionary_set_string(request, KeyFilePath, headerPath)
}

// send request
let response = sourcekitd_send_request_sync(request)
if sourcekitd_response_is_error(response) {
    sourcekitd_response_description_dump(response)
    exit(1)
}
let info = sourcekitd_response_get_value(response)
if let source = String(UTF8String: sourcekitd_variant_dictionary_get_string(info, KeySourceText)) {
    let source = source.stringByReplacingOccurrencesOfString("\\n", withString: "\n")
    print(source)
} else {
    fputs("SourceKitService returned empty result.", stderr)
    exit(1)
}
