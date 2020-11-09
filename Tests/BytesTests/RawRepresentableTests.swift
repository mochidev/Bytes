//
//  RawRepresentableTests.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 11/8/20.
//  Copyright © 2020 Mochi Development, Inc. All rights reserved.
//

import XCTest
import Bytes

final class RawRepresentableTests: XCTestCase {
    @frozen enum RawEnum: RawRepresentable {
        init?(rawValue: SimpleStruct) {
            switch rawValue.value {
            case 0:
                self = .a
            case 1:
                self = .b
            case 2:
                self = .c
            default:
                return nil
            }
        }
        
        var rawValue: SimpleStruct {
            switch self {
            case .a:
                return SimpleStruct(value: 0)
            case .b:
                return SimpleStruct(value: 1)
            case .c:
                return SimpleStruct(value: 2)
            }
        }
        
        struct SimpleStruct {
            var value: UInt8
        }
        
        typealias RawValue = SimpleStruct
        
        case a, b, c
    }
    
    enum IntEnum: UInt16 {
        case a, b, c
    }
    
    enum StringEnum: String {
        case a, b, c
    }
    
    enum CharacterEnum: Character {
        case a = "a", b = "b", c = "c"
    }
    
    func testBytesToRawRepresentable() throws {
        XCTAssertEqual(try RawEnum(rawBytes: [0x00]), .a)
        XCTAssertEqual(try RawEnum(rawBytes: [0x01]), .b)
        XCTAssertEqual(try RawEnum(rawBytes: [0x02]), .c)
        XCTAssertThrowsError(try RawEnum(rawBytes: [0x03])) {
            BytesError.testInvalidRawRepresentableByteSequence($0)
        }
        XCTAssertThrowsError(try RawEnum(rawBytes: [0x00,0x00])) {
            BytesError.testInvalidMemorySize($0, targetSize: 1, targetType: "SimpleStruct", actualSize: 2)
        }
        XCTAssertEqual(try [RawEnum](rawBytes: [0x00,0x01,0x02]), [.a, .b, .c])
        XCTAssertEqual(try Set<RawEnum>(rawBytes: [0x00,0x01,0x02]), [.a, .b, .c])
        XCTAssertEqual(try [RawEnum](rawBytes: []), [])
        XCTAssertEqual(try Set<RawEnum>(rawBytes: []), [])
        XCTAssertThrowsError(try [RawEnum](rawBytes: [0x03])) {
            BytesError.testInvalidRawRepresentableByteSequence($0)
        }
        XCTAssertThrowsError(try Set<RawEnum>(rawBytes: [0x03])) {
            BytesError.testInvalidRawRepresentableByteSequence($0)
        }
        
        XCTAssertEqual(try IntEnum(bigEndianBytes: [0x00,0x00]), .a)
        XCTAssertEqual(try IntEnum(littleEndianBytes: [0x00,0x00]), .a)
        XCTAssertEqual(try IntEnum(bigEndianBytes: [0x00,0x01]), .b)
        XCTAssertEqual(try IntEnum(littleEndianBytes: [0x01,0x00]), .b)
        XCTAssertEqual(try IntEnum(bigEndianBytes: [0x00,0x02]), .c)
        XCTAssertEqual(try IntEnum(littleEndianBytes: [0x02,0x00]), .c)
        XCTAssertThrowsError(try IntEnum(bigEndianBytes: [0x00,0x03])) {
            BytesError.testInvalidRawRepresentableByteSequence($0)
        }
        XCTAssertThrowsError(try IntEnum(littleEndianBytes: [0x00,0x03])) {
            BytesError.testInvalidRawRepresentableByteSequence($0)
        }
        XCTAssertThrowsError(try IntEnum(bigEndianBytes: [0x00])) {
            BytesError.testInvalidMemorySize($0, targetSize: 2, targetType: "UInt16", actualSize: 1)
        }
        XCTAssertThrowsError(try IntEnum(littleEndianBytes: [0x00])) {
            BytesError.testInvalidMemorySize($0, targetSize: 2, targetType: "UInt16", actualSize: 1)
        }
        XCTAssertEqual(try [IntEnum](bigEndianBytes: [0x00,0x00,0x00,0x01,0x00,0x02]), [.a, .b, .c])
        XCTAssertEqual(try [IntEnum](littleEndianBytes: [0x00,0x00,0x01,0x00,0x02,0x00]), [.a, .b, .c])
        XCTAssertEqual(try Set<IntEnum>(bigEndianBytes: [0x00,0x00,0x00,0x01,0x00,0x02]), [.a, .b, .c])
        XCTAssertEqual(try Set<IntEnum>(littleEndianBytes: [0x00,0x00,0x01,0x00,0x02,0x00]), [.a, .b, .c])
        XCTAssertEqual(try [IntEnum](bigEndianBytes: []), [])
        XCTAssertEqual(try [IntEnum](littleEndianBytes: []), [])
        XCTAssertEqual(try Set<IntEnum>(bigEndianBytes: []), [])
        XCTAssertEqual(try Set<IntEnum>(littleEndianBytes: []), [])
        XCTAssertThrowsError(try [IntEnum](bigEndianBytes: [0x00, 0x03])) {
            BytesError.testInvalidRawRepresentableByteSequence($0)
        }
        XCTAssertThrowsError(try [IntEnum](littleEndianBytes: [0x00, 0x03])) {
            BytesError.testInvalidRawRepresentableByteSequence($0)
        }
        XCTAssertThrowsError(try Set<IntEnum>(bigEndianBytes: [0x00, 0x03])) {
            BytesError.testInvalidRawRepresentableByteSequence($0)
        }
        XCTAssertThrowsError(try Set<IntEnum>(littleEndianBytes: [0x00, 0x03])) {
            BytesError.testInvalidRawRepresentableByteSequence($0)
        }
        XCTAssertThrowsError(try [IntEnum](bigEndianBytes: [0x00])) {
            BytesError.testInvalidMemorySize($0, targetSize: 2, targetType: "UInt16", actualSize: 1)
        }
        XCTAssertThrowsError(try [IntEnum](littleEndianBytes: [0x00])) {
            BytesError.testInvalidMemorySize($0, targetSize: 2, targetType: "UInt16", actualSize: 1)
        }
        XCTAssertThrowsError(try Set<IntEnum>(bigEndianBytes: [0x00])) {
            BytesError.testInvalidMemorySize($0, targetSize: 2, targetType: "UInt16", actualSize: 1)
        }
        XCTAssertThrowsError(try Set<IntEnum>(littleEndianBytes: [0x00])) {
            BytesError.testInvalidMemorySize($0, targetSize: 2, targetType: "UInt16", actualSize: 1)
        }
        
        XCTAssertEqual(try StringEnum(utf8Bytes: [0x61]), .a)
        XCTAssertEqual(try StringEnum(utf8Bytes: [0x62]), .b)
        XCTAssertEqual(try StringEnum(utf8Bytes: [0x63]), .c)
        XCTAssertThrowsError(try StringEnum(utf8Bytes: [0x60])) {
            BytesError.testInvalidRawRepresentableByteSequence($0)
        }
        XCTAssertThrowsError(try StringEnum(utf8Bytes: [0x60,0x60])) {
            BytesError.testInvalidRawRepresentableByteSequence($0)
        }
        XCTAssertThrowsError(try StringEnum(utf8Bytes: [])) {
            BytesError.testInvalidRawRepresentableByteSequence($0)
        }
        
        XCTAssertEqual(try CharacterEnum(utf8Bytes: [0x61]), .a)
        XCTAssertEqual(try CharacterEnum(utf8Bytes: [0x62]), .b)
        XCTAssertEqual(try CharacterEnum(utf8Bytes: [0x63]), .c)
        XCTAssertThrowsError(try CharacterEnum(utf8Bytes: [0x60])) {
            BytesError.testInvalidRawRepresentableByteSequence($0)
        }
        XCTAssertThrowsError(try CharacterEnum(utf8Bytes: [0x60,0x60])) {
            BytesError.testInvalidCharacterByteSequence($0)
        }
        XCTAssertThrowsError(try CharacterEnum(utf8Bytes: [])) {
            BytesError.testInvalidCharacterByteSequence($0)
        }
    }
    
    func testRawRepresentableToBytes() throws {
        XCTAssertEqual(RawEnum.a.rawBytes, [0x00])
        XCTAssertEqual(RawEnum.b.rawBytes, [0x01])
        XCTAssertEqual(RawEnum.c.rawBytes, [0x02])
        XCTAssertEqual([RawEnum.a, .b, .c].rawBytes, [0x00,0x01,0x02])
        XCTAssertEqual(Set([RawEnum.a, .b, .c]).rawBytes.sorted(), [0x00,0x01,0x02])
        
        XCTAssertEqual(IntEnum.a.bigEndianBytes, [0x00,0x00])
        XCTAssertEqual(IntEnum.a.littleEndianBytes, [0x00,0x00])
        XCTAssertEqual(IntEnum.b.bigEndianBytes, [0x00,0x01])
        XCTAssertEqual(IntEnum.b.littleEndianBytes, [0x01,0x00])
        XCTAssertEqual(IntEnum.c.bigEndianBytes, [0x00,0x02])
        XCTAssertEqual(IntEnum.c.littleEndianBytes, [0x02,0x00])
        XCTAssertEqual([IntEnum.a, .b, .c].bigEndianBytes, [0x00,0x00,0x00,0x01,0x00,0x02])
        XCTAssertEqual([IntEnum.a, .b, .c].littleEndianBytes, [0x00,0x00,0x01,0x00,0x02,0x00])
        XCTAssertEqual(try [UInt16](bigEndianBytes: Set([IntEnum.a, .b, .c]).bigEndianBytes).sorted(), [0x0000,0x0001,0x0002])
        XCTAssertEqual(try [UInt16](littleEndianBytes: Set([IntEnum.a, .b, .c]).littleEndianBytes).sorted(), [0x0000,0x0001,0x0002])
        
        XCTAssertEqual(StringEnum.a.utf8Bytes, [0x61])
        XCTAssertEqual(StringEnum.b.utf8Bytes, [0x62])
        XCTAssertEqual(StringEnum.c.utf8Bytes, [0x63])
        
        XCTAssertEqual(CharacterEnum.a.utf8Bytes, [0x61])
        XCTAssertEqual(CharacterEnum.b.utf8Bytes, [0x62])
        XCTAssertEqual(CharacterEnum.c.utf8Bytes, [0x63])
    }
}
