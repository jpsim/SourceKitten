/// Doc for Base
class Base {

    /// Doc for Base.Index
    typealias Index = Int

    /// Doc for Base.f
    func f(index: Index) {
    }

    /// Doc for Base.Nested
    class Nested {
    }
}

extension Base {

    /// Doc for Base.ExtendedIndex
    typealias ExtendedIndex = Double

    /// Doc for Base.extendedF
    func extendedF(index: ExtendedIndex) {
    }
}

// Tests for extensions of nested types

extension Base.Nested {
}

class 🐽 {
    struct 🐧 {
    }
}

extension 🐽.🐧 {
}
