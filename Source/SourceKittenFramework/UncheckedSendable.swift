struct UncheckedSendable<Value>: @unchecked Sendable {
    /// The unchecked value.
    var value: Value

    /// Initializes unchecked sendability around a value.
    ///
    /// - Parameter value: A value to make sendable in an unchecked way.
    init(_ value: Value) {
        self.value = value
    }
}
