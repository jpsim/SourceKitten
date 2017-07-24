//
//  main.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation
import SourceKittenFramework

let contents = try! String(contentsOfFile: ProcessInfo.processInfo.arguments[1], encoding: .utf8)

func convert(_ obj: Any) -> SourceKitRepresentable? {
    if let theObj = obj as? String {
        return theObj
    } else if let theObj = obj as? Bool {
        return theObj
    } else if let theObj = obj as? [String: Any] {
        var newDict = [String: SourceKitRepresentable]()
        for (key, value) in theObj {
            if let skValue = value as? SourceKitRepresentable {
                newDict[key] = skValue
            } else if let skValue = convert(value) {
                newDict[key] = skValue
            }
        }
        return newDict
    } else if let theObj = obj as? [Any] {
        return theObj.flatMap { elem -> SourceKitRepresentable? in
            if let elem = elem as? SourceKitRepresentable {
                return elem
            } else if let elem = convert(elem) {
                return elem
            }
            return nil
        }
    } else {
        fatalError("")
    }
}

let scanner = Scanner(string: contents)
while !scanner.isAtEnd {
    scanner.scanUpTo("SourceKit-client: [2:request", into: nil)
    scanner.scanUpTo("{\n", into: nil)
    var fullRequestString: NSString?
    scanner.scanUpTo("\n2017", into: &fullRequestString)
    if let fullRequestString = fullRequestString as String? {
        let keyRegex = try! NSRegularExpression(pattern: "  (key[\\.\\w\\-]+)")
        var json = keyRegex.stringByReplacingMatches(in: fullRequestString, options: [],
                                                     range: NSRange(location: 0, length: (fullRequestString as NSString).length),
                                                     withTemplate: "  \"$1\"")

        let sourceRegex = try! NSRegularExpression(pattern: "(source\\.[\\.\\w\\-:]+)")
        json = sourceRegex.stringByReplacingMatches(in: json as String, options: [],
                                                    range: NSRange(location: 0, length: (json as NSString).length),
                                                    withTemplate: "\"$1\"")

        if let jsonObject = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!) as? NSDictionary {
            let valid = jsonObject.allKeys.contains(where: { key -> Bool in
                return (key as? String == "key.sourcetext") || (key as? String == "key.sourcefile")
            })
            if valid && jsonObject["key.request"] as? String != "source.request.indexer.srv.main-files-for-file" {
                print("sending request type \(jsonObject["key.request"] as! String)")
//                print("sending request:\n\(json)")
                let result = Request.customRequest(request: toSourceKit(convert(jsonObject)!)!).send()
                if result["key.diagnostic_stage"] as? String == "source.diagnostic.stage.swift.sema" {
                    print(toJSON(result["key.annotations"]!))
                    exit(0)
                }
                RunLoop.current.run(until: Date().addingTimeInterval(1))
            }
        } else {
            fatalError("couldn't parse: \(json)")
        }
    }
}
