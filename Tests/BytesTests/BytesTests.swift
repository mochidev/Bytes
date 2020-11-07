import XCTest
@testable import Bytes

final class BytesTests: XCTestCase {
    func testTypes() throws {
        XCTAssertTrue(Bytes.self == Array<UInt8>.self)
        XCTAssertTrue(BytesSlice.self == ArraySlice<UInt8>.self)
        XCTAssertTrue(ContiguousBytes.self == ContiguousArray<UInt8>.self)
        
        XCTAssertFalse(Bytes.self == Array<Int8>.self)
    }
    
    func testCastTo() throws {
        let zero: Bytes = [0,0,0,0]
        
        XCTAssertEqual(UInt32(0), try zero.casting(to: UInt32.self))
        XCTAssertEqual(UInt32(0), try zero.casting() as UInt32)
        
        let tooBig: Bytes = [0,0,0,0,0]
        
        XCTAssertThrowsError(try tooBig.casting(to: UInt32.self)) { error in
            if case let BytesError.invalidMemorySize(targetSize, targetType, actualSize) = error {
                XCTAssertEqual(targetSize, 4)
                XCTAssertEqual(targetType, "UInt32")
                XCTAssertEqual(actualSize, 5)
            } else {
                XCTFail("Unknown Error: \(error)")
            }
        }
        
        let tooSmall: Bytes = [0,0,0]
        
        XCTAssertThrowsError(try tooSmall.casting(to: UInt32.self)) { error in
            if case let BytesError.invalidMemorySize(targetSize, targetType, actualSize) = error {
                XCTAssertEqual(targetSize, 4)
                XCTAssertEqual(targetType, "UInt32")
                XCTAssertEqual(actualSize, 3)
            } else {
                XCTFail("Unknown Error: \(error)")
            }
        }
        
        let array1: Bytes = [0,0]
        let array2: Bytes = [0,0]
        
        let joined = [array1, array2].joined()
        
        XCTAssertThrowsError(try joined.casting(to: UInt32.self)) { error in
            if case let BytesError.contiguousMemoryUnavailable(collectionType) = error {
                XCTAssertEqual(collectionType, "FlattenSequence<Array<Array<UInt8>>>")
            } else {
                XCTFail("Unknown Error: \(error)")
            }
        }
    }

    static var allTests = [
        ("testTypes", testTypes),
        ("testCastTo", testCastTo),
    ]
}
