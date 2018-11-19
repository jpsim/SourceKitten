//
//  main.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Commandant
#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#else
#error("Unsupported platform")
#endif
import Dispatch

// `sourcekitd_set_notification_handler()` sets the handler to be executed on main thread queue.
// So, we vacate main thread to `dispatchMain()`.
DispatchQueue.global(qos: .default).async {
    let registry = CommandRegistry<SourceKittenError>()
    registry.register(CompleteCommand())
    registry.register(DocCommand())
    registry.register(FormatCommand())
    registry.register(IndexCommand())
    registry.register(ModuleInfoCommand())
    registry.register(SyntaxCommand())
    registry.register(StructureCommand())
    registry.register(RequestCommand())
    registry.register(VersionCommand())
    registry.register(HelpCommand(registry: registry))

    registry.main(defaultVerb: "help") { error in
        fputs("\(error)\n", stderr)
    }
}

dispatchMain()
