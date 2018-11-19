//
//  LinuxCompatibility.swift
//  SourceKitten
//
//  Created by JP Simard on 8/19/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import Foundation

extension Array {
    public func bridge() -> NSArray {
#if _runtime(_ObjC) || swift(>=4.1.50)
        return self as NSArray
#else
        return NSArray(array: self)
#endif
    }
}

extension CharacterSet {
    public func bridge() -> NSCharacterSet {
#if _runtime(_ObjC) || swift(>=4.1.50)
        return self as NSCharacterSet
#else
        return _bridgeToObjectiveC()
#endif
    }
}

extension Dictionary {
    public func bridge() -> NSDictionary {
#if _runtime(_ObjC) || swift(>=4.1.50)
        return self as NSDictionary
#else
        return NSDictionary(dictionary: self)
#endif
    }
}

extension NSString {
    public func bridge() -> String {
#if _runtime(_ObjC) || swift(>=4.1.50)
        return self as String
#else
        return _bridgeToSwift()
#endif
    }
}

extension String {
    public func bridge() -> NSString {
#if _runtime(_ObjC) || swift(>=4.1.50)
        return self as NSString
#else
        return NSString(string: self)
#endif
    }
}
