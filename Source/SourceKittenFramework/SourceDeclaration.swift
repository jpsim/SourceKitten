//
//  SourceDeclaration.swift
//  SourceKitten
//
//  Created by JP Simard on 7/15/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

#if SWIFT_PACKAGE
import Clang_C
#endif
import Foundation

public func insertMarks(declarations: [SourceDeclaration], limit: NSRange? = nil) -> [SourceDeclaration] {
    guard declarations.count > 0 else { return [] }
    guard let path = declarations.first?.location.file, let file = File(path: path) else {
        fatalError("can't extract marks without a file.")
    }
    let currentMarks = file.contents.pragmaMarks(filename: path, excludeRanges: declarations.map({
        file.contents.byteRangeToNSRange(start: $0.range.location, length: $0.range.length) ?? NSRange()
    }), limit: limit)
    let newDeclarations: [SourceDeclaration] = declarations.map { declaration in
        var varDeclaration = declaration
        let range = file.contents.byteRangeToNSRange(start: declaration.range.location, length: declaration.range.length)
        varDeclaration.children = insertMarks(declarations: declaration.children, limit: range)
        return varDeclaration
    }
    return (newDeclarations + currentMarks).sorted()
}

/// Represents a source code declaration.
public struct SourceDeclaration {
    let type: ObjCDeclarationKind
    let location: SourceLocation
    let extent: (start: SourceLocation, end: SourceLocation)
    let name: String?
    let usr: String?
    let declaration: String?
    let documentation: Documentation?
    let commentBody: String?
    var children: [SourceDeclaration]
    let swiftDeclaration: String?
    let availability: ClangAvailability?

    /// Range
    var range: NSRange {
        return extent.start.range(toEnd: extent.end)
    }

    /// Returns the USR for the auto-generated getter for this property.
    ///
    /// - warning: can only be invoked if `type == .Property`.
    var getterUSR: String {
        return accessorUSR(getter: true)
    }

    /// Returns the USR for the auto-generated setter for this property.
    ///
    /// - warning: can only be invoked if `type == .Property`.
    var setterUSR: String {
        return accessorUSR(getter: false)
    }

    private func accessorUSR(getter: Bool) -> String {
        assert(type == .property)
        guard let usr = usr else {
            fatalError("Couldn't extract USR")
        }
        guard let declaration = declaration else {
            fatalError("Couldn't extract declaration")
        }
        let pyStartIndex = usr.range(of: "(py)")!.lowerBound
        let usrPrefix = usr.substring(to: pyStartIndex)
        let fullDeclarationRange = NSRange(location: 0, length: (declaration as NSString).length)
        let regex = try! NSRegularExpression(pattern: getter ? "getter\\s*=\\s*(\\w+)" : "setter\\s*=\\s*(\\w+:)", options: [])
        let matches = regex.matches(in: declaration, options: [], range: fullDeclarationRange)
        if matches.count > 0 {
            let accessorName = (declaration as NSString).substring(with: matches[0].rangeAt(1))
            return usrPrefix + "(im)\(accessorName)"
        } else if getter {
            return usr.replacingOccurrences(of: "(py)", with: "(im)")
        }
        // Setter
        let capitalFirstLetter = String(usr.characters[usr.characters.index(pyStartIndex, offsetBy: 4)]).capitalized
        let restOfSetterName = usr.substring(from: usr.characters.index(pyStartIndex, offsetBy: 5))
        return "\(usrPrefix)(im)set\(capitalFirstLetter)\(restOfSetterName):"
    }
}

extension SourceDeclaration {
    init?(cursor: CXCursor, compilerArguments: [String]) {
        guard cursor.shouldDocument() else {
            return nil
        }
        type = cursor.objCKind()
        location = cursor.location()
        extent = cursor.extent()
        name = cursor.name()
        usr = cursor.usr()
        declaration = cursor.declaration()
        documentation = Documentation(comment: cursor.parsedComment())
        commentBody = cursor.commentBody()
        children = cursor.flatMap({
            SourceDeclaration(cursor: $0, compilerArguments: compilerArguments)
        }).rejectPropertyMethods()
        swiftDeclaration = cursor.swiftDeclaration(compilerArguments: compilerArguments)
        availability = cursor.platformAvailability()
    }
}

extension Sequence where Iterator.Element == SourceDeclaration {
    /// Removes implicitly generated property getters & setters
    func rejectPropertyMethods() -> [SourceDeclaration] {
        let propertyGetterSetterUSRs = filter {
            $0.type == .property
        }.flatMap {
            [$0.getterUSR, $0.setterUSR]
        }
        return filter { !propertyGetterSetterUSRs.contains($0.usr!) }
    }
}

extension SourceDeclaration: Hashable {
    public var hashValue: Int {
        return usr?.hashValue ?? 0
    }
}

public func ==(lhs: SourceDeclaration, rhs: SourceDeclaration) -> Bool {
    return lhs.usr == rhs.usr &&
        lhs.location == rhs.location
}

// MARK: Comparable

extension SourceDeclaration: Comparable {}

/// A [strict total order](http://en.wikipedia.org/wiki/Total_order#Strict_total_order)
/// over instances of `Self`.
public func <(lhs: SourceDeclaration, rhs: SourceDeclaration) -> Bool {
    return lhs.location < rhs.location
}

// MARK: - migration support
@available(*, unavailable, renamed: "insertMarks(declarations:limit:)")
public func insertMarks(_ declarations: [SourceDeclaration], limitRange: NSRange? = nil) -> [SourceDeclaration] {
    fatalError()
}
