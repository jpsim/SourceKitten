//
//  YamlCommand.swift
//  SourceKitten
//
//  Created by Keith Smiley on 12/12/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import Commandant
import Result
import SourceKittenFramework

struct RequestCommand: CommandProtocol {
    let verb = "request"
    let function = "Run a raw sourcekit request"

    struct Options: OptionsProtocol {
        let yaml: String

        static func create(yaml: String) -> Options {
            return self.init(yaml: yaml)
        }

        static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> mode <| Option(key: "yaml", defaultValue: "", usage: "a path to a yaml file, or yaml text to execute")
        }
    }

    func run(_ options: Options) -> Result<(), SourceKittenError> {
        do {
            if options.yaml.isEmpty {
                return .failure(.invalidArgument(description: "yaml file or text must be provided"))
            }

            let yaml: String
            if let file = File(path: options.yaml) {
                yaml = file.contents
            } else {
                yaml = options.yaml
            }

            let request = Request.yamlRequest(yaml: yaml)
            print(toJSON(toNSDictionary(try request.send())))
            return .success(())
        } catch {
            return .failure(.failed(error))
        }
    }
}
