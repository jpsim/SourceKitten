//
//  VersionCommand.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-07.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Commandant
import Result
import SourceKittenFramework

struct VersionCommand: CommandProtocol {
    let verb = "version"
    let function = "Display the current version of SourceKitten"

    func run(_ options: NoOptions<SourceKittenError>) -> Result<(), SourceKittenError> {
        print(Version.current.value)
        return .success(())
    }
}
