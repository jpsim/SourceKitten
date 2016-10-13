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
        let compilerargs: [String]

        static func create(file: String) -> (_ text: String) -> (_ offset: Int) -> (_ compilerargs: [String]) -> Options {
            return { text in { offset in { compilerargs in
                self.init(file: file, text: text, offset: offset, compilerargs: compilerargs)
            }}}
        }

        static func evaluate(_ m: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> m <| Option(key: "file", defaultValue: "", usage: "relative or absolute path of Swift file to parse")
                <*> m <| Option(key: "text", defaultValue: "", usage: "Swift code text to parse")
                <*> m <| Option(key: "offset", defaultValue: 0, usage: "Offset for which to generate code completion options.")
                <*> m <| Argument(defaultValue: [String](), usage: "Compiler arguments to pass to SourceKit. This must be specified following the '--'")
        }
    }

    func run(_ options: Options) -> Result<(), SourceKittenError> {
        let path: String
        let contents: String
        if !options.file.isEmpty {
            path = options.file.absolutePathRepresentation()
            guard let file = File(path: path) else {
                return .failure(.readFailed(path: options.file))
            }
            contents = file.contents
        } else {
            path = "\(NSUUID().uuidString).swift"
            contents = options.text
        }

        var args = ["-c", path]
        args.append(contentsOf: options.compilerargs)

        if args.index(of: "-sdk") == nil {
            args.append(contentsOf: ["-sdk", sdkPath()])
        }

        let request = Request.codeCompletionRequest(file: path, contents: contents,
            offset: Int64(options.offset),
            arguments: args)
        print(CodeCompletionItem.parse(response: request.send()))
        return .success()
    }
}
