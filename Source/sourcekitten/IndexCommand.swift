//
//  IndexCommand.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-04-24.
//  Copyright (c) 2016 SourceKitten. All rights reserved.
//

import Commandant
import Foundation
import Result
import SourceKittenFramework

struct IndexCommand: CommandType {
    let verb = "index"
    let function = "Index Swift file and print as JSON"

    struct Options: OptionsType {
        let file: String
        let compilerargs: String

        static func create(file: String) -> (compilerargs: String) -> Options {
            return { compilerargs in
                self.init(file: file, compilerargs: compilerargs)
            }
        }

        static func evaluate(m: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> m <| Option(key: "file", defaultValue: "", usage: "relative or absolute path of Swift file to index")
                <*> m <| Option(key: "compilerargs", defaultValue: "", usage: "Compiler arguments to pass to SourceKit. This must be specified following the '--'")
        }
    }

    func run(options: Options) -> Result<(), SourceKittenError> {
        guard !options.file.isEmpty else {
            return .Failure(.InvalidArgument(description: "file must be set when calling index"))
        }
        let absoluteFile = (options.file as NSString).absolutePathRepresentation()
        let request = Request.Index(
            file: absoluteFile,
            arguments:options.compilerargs.componentsSeparatedByString(" "))
        print(toJSON(toAnyObject(request.send())))
        return .Success()
    }
}
