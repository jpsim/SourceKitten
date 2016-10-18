//
//  VariantPerformanceTests.swift
//  SourceKitten
//
//  Created by 野村 憲男 on 10/17/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import XCTest
@testable import SourceKittenFramework
let srcURL = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()

let largestSwiftFileInRepoURL = srcURL
    .appendingPathComponent("Source/SourceKittenFramework/String+SourceKitten.swift")

let largestSwiftFile = File(path: largestSwiftFileInRepoURL.path)!

let thisFile = URL(fileURLWithPath: #file).path

class PerformanceTests: XCTestCase {

    func testEditorOpenJSON1() {
            let dictionary = try? Request.editorOpen(file: largestSwiftFile).failableSend()
            if let jsonString = dictionary.map(toNSDictionary).map(toJSON) {
                try? jsonString.write(to: srcURL.appendingPathComponent("testEditorOpenJSON1.json"),
                                      atomically: true,
                                      encoding: .utf8)
            }
    }

    func testEditorOpenJSON2() {
            let variant = try? Request.editorOpen(file: largestSwiftFile).failableSend2()
            if let jsonString = variant?.any.map(toJSON) {
                try? jsonString.write(to: srcURL.appendingPathComponent("testEditorOpenJSON2.json"),
                                      atomically: true,
                                      encoding: .utf8)
            }
    }

    func testIndexJSON1() {
            let arguments = ["-sdk", sdkPath(), "-j4", thisFile ]
            let dictionary = try? Request.index(file: thisFile, arguments: arguments).failableSend()
            if let jsonString = dictionary.map(toNSDictionary).map(toJSON) {
                try? jsonString.write(to: srcURL.appendingPathComponent("testIndexJSON1.json"),
                                      atomically: true,
                                      encoding: .utf8)
            }
    }

    func testIndexJSON2() {
            let arguments = ["-sdk", sdkPath(), "-j4", thisFile ]
            let variant = try? Request.index(file: thisFile, arguments: arguments).failableSend2()
            if let jsonString = variant?.any.map(toJSON) {
                try? jsonString.write(to: srcURL.appendingPathComponent("testIndexJSON2.json"),
                                      atomically: true,
                                      encoding: .utf8)
            }
    }


    func testPerformanceJSON1() {
        self.measure {
            let dictionary = try? Request.editorOpen(file: largestSwiftFile).failableSend()
            for _ in 1...10 {
                _ = dictionary.map(toNSDictionary).map(toJSON)
            }
        }
    }

    func testPerformanceJSON2() {
        self.measure {
            let variant = try? Request.editorOpen(file: largestSwiftFile).failableSend2()
            for _ in 1...10 {
                _ = variant?.any.map(toJSON)
            }
        }
    }

    func testPerformanceWalking1() {
        self.measure {
            let dictionary = try? Request.editorOpen(file: largestSwiftFile).failableSend()
            for _ in 1...100 {
                walk1(dictionay: dictionary!)
            }
        }
    }

    func testPerformanceWalking2() {
        self.measure {
            let dictionary = try? Request.editorOpen(file: largestSwiftFile).failableSend2()
            for _ in 1...100 {
                walk2(variant: dictionary!)
            }
        }
    }

    func testPerformanceWalkingAfterOnceWalked1() {
        let dictionary = try? Request.editorOpen(file: largestSwiftFile).failableSend()
        walk1(dictionay: dictionary!)
        self.measure {
            for _ in 1...100 {
                walk1(dictionay: dictionary!)
            }
        }
    }

    func testPerformanceWalkingAfterOnceWalked2() {
        let dictionary = try? Request.editorOpen(file: largestSwiftFile).failableSend2()
        walk2(variant: dictionary!)
        self.measure {
            for _ in 1...100 {
                walk2(variant: dictionary!)
            }
        }
    }
}


func walk1(dictionay: [String: SourceKitRepresentable]) {
    if let _ = dictionay[SwiftDocKey.name.rawValue] as? String {
    }
    if let _ = dictionay[SwiftDocKey.kind.rawValue] as? String {
    }
    if let _ = (dictionay[SwiftDocKey.offset.rawValue] as? Int64).map({Int($0)}) {
    }
    if let _ = (dictionay[SwiftDocKey.length.rawValue] as? Int64).map({Int($0)}) {
    }
    guard let substructures = dictionay[SwiftDocKey.substructure.rawValue] as? [SourceKitRepresentable] else { return }
    for substructure in substructures {
        if let substructure = substructure as? [String: SourceKitRepresentable] {
            walk1(dictionay: substructure)
        }
    }
}

func walk2(variant: SourceKitVariant) {
    if let _ = variant[.name]?.string {
    }
    if let _ = variant[.kind]?.string {
    }
    if let _ = variant[.offset]?.int {
    }
    if let _ = variant[.length]?.int {
    }
    guard let substructures = variant[.substructure]?.array else { return }
    for substructure in substructures {
        walk2(variant: substructure)
    }
}
