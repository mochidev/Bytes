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
    
    func testSlices() throws {
        let bytes: Bytes = [0,1,2,3,4,5]
        let slice = bytes[1..<5]
        
        let value = UInt32(1<<24) + UInt32(2<<16) + UInt32(3<<8) + UInt32(4)
        XCTAssertEqual(try slice.casting(to: UInt32.self).bigEndian, value)
        
        XCTAssertThrowsError(try bytes[...].casting(to: UInt32.self)) { error in
            if case let BytesError.invalidMemorySize(targetSize, targetType, actualSize) = error {
                XCTAssertEqual(targetSize, 4)
                XCTAssertEqual(targetType, "UInt32")
                XCTAssertEqual(actualSize, 6)
            } else {
                XCTFail("Unknown Error: \(error)")
            }
        }
        
        XCTAssertThrowsError(try bytes[0..<1].casting(to: UInt32.self)) { error in
            if case let BytesError.invalidMemorySize(targetSize, targetType, actualSize) = error {
                XCTAssertEqual(targetSize, 4)
                XCTAssertEqual(targetType, "UInt32")
                XCTAssertEqual(actualSize, 1)
            } else {
                XCTFail("Unknown Error: \(error)")
            }
        }
    }

    static var allTests = [
        ("testTypes", testTypes),
        ("testCastTo", testCastTo),
        ("testSlices", testSlices),
    ]
}
