//
//  ObjCDeclaration.swift
//  SourceKitten
//
//  Created by Paul Young on 12/4/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

import Foundation

public struct ObjCDeclaration: DeclarationType {
    public let language: Language = .Swift
    public let kind: ObjCDeclarationKind? // FIXME: Type 'ObjCDeclaration' does not conform to protocol 'DeclarationType'
    public let location: SourceLocation
    public let extent: (start: SourceLocation, end: SourceLocation)
    public let name: String?
    public let typeName: String?
    public let usr: String?
    public let declaration: String?
    public let documentationComment: String?
    public let children: [DeclarationType]
    
    /// Returns the USR for the auto-generated getter for this property.
    ///
    /// - warning: can only be invoked if `type == .Property`.
    var getterUSR: String {
        return generateAccessorUSR(getter: true)
    }
    
    /// Returns the USR for the auto-generated setter for this property.
    ///
    /// - warning: can only be invoked if `type == .Property`.
    var setterUSR: String {
        return generateAccessorUSR(getter: false)
    }
    
    private func generateAccessorUSR(getter getter: Bool) -> String {
        assert(kind == .Property)
        guard let usr = usr else {
            fatalError("Couldn't extract USR")
        }
        guard let declaration = declaration else {
            fatalError("Couldn't extract declaration")
        }
        let pyStartIndex = usr.rangeOfString("(py)")!.startIndex
        let usrPrefix = usr.substringToIndex(pyStartIndex)
        let fullDeclarationRange = NSRange(location: 0, length: (declaration as NSString).length)
        let regex = try! NSRegularExpression(pattern: getter ? "getter\\s*=\\s*(\\w+)" : "setter\\s*=\\s*(\\w+:)", options: [])
        let matches = regex.matchesInString(declaration, options: [], range: fullDeclarationRange)
        if matches.count > 0 {
            let accessorName = (declaration as NSString).substringWithRange(matches[0].rangeAtIndex(1))
            return usrPrefix + "(im)\(accessorName)"
        } else if getter {
            return usr.stringByReplacingOccurrencesOfString("(py)", withString: "(im)")
        }
        // Setter
        let capitalFirstLetter = String(usr.characters[pyStartIndex.advancedBy(4)]).capitalizedString
        let restOfSetterName = usr.substringFromIndex(pyStartIndex.advancedBy(5))
        return "\(usrPrefix)(im)set\(capitalFirstLetter)\(restOfSetterName):"
    }
}

extension ObjCDeclaration {
    public init?(cursor: CXCursor) {
        guard cursor.shouldDocument() else {
            return nil
        }
        kind = cursor.objCKind()
        extent = cursor.extent()
        name = cursor.name()
        //typeName = cursor. // FIXME: no cursor.typeName()
        usr = cursor.usr()
        declaration = cursor.declaration()
        documentationComment = cursor.parsedComment() // FIXME: Cannot assign value of type 'CXComment' to type 'String?'
        children = cursor.flatMap(ObjCDeclaration.init).rejectPropertyMethods() // FIXME: Cannot assign value of type '[ObjCDeclaration]' to type '[DeclarationType]'
    }
}

extension SequenceType where Generator.Element == ObjCDeclaration {
    /// Removes implicitly generated property getters & setters
    func rejectPropertyMethods() -> [ObjCDeclaration] {
        let propertyGetterSetterUSRs = filter {
            $0.kind == .Property
        }.flatMap {
            [$0.getterUSR, $0.setterUSR]
        }
        return filter { !propertyGetterSetterUSRs.contains($0.usr!) }
    }
}

// MARK: Hashable

extension ObjCDeclaration: Hashable  {
    public var hashValue: Int {
        return usr?.hashValue ?? 0
    }
}

public func ==(lhs: ObjCDeclaration, rhs: ObjCDeclaration) -> Bool {
    return lhs.usr == rhs.usr &&
        lhs.location == rhs.location
}

// MARK: Comparable

/// A [strict total order](http://en.wikipedia.org/wiki/Total_order#Strict_total_order)
/// over instances of `Self`.
public func <(lhs: ObjCDeclaration, rhs: ObjCDeclaration) -> Bool {
    return lhs.location < rhs.location
}
