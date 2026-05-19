@testable import SourceKittenFramework
import XCTest

final class LoaderTests: XCTestCase {

    func testFailureMessageIncludesEveryAttemptAndItsReason() {
        let message = Loader.failureMessage(
            path: "sourcekitdInProc.framework/Versions/A/sourcekitdInProc",
            attemptFailures: [
                "  /Xcode.app/.../usr/lib/sourcekitdInProc.framework/Versions/A/sourcekitdInProc: " +
                    "mach-o file, but is an incompatible architecture (have 'arm64', need 'x86_64')",
                "  sourcekitdInProc.framework/Versions/A/sourcekitdInProc: image not found"
            ]
        )

        // The path being loaded is named.
        XCTAssertTrue(message.contains("sourcekitdInProc.framework/Versions/A/sourcekitdInProc"))
        // Every attempt's dlerror() reason survives into the final message.
        XCTAssertTrue(message.contains("incompatible architecture"))
        XCTAssertTrue(message.contains("image not found"))
    }

    func testFailureMessageWhenNoCandidatesWereTried() {
        // Empty searchPaths *and* an empty bare path attempt should produce an actionable hint
        // rather than a bare "Loading X failed" with no further detail.
        let message = Loader.failureMessage(path: "libfoo.so", attemptFailures: [])
        XCTAssertTrue(message.contains("libfoo.so"))
        XCTAssertTrue(message.contains("searchPaths"))
    }
}
