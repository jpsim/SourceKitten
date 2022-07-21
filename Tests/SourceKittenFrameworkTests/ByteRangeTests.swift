import SourceKittenFramework
import XCTest

class ByteRangeTests: XCTestCase {

    func testZeroLengthRangeContainment() {
        let range = ByteRange(location: 10, length: 0)
        XCTAssertFalse(range.contains(ByteCount(9)))
        XCTAssertFalse(range.contains(ByteCount(10)))
        XCTAssertFalse(range.contains(ByteCount(11)))
    }

    func testNonZeroLengthRangeContainment() {
        let range = ByteRange(location: 10, length: 10)
        XCTAssertFalse(range.contains(ByteCount(9)))

        XCTAssertTrue(range.contains(ByteCount(10)))
        XCTAssertTrue(range.contains(ByteCount(11)))
        XCTAssertTrue(range.contains(ByteCount(19)))

        XCTAssertFalse(range.contains(ByteCount(20)))
    }

    func testRangeUnionWithSameRange() {
        let range1 = ByteRange(location: 10, length: 10)
        let range2 = ByteRange(location: 10, length: 10)
        let union = range1.union(with: range2)
        XCTAssertEqual(range1, union)
    }

    func testRangeUnionWithNonOverlappingRange() {
        let range1 = ByteRange(location: 10, length: 1)
        let range2 = ByteRange(location: 20, length: 1)
        let union = range1.union(with: range2)
        XCTAssertEqual(union, ByteRange(location: 10, length: 11))
    }

    func testRangeUnionWithFullyIncludedRange() {
        let range1 = ByteRange(location: 10, length: 20)
        let range2 = ByteRange(location: 20, length: 1)
        let union = range1.union(with: range2)
        XCTAssertEqual(union, ByteRange(location: 10, length: 20))
    }

    func testRangeUnionWithOverlapping() {
        let range1 = ByteRange(location: 10, length: 5)
        let range2 = ByteRange(location: 11, length: 6)
        let union = range1.union(with: range2)
        XCTAssertEqual(union, ByteRange(location: 10, length: 7))
    }

}
