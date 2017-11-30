//
//  CompleteCommand.swift
//  SourceKitten
//
//  Created by JP Simard on 9/4/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

import Commandant
import Foundation
import Result
import SourceKittenFramework

struct CompleteCommand: CommandProtocol {
    let verb = "complete"
    let function = "Generate code completion options"

    struct Options: OptionsProtocol {
        let file: String
        let text: String
        let offset: Int
        let spmModule: String
        let compilerargs: [String]

        static func create(file: String) -> (_ text: String) -> (_ offset: Int) -> (_ spmModule: String) -> (_ compilerargs: [String]) -> Options {
            return { text in { offset in { spmModule in { compilerargs in
                self.init(file: file, text: text, offset: offset, spmModule: spmModule, compilerargs: compilerargs)
            }}}}
        }

        static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> mode <| Option(key: "file", defaultValue: "", usage: "relative or absolute path of Swift file to parse")
                <*> mode <| Option(key: "text", defaultValue: "", usage: "Swift code text to parse")
                <*> mode <| Option(key: "offset", defaultValue: 0, usage: "Offset for which to generate code completion options.")
                <*> mode <| Option(key: "spm-module", defaultValue: "", usage: "Read compiler flags from a Swift Package Manager module")
                <*> mode <| Argument(defaultValue: [String](), usage: "Compiler arguments to pass to SourceKit. This must be specified following the '--'")
        }
    }

    func run(_ options: Options) -> Result<(), SourceKittenError> {
        let path: String
        let contents: String
        if !options.file.isEmpty {
            path = options.file.bridge().absolutePathRepresentation()
            guard let file = File(path: path) else {
                return .failure(.readFailed(path: options.file))
            }
            contents = file.contents
        } else {
            path = "\(NSUUID().uuidString).swift"
            contents = options.text
        }

        var args: [String]
        if options.spmModule.isEmpty {
            args = ["-c", path] + options.compilerargs
            if args.index(of: "-sdk") == nil {
                args.append(contentsOf: ["-sdk", sdkPath()])
            }
        } else {
            guard let module = Module(spmName: options.spmModule) else {
                return .failure(.invalidArgument(description: "Bad module name"))
            }
            args = module.compilerArguments
        }

        let request = Request.codeCompletionRequest(file: path, contents: contents,
            offset: Int64(options.offset),
            arguments: args)
        do {
            print(CodeCompletionItem.parse(response: try request.send()))
            return .success(())
        } catch {
            return .failure(.failed(error))
        }
    }
}
