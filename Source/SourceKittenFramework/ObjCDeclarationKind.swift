//
//  ObjCDeclarationKind.swift
//  SourceKitten
//
//  Created by JP Simard on 7/15/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

/**
Objective-C declaration kinds.
More or less equivalent to `SwiftDeclarationKind`, but with made up values because there's no such
thing as SourceKit for Objective-C.
*/
public enum ObjCDeclarationKind: String {
    /// `category`.
    case Category = "sourcekitten.source.lang.objc.decl.category"
    /// `class`.
    case Class = "sourcekitten.source.lang.objc.decl.class"
    /// `enum`.
    case Enum = "sourcekitten.source.lang.objc.decl.enum"
    /// `enumcase`.
    case Enumcase = "sourcekitten.source.lang.objc.decl.enumcase"
    /// `initializer`.
    case Initializer = "sourcekitten.source.lang.objc.decl.initializer"
    /// `method.class`.
    case MethodClass = "sourcekitten.source.lang.objc.decl.method.class"
    /// `method.instance`.
    case MethodInstance = "sourcekitten.source.lang.objc.decl.method.instance"
    /// `property`.
    case Property = "sourcekitten.source.lang.objc.decl.property"
    /// `protocol`.
    case Protocol = "sourcekitten.source.lang.objc.decl.protocol"
    /// `typedef`.
    case Typedef = "sourcekitten.source.lang.objc.decl.typedef"

    public static func fromUSR(usr: String, declaration: String? = nil) -> ObjCDeclarationKind? {
        let patterns: [ObjCDeclarationKind: String] = [
            .Category: "<TODO>",
            .Class: "^c:objc\\(cs\\)\\w+$",
            .Enum: "<same as typedef so override later>",
            .Enumcase: "^c:@E",
            .Initializer: "^c:objc\\(cs\\)\\w+\\(im\\)init",
            .MethodClass: "^c:objc\\((cs|pl)\\)\\w+\\(cm\\)\\w+",
            .MethodInstance: "^c:objc\\((cs|pl)\\)\\w+\\(im\\)\\w+",
            .Property: "^c:objc\\((cs|pl)\\)\\w+\\(py\\)\\w+",
            .Protocol: "<TODO>",
            .Typedef: "^c:.+@T@"
        ]
        for pattern in patterns {
            let regex = try! NSRegularExpression(pattern: pattern.1, options: [])
            if regex.matchesInString(usr, options: [], range: NSMakeRange(0, usr.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))).count > 0 {
                if let declaration = declaration where pattern.0 == .Typedef &&
                    declaration.rangeOfString("typedef enum")?.startIndex == declaration.startIndex {
                        return .Enum
                }
                return pattern.0
            }
        }
        return nil
    }
}
