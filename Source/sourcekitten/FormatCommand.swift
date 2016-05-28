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

struct FormatCommand: CommandType {
    let verb = "format"
    let function = "Format Swift file"

    struct Options: OptionsType {
        let file: String
        let trimWhitespace: Bool
        let useTabs: Bool
        let indentWidth: Int

        static func create(file: String) -> (trimWhitespace: Bool) -> (useTabs: Bool) -> (indentWidth: Int) -> Options {
            return { trimWhitespace in { useTabs in { indentWidth in
                self.init(file: file, trimWhitespace: trimWhitespace, useTabs: useTabs, indentWidth: indentWidth)
            }}}
        }

        static func evaluate(m: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> m <| Option(key: "file", defaultValue: "", usage: "relative or absolute path of Swift file to format")
                <*> m <| Option(key: "trim-whitespace", defaultValue: true, usage: "trim trailing whitespace")
                <*> m <| Option(key: "use-tabs", defaultValue: false, usage: "use tabs to indent")
                <*> m <| Option(key: "indent-width", defaultValue: 4, usage: "number of spaces to indent")
        }
    }

    func run(options: Options) -> Result<(), SourceKittenError> {
        guard !options.file.isEmpty else {
            return .Failure(.InvalidArgument(description: "file must be set when calling format"))
        }
        let absolutePath = (options.file as NSString).absolutePathRepresentation()
        try! File(path: absolutePath)?
            .format(trimmingTrailingWhitespace: options.trimWhitespace,
                    useTabs: options.useTabs,
                    indentWidth: options.indentWidth)
            .dataUsingEncoding(NSUTF8StringEncoding)?
            .writeToFile(absolutePath, options: [])
        return .Success()
    }
}
