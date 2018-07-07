//
//  USRResolver.swift
//  SourceKittenFramework
//
//  Created by Leonardo Galli on 17.06.18.
//

import Foundation
import CSQLite

class USRResolver {
    public static let shared = USRResolver()
    
    private let searchPaths : [String]
    
    private var db: OpaquePointer? = nil
    
    private let documentationURL = "https://developer.apple.com/documentation/"
    
    private var usrCache : [String : String] = [:]
    
    private var codeUsrCache : [String : String] = [:]
    
    private var index: [String: NameEntity] = [:]
    
    private init() {
        self.searchPaths = [
            xcodeDefaultToolchainOverride,
            toolchainDir,
            xcrunFindPath,
            /*
             These search paths are used when `xcode-select -p` points to
             "Command Line Tools OS X for Xcode", but Xcode.app exists.
             */
            applicationsDir?.xcodeDeveloperDir.toolchainDir,
            applicationsDir?.xcodeBetaDeveloperDir.toolchainDir,
            userApplicationsDir?.xcodeDeveloperDir.toolchainDir,
            userApplicationsDir?.xcodeBetaDeveloperDir.toolchainDir
        ].compactMap { path in
            if let fullPath = path?.deleting(lastPathComponents: 3).appending(pathComponent: "SharedFrameworks/DNTDocumentationSupport.framework/Resources/external/map.db"), fullPath.isFile {
                return fullPath
            }
            return nil
        }
        
        self.loadDatabase()
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    private func loadDatabase() {
        guard let path = self.searchPaths.first else { return }
        //print("Loading map.db from \(path)")
        if sqlite3_open(path, &db) == SQLITE_OK {
            //print("Successfully opened connection to database at \(path)")
        } else {
            //print("Unable to open documentation database.")
        }
    }
    
    /// Find a usr that best matches a given code snippet and the current context.
    /// The code snipped and either be full on compilable swift code (`compilerArgs` are required)
    /// or just a representation of the hirarchy, called "dot notation" (e.g. `Class.function`).
    /// For a more indepth overview of "dot notation", see `findUsingDotNotation`.
    ///
    /// - Parameters:
    ///   - code: Either a swift code snippet or "dot notation".
    ///   - context: The context where the code snippet was mentioned. Since this is usually a doc comment, it will include the usr of the doc comment location, the parent usr and all children.
    ///   - compilerArgs: The args for compiling the code snippet (only useful if it's actual swift code).
    /// - Returns: Returns a usr when found.
    public func resolveUSR(code: String, context: NameEntity, compilerArgs: [String]? = nil) -> String? {
        let cacheKey = code + context.usr + (context.parentUSR ?? "")
        if let cached = self.codeUsrCache[cacheKey] {
            return cached
        }
        
        if let compilerArgs = compilerArgs {
            if let usr = self.findUsingCursorInfo(code: code, compilerArgs: compilerArgs) {
                self.codeUsrCache[cacheKey] = usr
                return usr
            }
        }
        
        if let usr = self.findUsingDotNotation(code: code, context: context) {
            self.codeUsrCache[cacheKey] = usr
            return usr
        }
        
        return nil
    }
    
    public func findUsingCursorInfo(code: String, compilerArgs: [String]) -> String? {
        var compilerArgs = compilerArgs
        let tempPath = NSTemporaryDirectory().appending(pathComponent: "temp.swift")
        if tempPath.isFile {
            try? FileManager.default.removeItem(atPath: tempPath)
        }
        try? code.write(toFile: tempPath, atomically: true, encoding: String.Encoding.utf8)
        compilerArgs.append(tempPath)
        let requestObj = ["key.request": UID("source.request.cursorinfo"), "key.compilerargs" : compilerArgs, "key.sourcefile": tempPath, "key.offset": code.lengthOfBytes(using: .utf8) - 2] as SourceKitObject
        let request = Request.customRequest(request: requestObj)
        
        do {
            let response = try request.send()
            return response[SwiftDocKey.usr.rawValue] as? String
        } catch {
            print("Error: \(error)")
        }
        
        return nil
    }
    
    public func findUsingDotNotation(code: String, context: NameEntity) -> String? {
        let parts = code.split(regex: "(?<!\\.)\\.(?!\\.)")
        let entities = self.findUsingDotNotation(parts: parts, index: Array(self.index.values))
        
        if entities.count > 0 {
            if entities.count == 1 {
                return entities.first?.usr
            }
            
            // first let's filter by size and take the smallest.
            let withSize = entities.map { (ent) -> (NameEntity, Int) in
                return (ent, ent.name.count)
                }.sorted { (a, b) -> Bool in
                    a.1 < b.1
            }
            
            let smallest = withSize.first!
            let allSmall = withSize.filter { (ent) -> Bool in
                ent.1 == smallest.1
            }
            
            if allSmall.count == 1 {
                return smallest.0.usr
            }
            
            //If we have multiple entities with the same name, we need to look at the context!
            let withScore = allSmall.map { (arg) -> (NameEntity, Int) in
                let (ent, _) = arg
                //We swap the entity and context and score them again, since context could also be a child of the entity.
                return (ent, score(ent: ent, context: context) + score(ent: context, context: ent))
                }.sorted { (a, b) -> Bool in
                    a.1 > b.1
            }
            let highest = withScore.first!
            let allHighest = withScore.filter { (ent) -> Bool in
                ent.1 == highest.1
            }
            
            if allHighest.count > 1 {
                let joined = allHighest.map { (ent) -> String in
                    return ent.0.name
                }.joined(separator: ", ")
                //print("WARNING: Could not uniquely resolve \(code). Found posibilities: \(joined).", stderr)
            }
            
            return allHighest.first?.0.usr
        }
        
        return nil
    }
    
    /// Creates a score indicating how likely it is, that we have the correct match for a given context.
    /// See `resolveUSR(...)` for what is meant by context.
    ///
    /// - Parameters:
    ///   - ent: The entity to score.
    ///   - context: See `resolveUSR(...)` for what is meant by context.
    /// - Returns: A score indicating how likely the given entity `ent` is to be the one we want inside `context`.
    private func score(ent: NameEntity, context: NameEntity) -> Int {
        var score = 0
        //If the parent is the same, this is very likely to be correct. However, could still be off, so we use more mesures
        if ent.parentUSR == context.parentUSR {
            score += 100
        }
        //We might be on a doc comment on a parent (e.g. class doc comment), so the parent is actually the current context.
        if ent.parentUSR == context.usr {
            score += 75
        }
        
        for child in ent.children {
            // We increase the score for any same children, as that further increases the chances of the correct match.
            if context.children.contains(child) {
                score += 10
            }
            //The entity we found, might be a parent of a parent.
            if context.parentUSR == child {
                score += 25
            }
        }
        
        return score
    }
    
    internal func findUsingDotNotation(parts: [String], index: [NameEntity]) -> [NameEntity] {
        var current = parts.first
        current = NSRegularExpression.escapedPattern(for: current ?? "")
        current = current?.replacingOccurrences(of: "\\.\\.\\.", with: "[^)]*")
        current = current?.replacingOccurrences(of: "_:", with: "[^:]*:")
        //print(current)
        let nextParts = parts.dropFirst()
        let entities = index.filter { (ent) -> Bool in
            return ent.name.range(of: current ?? "", options: .regularExpression, range: nil, locale: nil) != nil
        }
        
        if nextParts.count == 0 {
            if entities.count > 1 {
                //print("WARNING: Found multiple entities for \(current).")
            }
            return entities
        }
        
        if entities.count > 0 {
            let children = entities.flatMap { (ent) -> [NameEntity] in
                ent.children.map({ (usr) -> NameEntity in
                    return self.index[usr]!
                })
            }
            
            return self.findUsingDotNotation(parts: Array(nextParts), index: children)
        }
        
        return []
    }
    
    public func register(docs: [String: SourceKitRepresentable], parentUSR : String? = nil) {
        var children : [String] = []
        // This is the usr of the current structure, being the parent of it's substructures.
        let parent = docs[SwiftDocKey.usr.rawValue] as? String
        if let substructures = SwiftDocKey.getSubstructure(docs) {
            for substructure in substructures {
                self.register(docs: substructure, parentUSR: parent)
            }
            
            children = self.getChildUSRs(substructures: substructures)
        }
        
        if let name = SwiftDocKey.getName(docs) {
            //This is actually an entity and not something top level!
            guard let kind = SwiftDeclarationKind(rawValue: SwiftDocKey.getKind(docs) ?? ""), let usr = docs[SwiftDocKey.usr.rawValue] as? String else {
                return
            }
            
            let entity = NameEntity(usr: usr, name: name, children: children, parentUSR: parentUSR, kind: kind)
            self.index[usr] = entity
        }
    }
    
    internal func getChildUSRs(substructures: [[String: SourceKitRepresentable]]) -> [String] {
        var children : [String] = []
        // We save the usrs of all substructures, so we can have a linked list.
        for substructure in substructures {
            if let usr = substructure[SwiftDocKey.usr.rawValue] as? String {
                children.append(usr)
            } else {
                // If the child does not have a usr, it might be nested, e.g. like an enum case statement.
                if let subsub = SwiftDocKey.getSubstructure(substructure) {
                    children.append(contentsOf: self.getChildUSRs(substructures: subsub))
                }
            }
        }
        
        return children
    }
    
    public func resolveExternalURL(usr: String, language: DocumentationSourceLanguage = DocumentationSourceLanguage.swift) -> String? {
        if let cached = self.usrCache[usr] {
            return cached
        }
        
        if let url = self.findInAppleDocs(usr: usr, language: language) {
            self.usrCache[usr] = url
            return url
        }
        
        return nil
    }
    
    public func findInAppleDocs(usr: String, language: DocumentationSourceLanguage = DocumentationSourceLanguage.swift) -> String? {
        guard var data = usr.data(using: .utf8), let hashBytes = SHA1.hash(from: &data) else { return nil }
        var hashData = Data.init(count: hashBytes.count*4)
        for (index, byte) in hashBytes.enumerated() {
            let bigEndian = byte.bigEndian
            for i in (0..<4) {
                hashData[index*4 + i] = UInt8(truncatingIfNeeded: bigEndian >> UInt8(i*8))
            }
        }
        //let hashData = hashBytes.withUnsafeBytes { Data(buffer: ($0.bindMemory(to: Int.self))) }
        let hash = hashData.base64EncodedString()
        
        // Foundation needs to be special so it has different base64 chars.
        let correctedHash = hash.replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_")
        
        // This part is stored in the map db.
        let uuid = correctedHash[correctedHash.startIndex..<correctedHash.index(correctedHash.startIndex, offsetBy: 8)]
        
        let sqliteQuery = "SELECT * FROM map WHERE uuid LIKE '%\(uuid)' AND source_language = \(language.rawValue)"
        
        let referencePath = self.queryAppleDocs(queryString: sqliteQuery)
        
        return referencePath != nil ? (self.documentationURL + referencePath!) : nil
    }
    
    public func queryAppleDocs(queryString: String) -> String? {
        guard let db = self.db else { return nil }
        
        var referencePath : String? = nil
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let referencePathCol = sqlite3_column_text(queryStatement, 4)
                referencePath = String(cString: referencePathCol!)
            } else {
                //print("Query returned no results")
            }
        } else {
            //print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        
        return referencePath
    }
}

public enum DocumentationSourceLanguage: Int {
    case swift
    case objc
    case javascript
    
    public var character: String {
        switch self {
        case .swift:
            return "s"
        case .objc:
            return "c"
        case .javascript:
            return "j"
        }
    }
}

public struct NameEntity: Codable {
    public let usr: String
    
    public let name: String
    
    public var children: [String] = []
    
    public var parentUSR: String? = nil
    
    public var kind: SwiftDeclarationKind
}

extension String {
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    func ranges(between string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(start..<range.lowerBound)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        if start < endIndex {
            result.append(start..<endIndex)
        }
        return result
    }
    
    func split(regex: String) -> [String] {
        return self.ranges(between: regex, options: .regularExpression).map { String(self[$0]) }
    }
}
