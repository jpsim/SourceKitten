//
//  LinuxCompatibility.swift
//  SourceKitten
//
//  Created by JP Simard on 8/19/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import Foundation

#if os(Linux)
public typealias Process = Task
public typealias NSRegularExpression = RegularExpression

extension TextCheckingResult {
    public func rangeAt(_ index: Int) -> NSRange {
        return range(at: index)
    }
}
extension NSString {
    var isAbsolutePath: Bool { return absolutePath }
}
#else
extension Dictionary {
    public func bridge() -> NSDictionary {
        return self as NSDictionary
    }
}
extension Array {
    public func bridge() -> NSArray {
        return self as NSArray
    }
}
extension String {
    public func bridge() -> NSString {
        return self as NSString
    }
}
extension NSString {
    public func bridge() -> String {
        return self as String
    }
}
#endif
