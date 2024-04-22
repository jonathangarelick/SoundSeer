import XCTest

@testable import SoundSeer

final class StringExtensionTests: XCTestCase {
    // A negative length causes a fatal error. Handling this in a test requires a bit of
    // a hack. I will skip it for now
    func testTruncate() throws {
        XCTAssertEqual("ABCDE".truncate(length: 0), "") // argument < actual length
        XCTAssertEqual("ABCDE".truncate(length: 1), ".")
        XCTAssertEqual("ABCDE".truncate(length: 2), "..")
        XCTAssertEqual("ABCDE".truncate(length: 3), "...")
        XCTAssertEqual("ABCDE".truncate(length: 4), "A...")
        XCTAssertEqual("ABCDE".truncate(length: 5), "ABCDE") // argument ==  actual length
        XCTAssertEqual("ABCDE".truncate(length: 6), "ABCDE") // argument > actual length
    }
}
