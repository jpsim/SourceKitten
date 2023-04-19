/*===============================================================================================================================================================================*
 *     PROJECT: SourceKitten
 *    FILENAME: NSLock+SourceKitten.swift
 *        DATE: 10/25/21
 *===============================================================================================================================================================================*/

import Foundation

extension NSLock {
    /// A pattern that comes up a lot when using locks. This method simplifies
    /// the usage while making sure that `unlock()` is not forgotten.
    ///
    /// - Parameter body: The closure to execute inside the lock.
    /// - Returns: The value, if any, returned by the closure.
    /// - Throws: Any error thrown by the closure.
    ///
    @inlinable func withLock<T>(_ body: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try body()
    }
}
