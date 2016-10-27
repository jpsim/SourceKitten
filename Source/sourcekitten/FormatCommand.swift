//
//  FormatCommand.swift
//  SourceKitten
//
//  Created by JP Simard on 2016-05-28.
//  Copyright (c) 2016 SourceKitten. All rights reserved.
//

import Commandant
import Foundation
import Result
import SourceKittenFramework

struct FormatCommand: CommandProtocol {
    let verb = "format"
    let function = "Format Swift file"

    struct Options: OptionsProtocol {
        let file: String
        let trimWhitespace: Bool
        let useTabs: Bool
        let indentWidth: Int

        static func create(file: String) -> (_ trimWhitespace: Bool) -> (_ useTabs: Bool) -> (_ indentWidth: Int) -> Options {
            return { trimWhitespace in { useTabs in { indentWidth in
                self.init(file: file, trimWhitespace: trimWhitespace, useTabs: useTabs, indentWidth: indentWidth)
            }}}
        }

        static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> mode <| Option(key: "file", defaultValue: "", usage: "relative or absolute path of Swift file to format")
                <*> mode <| Option(key: "trim-whitespace", defaultValue: true, usage: "trim trailing whitespace")
                <*> mode <| Option(key: "use-tabs", defaultValue: false, usage: "use tabs to indent")
                <*> mode <| Option(key: "indent-width", defaultValue: 4, usage: "number of spaces to indent")
        }
    }

    func run(_ options: Options) -> Result<(), SourceKittenError> {
        guard !options.file.isEmpty else {
            return .failure(.invalidArgument(description: "file must be set when calling format"))
        }
        do {
            try File(path: options.file)?
                .format(trimmingTrailingWhitespace: options.trimWhitespace,
                        useTabs: options.useTabs,
                        indentWidth: options.indentWidth)
                .data(using: .utf8)?
                .write(to: URL(fileURLWithPath: options.file), options: [])
            return .success(())
        } catch {
            return .failure(.failed(error))
        }
    }
}
