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
    
    public func resolveUSR(code: String, compilerArgs: [String]? = nil) -> String? {
        if let cached = self.codeUsrCache[code] {
            return cached
        }
        
        if let compilerArgs = compilerArgs {
            if let usr = self.findUsingCursorInfo(code: code, compilerArgs: compilerArgs) {
                self.codeUsrCache[code] = usr
                return usr
            }
        }
        
        if let usr = self.findUsingDotNotation(code: code) {
            self.codeUsrCache[code] = usr
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
    
    public func findUsingDotNotation(code: String) -> String? {
        let parts = code.split(regex: "(?<!\\.)\\.(?!\\.)")
        return self.findUsingDotNotation(parts: parts, index: Array(self.index.values))
    }
    
    internal func findUsingDotNotation(parts: [String], index: [NameEntity]) -> String? {
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
            return entities.first?.usr
        }
        
        if entities.count > 0 {
            let children = entities.flatMap { (ent) -> [NameEntity] in
                ent.children.map({ (usr) -> NameEntity in
                    return self.index[usr]!
                })
            }
            
            return self.findUsingDotNotation(parts: Array(nextParts), index: children)
        }
        
        return nil
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
