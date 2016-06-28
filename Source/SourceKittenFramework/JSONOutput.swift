//
//  JSONOutput.swift
//  SourceKitten
//
//  Created by Thomas Goyne on 9/17/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

import Foundation

/**
 JSON Object to JSON String.

 - parameter object: Object to convert to JSON.

 - returns: JSON string representation of the input object.
 */
public func toJSON(_ object: AnyObject) -> String {
    do {
        let prettyJSONData = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
        if let jsonString = NSString(data: prettyJSONData, encoding: String.Encoding.utf8.rawValue) as? String {
            return jsonString
        }
    } catch {}
    return ""
}

/**
 Convert [String: SourceKitRepresentable] to `[String: AnyObject]`.

 - parameter dictionary: [String: SourceKitRepresentable] to convert.

 - returns: JSON-serializable Dictionary.
 */
public func toAnyObject(_ dictionary: [String: SourceKitRepresentable]) -> [String: AnyObject] {
    var anyDictionary = [String: AnyObject]()
    for (key, object) in dictionary {
        switch object {
        case let object as AnyObject:
            anyDictionary[key] = object
        case let object as [SourceKitRepresentable]:
            anyDictionary[key] = object.map { toAnyObject($0 as! [String: SourceKitRepresentable]) }
        case let object as [[String: SourceKitRepresentable]]:
            anyDictionary[key] = object.map { toAnyObject($0) }
        case let object as [String: SourceKitRepresentable]:
            anyDictionary[key] = toAnyObject(object)
        case let object as String:
            anyDictionary[key] = object
        case let object as Int64:
            anyDictionary[key] = NSNumber(value: object)
        case let object as Bool:
            anyDictionary[key] = NSNumber(value: object)
        default:
            fatalError("Should never happen because we've checked all SourceKitRepresentable types")
        }
    }
    return anyDictionary
}
