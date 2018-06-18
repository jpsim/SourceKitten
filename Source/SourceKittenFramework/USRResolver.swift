//
//  USRResolver.swift
//  SourceKittenFramework
//
//  Created by Leonardo Galli on 17.06.18.
//

import Foundation
import SQLite3
import CryptoSwift

class USRResolver {
    public static let shared = USRResolver()
    
    private let searchPaths : [String]
    
    private var db: OpaquePointer? = nil
    
    private let documentationURL = "https://developer.apple.com/documentation/"
    
    private var usrCache : [String : String] = [:]
    
    private var codeUsrCache : [String : String] = [:]
    
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
        print("Loading map.db from \(path)")
        if sqlite3_open(path, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(path)")
        } else {
            print("Unable to open documentation database.")
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
        guard let hash = usr.bytes.sha1().toBase64() else { return nil }
        
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
                print("Query returned no results")
            }
        } else {
            print("SELECT statement could not be prepared")
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
