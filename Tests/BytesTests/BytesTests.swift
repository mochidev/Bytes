//
//  BytesTests.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 11/6/20.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

import XCTest
import Bytes
import Testing

extension BytesError {
    static func testInvalidMemorySize(
        _ expression: @autoclosure () throws -> any Error,
        targetSize: @autoclosure () throws -> Int,
        targetType: @autoclosure () throws -> String,
        actualSize: @autoclosure () throws -> Int,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) rethrows {
        let expressionResult = try expression()
        let messageResult = message()
        
        switch expressionResult {
        case
            let BytesError.BufferSizeError.invalidBufferSize(a1, a2, a3),
            let BytesError.UUIDDecoding.BufferSizeError.castingFailure(.invalidBufferSize(a1, a2, a3)),
            let BytesError.RawRepresentable.BufferSizeError.castingFailure(.invalidBufferSize(a1, a2, a3)),
            let BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.castingFailure(.castingFailure(.invalidBufferSize(a1, a2, a3))):
            XCTAssertEqual(a1, try targetSize(), messageResult, file: (file), line: line)
            XCTAssertEqual(a2, try targetType(), messageResult, file: (file), line: line)
            XCTAssertEqual(a3, try actualSize(), messageResult, file: (file), line: line)
        default:
            if messageResult.isEmpty {
                XCTFail("\(type(of: expressionResult)).\(expressionResult) is not BytesError.invalidMemorySize", file: (file), line: line)
            } else {
                XCTFail(messageResult, file: (file), line: line)
            }
        }
    }
    
    static func testInvalidCharacterByteSequence(
        _ expression: @autoclosure () throws -> any Error,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) rethrows {
        let expressionResult = try expression()
        let messageResult = message()
        
        switch expressionResult {
        case
            BytesError.CharacterDecodingError.invalidCharacterByteSequence,
            BytesError.RawRepresentable.CharacterDecodingError.castingFailure(.invalidCharacterByteSequence):
            break
        default:
            if messageResult.isEmpty {
                XCTFail("\(type(of: expressionResult)).\(expressionResult) is not BytesError.invalidCharacterByteSequence", file: (file), line: line)
            } else {
                XCTFail(messageResult, file: (file), line: line)
            }
        }
    }
    
    static func testInvalidRawRepresentableByteSequence(
        _ expression: @autoclosure () throws -> any Error,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) rethrows {
        let expressionResult = try expression()
        let messageResult = message()
        
        switch expressionResult {
        case
            BytesError.RawRepresentableError<Never>.invalidRawRepresentableByteSequence,
            BytesError.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence,
            BytesError.RawRepresentable.CharacterDecodingError.invalidRawRepresentableByteSequence,
            BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence:
            break
        default:
            if messageResult.isEmpty {
                XCTFail("\(type(of: expressionResult)).\(expressionResult) is not BytesError.invalidRawRepresentableByteSequence", file: (file), line: line)
            } else {
                XCTFail(messageResult, file: (file), line: line)
            }
        }
    }
    
    static func testInvalidUUIDByteSequence(
        _ expression: @autoclosure () throws -> any Error,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) rethrows {
        let expressionResult = try expression()
        let messageResult = message()
        
        switch expressionResult {
        case
            BytesError.UUIDDecodingError<Never>.invalidUUIDByteSequence,
            BytesError.UUIDDecodingError<BufferSizeError>.invalidUUIDByteSequence:
            break
        default:
            if messageResult.isEmpty {
                XCTFail("\(type(of: expressionResult)).\(expressionResult) is not BytesError.invalidUUIDByteSequence", file: (file), line: line)
            } else {
                XCTFail(messageResult, file: (file), line: line)
            }
        }
    }
}

@Suite struct IdentityTests {
    @Test func typeIdentity() async throws {
        #expect(Byte.self == UInt8.self)
        #expect(Bytes.self == Array<UInt8>.self)
        #expect(BytesSlice.self == ArraySlice<UInt8>.self)
        
        #expect(Byte.self != Int8.self)
        #expect(Bytes.self != Array<Int8>.self)
    }
}
