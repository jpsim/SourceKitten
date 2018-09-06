//
//  SyntaxCommand.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-07.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Commandant
import Result
import SourceKittenFramework

struct SyntaxCommand: CommandProtocol {
    let verb = "syntax"
    let function = "Print Swift syntax information as JSON"

    struct Options: OptionsProtocol {
        let file: String
        let text: String

        static func create(file: String) -> (_ text: String) -> Options {
            return { text in
                self.init(file: file, text: text)
            }
        }

        static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> mode <| Option(key: "file", defaultValue: "", usage: "relative or absolute path of Swift file to parse")
                <*> mode <| Option(key: "text", defaultValue: "", usage: "Swift code text to parse")
        }
    }

    func run(_ options: Options) -> Result<(), SourceKittenError> {
        do {
            if !options.file.isEmpty {
                if let file = File(path: options.file) {
                    print(try SyntaxMap(file: file))
                    return .success(())
                }
                return .failure(.readFailed(path: options.file))
            }
            print(try SyntaxMap(file: File(contents: options.text)))
            return .success(())
        } catch {
            return .failure(.failed(error))
        }
    }
}
