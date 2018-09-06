//
//  IndexCommand.swift
//  SourceKitten
//
//  Copyright (c) 2018 SourceKitten. All rights reserved.
//

import Commandant
import Result
import SourceKittenFramework

struct ModuleInfoCommand: CommandProtocol {
    let verb = "module_info"
    let function = "Obtain information about a Swift module and print as JSON"

    struct Options: OptionsProtocol {
        let module: String
        let compilerargs: [String]

        static func create(module: String) -> (_ compilerargs: [String]) -> Options {
            return { compilerargs in
                self.init(module: module, compilerargs: compilerargs)
            }
        }

        static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> mode <| Option(key: "module", defaultValue: "", usage: "name of the Swift module")
                <*> mode <| Argument(defaultValue: [],
                                     usage: "Compiler arguments to pass to SourceKit. This must be specified following the '--'")
        }
    }

    func run(_ options: Options) -> Result<(), SourceKittenError> {
        guard !options.module.isEmpty else {
            return .failure(.invalidArgument(description: "module must be set when calling \(verb)"))
        }
        let request = Request.moduleInfo(module: options.module, arguments: options.compilerargs)
        do {
            print(toJSON(toNSDictionary(try request.send())))
            return .success(())
        } catch {
            return .failure(.failed(error))
        }
    }
}
