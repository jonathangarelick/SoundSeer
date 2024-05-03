import XCTest

@testable import SoundSeer

final class UtilsTests: XCTestCase {
    func testGetFinalNumber() {
        XCTAssertEqual(Utils.getFinalNumber(from: ""), Optional.none)
        XCTAssertEqual(Utils.getFinalNumber(from: "abc"), Optional.none)
        XCTAssertEqual(Utils.getFinalNumber(from: "123"), "123")
        XCTAssertEqual(Utils.getFinalNumber(from: "abc123"), "123")
        XCTAssertEqual(Utils.getFinalNumber(from: "123abc"), "123")

        XCTAssertEqual(Utils.getFinalNumber(from: "123abc456"), "456")
        XCTAssertEqual(Utils.getFinalNumber(from: "a123abc456"), "456")
        XCTAssertEqual(Utils.getFinalNumber(from: "a123abc456z"), "456")
        XCTAssertEqual(Utils.getFinalNumber(from: "a123456z"), "123456")

        XCTAssertEqual(Utils.getFinalNumber(from: "itmss://itunes.com/album?p=1734980417"), "1734980417")
        XCTAssertEqual(Utils.getFinalNumber(from: "itmss://itunes.com/album?p=1734980417&i=1734980438"), "1734980438")
    }
}
