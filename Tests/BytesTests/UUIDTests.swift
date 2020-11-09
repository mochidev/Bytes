//
//  UUIDTests.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 11/8/20.
//  Copyright © 2020 Mochi Development, Inc. All rights reserved.
//

import XCTest
import Bytes

final class UUIDTests: XCTestCase {
    let rawUUIDBytes: Bytes = [0xDD,0xC8,0x8A,0x45,0x43,0xEF,0x4B,0x95,0xB3,0xF5,0x53,0x4F,0x7F,0x96,0xC4,0x60]
    let rawUUID: uuid_t = (0xDD,0xC8,0x8A,0x45,0x43,0xEF,0x4B,0x95,0xB3,0xF5,0x53,0x4F,0x7F,0x96,0xC4,0x60)
    let rawUUIDString = "DDC88A45-43EF-4B95-B3F5-534F7F96C460"
    lazy var validUUID = UUID(uuid: rawUUID)
    lazy var rawUUIDStringBytes = rawUUIDString.utf8Bytes
    
    func testBytesToUUID() throws {
        XCTAssertEqual(try UUID(bytes: rawUUIDBytes), validUUID)
        XCTAssertEqual(try UUID(stringBytes: rawUUIDStringBytes), validUUID)
        
        XCTAssertThrowsError(try UUID(bytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 16, targetType: "(UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)", actualSize: 0)
        }
        XCTAssertThrowsError(try UUID(stringBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 36, targetType: "(UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)", actualSize: 0)
        }
        XCTAssertThrowsError(try UUID(stringBytes: "000000000000000000000000000000000000".utf8Bytes)) {
            BytesError.testInvalidUUIDByteSequence($0)
        }
        
        XCTAssertEqual(try [UUID](bytes: rawUUIDBytes+rawUUIDBytes), [validUUID, validUUID])
        XCTAssertEqual(try Set<UUID>(bytes: rawUUIDBytes+rawUUIDBytes), [validUUID])
        XCTAssertEqual(try [UUID](bytes: []), [])
        XCTAssertEqual(try Set<UUID>(bytes: []), [])
        XCTAssertThrowsError(try [UUID](bytes: rawUUIDBytes+[0])) {
            BytesError.testInvalidMemorySize($0, targetSize: 32, targetType: "(UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)", actualSize: 17)
        }
        XCTAssertThrowsError(try Set<UUID>(bytes: rawUUIDBytes+[0])) {
            BytesError.testInvalidMemorySize($0, targetSize: 32, targetType: "(UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)", actualSize: 17)
        }
        
        XCTAssertEqual(try [UUID](stringBytes: rawUUIDStringBytes+rawUUIDStringBytes), [validUUID, validUUID])
        XCTAssertEqual(try Set<UUID>(stringBytes: rawUUIDStringBytes+rawUUIDStringBytes), [validUUID])
        XCTAssertEqual(try [UUID](stringBytes: []), [])
        XCTAssertEqual(try Set<UUID>(stringBytes: []), [])
        XCTAssertThrowsError(try [UUID](stringBytes: rawUUIDStringBytes+[0])) {
            BytesError.testInvalidMemorySize($0, targetSize: 72, targetType: "(UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)", actualSize: 37)
        }
        XCTAssertThrowsError(try Set<UUID>(stringBytes: rawUUIDStringBytes+[0])) {
            BytesError.testInvalidMemorySize($0, targetSize: 72, targetType: "(UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)", actualSize: 37)
        }
        XCTAssertThrowsError(try [UUID](stringBytes: "000000000000000000000000000000000000000000000000000000000000000000000000".utf8Bytes)) {
            BytesError.testInvalidUUIDByteSequence($0)
        }
        XCTAssertThrowsError(try Set<UUID>(stringBytes: "000000000000000000000000000000000000000000000000000000000000000000000000".utf8Bytes)) {
            BytesError.testInvalidUUIDByteSequence($0)
        }
    }
    
    func testRawRepresentableToBytes() throws {
        XCTAssertEqual(validUUID.bytes, rawUUIDBytes)
        XCTAssertEqual(validUUID.stringBytes, rawUUIDStringBytes)
        
        XCTAssertEqual([validUUID, validUUID].bytes, rawUUIDBytes+rawUUIDBytes)
        XCTAssertEqual([validUUID, validUUID].stringBytes, rawUUIDStringBytes+rawUUIDStringBytes)
        XCTAssertEqual(Set([validUUID]).bytes, rawUUIDBytes)
        XCTAssertEqual(Set([validUUID]).stringBytes, rawUUIDStringBytes)
    }
}
