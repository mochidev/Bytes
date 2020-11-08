//
//  BytesTests.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 11/6/20.
//  Copyright © 2020 Mochi Development, Inc. All rights reserved.
//

import XCTest
import Bytes

extension BytesError {
    static func testInvalidMemorySize(
        _ expression: @autoclosure () throws -> Error,
        targetSize: @autoclosure () throws -> Int,
        targetType: @autoclosure () throws -> String,
        actualSize: @autoclosure () throws -> Int,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line) rethrows {
        
        let expressionResult = try expression()
        let messageResult = message()
        
        if case let Self.invalidMemorySize(a1, a2, a3) = expressionResult {
            XCTAssertEqual(a1, try targetSize(), messageResult, file: file, line: line)
            XCTAssertEqual(a2, try targetType(), messageResult, file: file, line: line)
            XCTAssertEqual(a3, try actualSize(), messageResult, file: file, line: line)
        } else if messageResult.isEmpty {
            XCTFail("\(expressionResult) is not BytesError.invalidMemorySize", file: file, line: line)
        } else {
            XCTFail(messageResult, file: file, line: line)
        }
    }
    
    static func testContiguousMemoryUnavailable(
        _ expression: @autoclosure () throws -> Error,
        collectionType: @autoclosure () throws -> String,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line) rethrows {
        
        let expressionResult = try expression()
        let messageResult = message()
        
        if case let Self.contiguousMemoryUnavailable(a1) = expressionResult {
            XCTAssertEqual(a1, try collectionType(), messageResult, file: file, line: line)
        } else if messageResult.isEmpty {
            XCTFail("\(expressionResult) is not BytesError.contiguousMemoryUnavailable", file: file, line: line)
        } else {
            XCTFail(messageResult, file: file, line: line)
        }
    }
    
    static func testInvalidCharacterByteSequence(
        _ expression: @autoclosure () throws -> Error,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line) rethrows {
        
        let expressionResult = try expression()
        let messageResult = message()
        
        if case Self.invalidCharacterByteSequence = expressionResult {
        } else if messageResult.isEmpty {
            XCTFail("\(expressionResult) is not BytesError.invalidCharacterByteSequence", file: file, line: line)
        } else {
            XCTFail(messageResult, file: file, line: line)
        }
    }
}

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
        
        XCTAssertThrowsError(try tooBig.casting(to: UInt32.self)) {
            BytesError.testInvalidMemorySize($0, targetSize: 4, targetType: "UInt32", actualSize: 5)
        }
        
        let tooSmall: Bytes = [0,0,0]
        
        XCTAssertThrowsError(try tooSmall.casting(to: UInt32.self)) {
            BytesError.testInvalidMemorySize($0, targetSize: 4, targetType: "UInt32", actualSize: 3)
        }
        
        let array1: Bytes = [0,0]
        let array2: Bytes = [0,0]
        
        let joined = [array1, array2].joined()
        
        XCTAssertThrowsError(try joined.casting(to: UInt32.self)) {
            BytesError.testContiguousMemoryUnavailable($0, collectionType: "FlattenSequence<Array<Array<UInt8>>>")
        }
    }
    
    func testSlices() throws {
        let bytes: Bytes = [0,1,2,3,4,5]
        let slice = bytes[1..<5]
        
        let value = UInt32(1<<24) + UInt32(2<<16) + UInt32(3<<8) + UInt32(4)
        XCTAssertEqual(try slice.casting(to: UInt32.self).bigEndian, value)
        
        XCTAssertThrowsError(try bytes[...].casting(to: UInt32.self)) {
            BytesError.testInvalidMemorySize($0, targetSize: 4, targetType: "UInt32", actualSize: 6)
        }
        
        XCTAssertThrowsError(try bytes[0..<1].casting(to: UInt32.self)) {
            BytesError.testInvalidMemorySize($0, targetSize: 4, targetType: "UInt32", actualSize: 1)
        }
    }
    
    func testCastFrom() throws {
        let value = UInt32(1<<24) + UInt32(2<<16) + UInt32(3<<8) + UInt32(4)
        XCTAssertEqual(Bytes(casting: value.bigEndian), [1,2,3,4])
    }
    
    func testMapping() throws {
        let array: [UInt16] = [0x0001, 0x0010, 0x0100, 0x1000]
        let bytesFromArray = array.bytes { Bytes(casting: $0.bigEndian) }
        
        XCTAssertEqual(bytesFromArray, [0x00,0x01,0x00,0x10,0x01,0x00,0x10,0x00])
    }
}
