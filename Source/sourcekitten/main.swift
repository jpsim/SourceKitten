//
//  main.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

#if os(Linux)
import Glibc
#else
import Darwin
#endif
import Commandant
import SourceKittenFramework

let registry = CommandRegistry<SourceKittenError>()
registry.register(command: SyntaxCommand())
registry.register(command: StructureCommand())
registry.register(command: VersionCommand())

let helpCommand = HelpCommand(registry: registry)
registry.register(command: helpCommand)

registry.main(defaultVerb: "help") { error in
    fputs("\(error)\n", stderr)
}
