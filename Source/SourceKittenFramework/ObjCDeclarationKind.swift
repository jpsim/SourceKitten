//
//  ObjCDeclarationKind.swift
//  SourceKitten
//
//  Created by JP Simard on 7/15/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

#if SWIFT_PACKAGE
import Clang_C
#endif

/**
Objective-C declaration kinds.
More or less equivalent to `SwiftDeclarationKind`, but with made up values because there's no such
thing as SourceKit for Objective-C.
*/
public enum ObjCDeclarationKind: String {
    /// `category`.
    case category = "sourcekitten.source.lang.objc.decl.category"
    /// `class`.
    case `class` = "sourcekitten.source.lang.objc.decl.class"
    /// `constant`.
    case constant = "sourcekitten.source.lang.objc.decl.constant"
    /// `enum`.
    case `enum` = "sourcekitten.source.lang.objc.decl.enum"
    /// `enumcase`.
    case enumcase = "sourcekitten.source.lang.objc.decl.enumcase"
    /// `initializer`.
    case initializer = "sourcekitten.source.lang.objc.decl.initializer"
    /// `method.class`.
    case methodClass = "sourcekitten.source.lang.objc.decl.method.class"
    /// `method.instance`.
    case methodInstance = "sourcekitten.source.lang.objc.decl.method.instance"
    /// `property`.
    case property = "sourcekitten.source.lang.objc.decl.property"
    /// `protocol`.
    case `protocol` = "sourcekitten.source.lang.objc.decl.protocol"
    /// `typedef`.
    case typedef = "sourcekitten.source.lang.objc.decl.typedef"
    /// `function`.
    case function = "sourcekitten.source.lang.objc.decl.function"
    /// `mark`.
    case mark = "sourcekitten.source.lang.objc.mark"
    /// `struct`
    case `struct` = "sourcekitten.source.lang.objc.decl.struct"
    /// `field`
    case field = "sourcekitten.source.lang.objc.decl.field"
    /// `ivar`
    case ivar = "sourcekitten.source.lang.objc.decl.ivar"
    /// `ModuleImport`
    case moduleImport = "sourcekitten.source.lang.objc.module.import"
    /// `UnexposedDecl`
    case unexposedDecl = "sourcekitten.source.lang.objc.decl.unexposed"

    public static func fromClang(_ kind: CXCursorKind) -> ObjCDeclarationKind {
        switch kind.rawValue {
        case CXCursor_ObjCCategoryDecl.rawValue: return .category
        case CXCursor_ObjCInterfaceDecl.rawValue: return .class
        case CXCursor_EnumDecl.rawValue: return .enum
        case CXCursor_EnumConstantDecl.rawValue: return .enumcase
        case CXCursor_ObjCClassMethodDecl.rawValue: return .methodClass
        case CXCursor_ObjCInstanceMethodDecl.rawValue: return .methodInstance
        case CXCursor_ObjCPropertyDecl.rawValue: return .property
        case CXCursor_ObjCProtocolDecl.rawValue: return .protocol
        case CXCursor_TypedefDecl.rawValue: return .typedef
        case CXCursor_VarDecl.rawValue: return .constant
        case CXCursor_FunctionDecl.rawValue: return .function
        case CXCursor_StructDecl.rawValue: return .struct
        case CXCursor_FieldDecl.rawValue: return .field
        case CXCursor_ObjCIvarDecl.rawValue: return .ivar
        case CXCursor_ModuleImportDecl.rawValue: return .moduleImport
        case CXCursor_UnexposedDecl.rawValue: return .unexposedDecl
        default: fatalError("Unsupported CXCursorKind: \(clang_getCursorKindSpelling(kind))")
        }
    }
}
