//
//  MarkdownFile.swift
//  sourcekitten
//
//  Created by Eneko Alonso on 10/2/17.
//

import Foundation

struct MarkdownFile {
    let filename: String
    let content: [MarkdownConvertible]

    func write(basePath: String) throws {
        try makePath(basePath: basePath)
        let output = content.output
        let filepath = "\(basePath)/\(filename).md"
        print("Writting documentation file: \(filepath)")
        try output.write(toFile: filepath, atomically: true, encoding: .utf8)
    }

    private func makePath(basePath: String) throws {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: basePath, isDirectory: &isDir) == false {
            try FileManager.default.createDirectory(atPath: basePath, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
