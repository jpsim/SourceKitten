@dynamicMemberLookup
struct XcodeBuildSetting: Codable {

    /// The build settings.
    let buildSettings: [String: String]

    subscript(dynamicMember member: String) -> String? {
        return buildSettings[member]
    }
}
