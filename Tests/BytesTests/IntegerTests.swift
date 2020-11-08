//
//  IntegerTests.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 11/8/20.
//  Copyright © 2020 Mochi Development, Inc. All rights reserved.
//

import XCTest
import Bytes

final class IntegerTests: XCTestCase {
    func testBytesToInteger() throws {
        XCTAssertEqual(try UInt8(bigEndianBytes: [0x01]), UInt8(0x01))
        XCTAssertEqual(try UInt8(littleEndianBytes: [0x01]), UInt8(0x01))
        XCTAssertEqual(try Int8(bigEndianBytes: [0xff]), Int8(-0x01))
        XCTAssertEqual(try Int8(littleEndianBytes: [0xff]), Int8(-0x01))
        
        XCTAssertEqual(try UInt16(bigEndianBytes: [0x01, 0x23]), UInt16(0x0123))
        XCTAssertEqual(try UInt16(littleEndianBytes: [0x23, 0x01]), UInt16(0x0123))
        XCTAssertEqual(try Int16(bigEndianBytes: [0xfe, 0xdd]), Int16(-0x0123))
        XCTAssertEqual(try Int16(littleEndianBytes: [0xdd, 0xfe]), Int16(-0x0123))
        
        XCTAssertEqual(try UInt32(bigEndianBytes: [0x01, 0x23, 0x45, 0x67]), UInt32(0x01234567))
        XCTAssertEqual(try UInt32(littleEndianBytes: [0x67, 0x45, 0x23, 0x01]), UInt32(0x01234567))
        XCTAssertEqual(try Int32(bigEndianBytes: [0xfe, 0xdc, 0xba, 0x99]), Int32(-0x01234567))
        XCTAssertEqual(try Int32(littleEndianBytes: [0x99, 0xba, 0xdc, 0xfe]), Int32(-0x01234567))
        
        XCTAssertEqual(try UInt64(bigEndianBytes: [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef]), UInt64(0x0123456789abcdef))
        XCTAssertEqual(try UInt64(littleEndianBytes: [0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01]), UInt64(0x0123456789abcdef))
        XCTAssertEqual(try Int64(bigEndianBytes: [0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x11]), Int64(-0x0123456789abcdef))
        XCTAssertEqual(try Int64(littleEndianBytes: [0x11, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe]), Int64(-0x0123456789abcdef))
    }
    
    func testInvalidBytes() throws {
        XCTAssertThrowsError(try UInt8(bigEndianBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 1, targetType: "UInt8", actualSize: 0)
        }
        XCTAssertThrowsError(try UInt8(littleEndianBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 1, targetType: "UInt8", actualSize: 0)
        }
        
        XCTAssertThrowsError(try Int8(bigEndianBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 1, targetType: "Int8", actualSize: 0)
        }
        XCTAssertThrowsError(try Int8(littleEndianBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 1, targetType: "Int8", actualSize: 0)
        }
        
        XCTAssertThrowsError(try UInt16(bigEndianBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 2, targetType: "UInt16", actualSize: 0)
        }
        XCTAssertThrowsError(try UInt16(littleEndianBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 2, targetType: "UInt16", actualSize: 0)
        }
        
        XCTAssertThrowsError(try Int16(bigEndianBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 2, targetType: "Int16", actualSize: 0)
        }
        XCTAssertThrowsError(try Int16(littleEndianBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 2, targetType: "Int16", actualSize: 0)
        }
        
        XCTAssertThrowsError(try UInt32(bigEndianBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 4, targetType: "UInt32", actualSize: 0)
        }
        XCTAssertThrowsError(try UInt32(littleEndianBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 4, targetType: "UInt32", actualSize: 0)
        }
        
        XCTAssertThrowsError(try Int32(bigEndianBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 4, targetType: "Int32", actualSize: 0)
        }
        XCTAssertThrowsError(try Int32(littleEndianBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 4, targetType: "Int32", actualSize: 0)
        }
        
        XCTAssertThrowsError(try UInt64(bigEndianBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 8, targetType: "UInt64", actualSize: 0)
        }
        XCTAssertThrowsError(try UInt64(littleEndianBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 8, targetType: "UInt64", actualSize: 0)
        }
        
        XCTAssertThrowsError(try Int64(bigEndianBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 8, targetType: "Int64", actualSize: 0)
        }
        XCTAssertThrowsError(try Int64(littleEndianBytes: [])) {
            BytesError.testInvalidMemorySize($0, targetSize: 8, targetType: "Int64", actualSize: 0)
        }
    }
    
    func testIntegerToBytes() throws {
        XCTAssertEqual(UInt8(0x01).bigEndianBytes, [0x01])
        XCTAssertEqual(UInt8(0x01).bigEndianBytes, [0x01])
        XCTAssertEqual(UInt8(0x01).littleEndianBytes, [0x01])
        XCTAssertEqual(Int8(-0x01).bigEndianBytes, [0xff])
        XCTAssertEqual(Int8(-0x01).littleEndianBytes, [0xff])
        
        XCTAssertEqual(UInt16(0x0123).bigEndianBytes, [0x01, 0x23])
        XCTAssertEqual(UInt16(0x0123).littleEndianBytes, [0x23, 0x01])
        XCTAssertEqual(Int16(-0x0123).bigEndianBytes, [0xfe, 0xdd])
        XCTAssertEqual(Int16(-0x0123).littleEndianBytes, [0xdd, 0xfe])
        
        XCTAssertEqual(UInt32(0x01234567).bigEndianBytes, [0x01, 0x23, 0x45, 0x67])
        XCTAssertEqual(UInt32(0x01234567).littleEndianBytes, [0x67, 0x45, 0x23, 0x01])
        XCTAssertEqual(Int32(-0x01234567).bigEndianBytes, [0xfe, 0xdc, 0xba, 0x99])
        XCTAssertEqual(Int32(-0x01234567).littleEndianBytes, [0x99, 0xba, 0xdc, 0xfe])
        
        XCTAssertEqual(UInt64(0x0123456789abcdef).bigEndianBytes, [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef])
        XCTAssertEqual(UInt64(0x0123456789abcdef).littleEndianBytes, [0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01])
        XCTAssertEqual(Int64(-0x0123456789abcdef).bigEndianBytes, [0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x11])
        XCTAssertEqual(Int64(-0x0123456789abcdef).littleEndianBytes, [0x11, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe])
    }
}
