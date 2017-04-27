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

struct IndexCommand: CommandProtocol {
    let verb = "index"
    let function = "Index Swift file and print as JSON"

    struct Options: OptionsProtocol {
        let file: String
        let compilerargs: String

        static func create(file: String) -> (_ compilerargs: String) -> Options {
            return { compilerargs in
                self.init(file: file, compilerargs: compilerargs)
            }
        }

        static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> mode <| Option(key: "file", defaultValue: "", usage: "relative or absolute path of Swift file to index")
                <*> mode <| Option(key: "compilerargs", defaultValue: "",
                                   usage: "Compiler arguments to pass to SourceKit. This must be specified following the '--'")
        }
    }

    func run(_ options: Options) -> Result<(), SourceKittenError> {
        guard !options.file.isEmpty else {
            return .failure(.invalidArgument(description: "file must be set when calling index"))
        }
        let absoluteFile = options.file.bridge().absolutePathRepresentation()
        let request = Request.index(file: absoluteFile, arguments: options.compilerargs.components(separatedBy: " "))
        print(toJSON(toNSDictionary(request.send())))
        return .success()
    }
}
