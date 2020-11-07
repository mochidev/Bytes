import XCTest
@testable import Bytes

final class BytesTests: XCTestCase {
    func testTypes() throws {
        XCTAssertTrue(Bytes.self == Array<UInt8>.self)
        XCTAssertTrue(BytesSlice.self == ArraySlice<UInt8>.self)
        XCTAssertTrue(ContiguousBytes.self == ContiguousArray<UInt8>.self)
        
        XCTAssertFalse(Bytes.self == Array<Int8>.self)
    }

    static var allTests = [
        ("testTypes", testTypes),
    ]
}
