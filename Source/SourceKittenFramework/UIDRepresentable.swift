public protocol UIDRepresentable {
    var uid: UID { get }
}

extension UID: UIDRepresentable {
    public var uid: UID {
        return self
    }
}

extension String: UIDRepresentable {
    public var uid: UID {
        return UID(self)
    }
}
