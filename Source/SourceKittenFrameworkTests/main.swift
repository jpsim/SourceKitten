//
//  main.swift
//  sourcekitten
//
//  Created by 野村 憲男 on 2/3/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import XCTest

XCTMain([
    ClangTranslationUnitTests(),
    CodeCompletionTests(),
    FileTests(),
    ModuleTests(),
    OffsetMapTests(),
    SourceKitTests(),
    StringTests(),
    StructureTests(),
    SwiftDocsTests(),
    SyntaxTests(),
    ])
