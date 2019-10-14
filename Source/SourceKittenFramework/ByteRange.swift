/// Structture that represents range in bytes
public struct ByteRange {

    public let location: ByteOffset

    public let length: Int

    public init(location: ByteOffset, length: Int) {
        self.location = location
        self.length = length
    }

    var maxRange: ByteOffset {
        return location + length
    }
}

extension ByteRange: Equatable {
    public static func == (lhs: ByteRange, rhs: ByteRange) -> Bool {
        return lhs.location == rhs.location && lhs.length == rhs.length
    }
}

/// Wrapper over the offset to represent offset in bytes
public struct ByteOffset {
    var value: Int

    public init(_ value: Int) {
        self.value = value
    }

    static let zero = ByteOffset(0)
}

extension ByteOffset: CustomStringConvertible {
    public var description: String {
        return value.description
    }
}

extension ByteOffset: Comparable {

    public static func == (lhs: ByteOffset, rhs: ByteOffset) -> Bool {
        return lhs.value == rhs.value
    }

    public static func < (lhs: ByteOffset, rhs: ByteOffset) -> Bool {
        return lhs.value < rhs.value
    }
}

public extension ByteOffset {
    static func +(lhs: ByteOffset, rhs: ByteOffset) -> ByteOffset {
        return ByteOffset(lhs.value + rhs.value)
    }

    static func +(lhs: ByteOffset, rhs: Int) -> ByteOffset {
        return ByteOffset(lhs.value + rhs)
    }

    static func -(lhs: ByteOffset, rhs: ByteOffset) -> ByteOffset {
        return ByteOffset(lhs.value - rhs.value)
    }

    static func -(lhs: ByteOffset, rhs: Int) -> ByteOffset {
        return ByteOffset(lhs.value - rhs)
    }

}
