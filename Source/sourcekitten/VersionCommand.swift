//
//  Version.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-07.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Commandant
import Result

private let version = "0.12.0"

struct VersionCommand: CommandType {
    let verb = "version"
    let function = "Display the current version of SourceKitten"

    func run(options: NoOptions<SourceKittenError>) -> Result<(), SourceKittenError> {
        print(version)
        return .Success()
    }
}
