//
//  StructureCommand.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-07.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Commandant
import Result
import SourceKittenFramework

struct StructureCommand: CommandProtocol {
    let verb = "structure"
    let function = "Print Swift structure information as JSON"

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
                    print(try Structure(file: file))
                    return .success(())
                }
                return .failure(.readFailed(path: options.file))
            }
            if !options.text.isEmpty {
                print(try Structure(file: File(contents: options.text)))
                return .success(())
            }
            return .failure(
                .invalidArgument(description: "either file or text must be set when calling structure")
            )
        } catch {
            return .failure(.failed(error))
        }
    }
}
