//
//  DemangleCommand.swift
//  SourceKitten
//
//  Created by Brian Gesiak on 8/2/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import Commandant
import Foundation
import Result
import SourceKittenFramework

struct DemangleCommand: CommandType {
    let verb = "demangle"
    let function = "Demangle Swift mangled symbol names"

    struct Options: OptionsType {
        let names: String

        static func create(names: String) -> Options {
            return self.init(names: names)
        }

        static func evaluate(m: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> m <| Option(key: "names", defaultValue: "", usage: "a list of mangled Swift symbols")
        }
    }

    func run(options: Options) -> Result<(), SourceKittenError> {
        let request = Request.Demangle(names: options.names.componentsSeparatedByString(" "))
        request.send()
        return .Success()
    }
}
