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

    subscript(dynamicMember member: String) -> String? {
        return buildSettings[member]
    }

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
