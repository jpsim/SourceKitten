//
//  XcodeBuildSetting.swift
//  SourceKittenFramework
//
//  Created by Chris Zielinski on 2/23/19.
//  Copyright © 2019 SourceKitten. All rights reserved.
//

@dynamicMemberLookup
struct XcodeBuildSetting: Codable {

    /// The build action.
    let action: String
    /// The build settings.
    ///
    /// - Important: The keys are camel cased (e.g. the build setting key `"PRODUCT_MODULE_NAME"`
    ///              is `"productModuleName"`).
    ///
    /// - Note: You can access the values using _dot_ syntax (e.g. `XcodeBuildSetting.platformName`
    ///         will return the value for the key `"PLATFORM_NAME"`).
    let buildSettings: [String: String]
    /// The target name.
    let target: String

    #if os(Linux) && !swift(>=4.2.1)
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        action = try container.decode(String.self, forKey: .action)

        var decodedKeybuildSettings: [String: String] = [:]
        try container.decode([String: String].self, forKey: .buildSettings).forEach { key, value in
            decodedKeybuildSettings[XcodeBuildSetting._convertFromSnakeCase(key)] = value
        }
        buildSettings = decodedKeybuildSettings

        target = try container.decode(String.self, forKey: .target)
    }
    #endif

    subscript(dynamicMember member: String) -> String? {
        return buildSettings[member]
    }

    #if os(Linux) && !swift(>=4.2.1)
    /// This method is part of the Swift.org open source project
    /// https://github.com/apple/swift-corelibs-foundation/blob/489984ce5c03890a5d9d51e10298bb7582c26178/Foundation/JSONEncoder.swift#L1014
    ///
    /// Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
    /// Licensed under Apache License v2.0 with Runtime Library Exception
    ///
    /// See https://swift.org/LICENSE.txt for license information
    /// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
    fileprivate static func _convertFromSnakeCase(_ stringKey: String) -> String {
        guard !stringKey.isEmpty else { return stringKey }

        // Find the first non-underscore character
        guard let firstNonUnderscore = stringKey.firstIndex(where: { $0 != "_" }) else {
            // Reached the end without finding an _
            return stringKey
        }

        // Find the last non-underscore character
        var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
        while lastNonUnderscore > firstNonUnderscore && stringKey[lastNonUnderscore] == "_" {
            stringKey.formIndex(before: &lastNonUnderscore)
        }

        let keyRange = firstNonUnderscore...lastNonUnderscore
        let leadingUnderscoreRange = stringKey.startIndex..<firstNonUnderscore
        let trailingUnderscoreRange = stringKey.index(after: lastNonUnderscore)..<stringKey.endIndex

        var components = stringKey[keyRange].split(separator: "_")
        let joinedString: String
        if components.count == 1 {
            // No underscores in key, leave the word as is - maybe already camel cased
            joinedString = String(stringKey[keyRange])
        } else {
            joinedString = ([components[0].lowercased()] + components[1...].map { $0.capitalized }).joined()
        }

        // Do a cheap isEmpty check before creating and appending potentially empty strings
        let result: String
        if leadingUnderscoreRange.isEmpty && trailingUnderscoreRange.isEmpty {
            result = joinedString
        } else if !leadingUnderscoreRange.isEmpty && !trailingUnderscoreRange.isEmpty {
            // Both leading and trailing underscores
            result = String(stringKey[leadingUnderscoreRange]) + joinedString + String(stringKey[trailingUnderscoreRange])
        } else if !leadingUnderscoreRange.isEmpty {
            // Just leading
            result = String(stringKey[leadingUnderscoreRange]) + joinedString
        } else {
            // Just trailing
            result = joinedString + String(stringKey[trailingUnderscoreRange])
        }
        return result
    }
    #endif

}

extension Array where Element == XcodeBuildSetting {

    /// Iterates through the `XcodeBuildSetting`s and returns the first value returned by the getter closure.
    ///
    /// For example, if we want the value of the first `XcodeBuildSetting` with a `"PROJECT_TEMP_ROOT"` value:
    ///
    ///     let buildSettings: [XcodeBuildSetting] = ...
    ///     let projectTempRoot = buildSettings.firstBuildSettingValue { $0.projectTempRoot }
    ///
    /// - Parameter getterClosure: A closure that returns a dynamic member.
    /// - Returns: The first value returned by the getter closure.
    func firstBuildSettingValue(for getterClosure: (XcodeBuildSetting) -> String?) -> String? {
        for buildSetting in self {
            if let value = getterClosure(buildSetting) {
                return value
            }
        }

        return nil
    }

}
