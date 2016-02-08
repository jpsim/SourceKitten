//
//  main.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Darwin
import Foundation
import Commandant

// `sourcekitd_set_notification_handler()` set the handler to be executed on main thread queue.
// So, we vacate main thread to `dispatch_main()`.
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
    let registry = CommandRegistry<SourceKittenError>()
    registry.register(CompleteCommand())
    registry.register(DocCommand())
    registry.register(SyntaxCommand())
    registry.register(StructureCommand())
    registry.register(VersionCommand())

    let helpCommand = HelpCommand(registry: registry)
    registry.register(helpCommand)

    registry.main(defaultVerb: "help") { error in
        fputs("\(error)\n", stderr)
    }
}

dispatch_main()
