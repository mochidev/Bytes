//
//  UUIDTests.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 2020-11-08.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

import Bytes
import Foundation
import Testing

@Suite struct UUIDTests {
    static let rawUUIDBytes: Bytes = [0xDD,0xC8,0x8A,0x45,0x43,0xEF,0x4B,0x95,0xB3,0xF5,0x53,0x4F,0x7F,0x96,0xC4,0x60]
    static let rawUUID: uuid_t = (0xDD,0xC8,0x8A,0x45,0x43,0xEF,0x4B,0x95,0xB3,0xF5,0x53,0x4F,0x7F,0x96,0xC4,0x60)
    static let rawUUIDString = "DDC88A45-43EF-4B95-B3F5-534F7F96C460"
    static let rawUUIDLowercaseString = "ddc88a45-43ef-4b95-b3f5-534f7f96c460"
    static let invalidUUIDString = "ZzZzZzZz-ZzZz-ZzZz-ZzZz-ZzZzZzZzZzZz"
    static let validUUID = UUID(uuid: rawUUID)
    static let rawUUIDStringBytes = rawUUIDString.utf8Bytes
    static let rawUUIDLowercaseStringBytes = rawUUIDLowercaseString.utf8Bytes
    static let invalidUUIDStringBytes = invalidUUIDString.utf8Bytes
    
    @Test func bytesFromUUID() async throws {
        #expect(Self.validUUID.bytes == Self.rawUUIDBytes)
    }
    
    @Test func uuidFromNonContiguousBytes() async throws {
        #expect(try UUID(bytes: (Self.rawUUIDBytes as any BytesCollection)) == Self.validUUID)
        #expect(try UUID(bytes: [Self.rawUUIDBytes.prefix(8), Self.rawUUIDBytes.suffix(8)].joined()) == Self.validUUID)
        
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UUID(Byte<16>)", actualSize: 15)) {
            try UUID(bytes: (Self.rawUUIDBytes.dropLast(1) as any BytesCollection))
        }
    }
    
    @Test func uuidFromContiguousBytes() async throws {
        #expect(try UUID(bytes: Self.rawUUIDBytes) == Self.validUUID)
        
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UUID(Byte<16>)", actualSize: 15)) {
            try UUID(bytes: Self.rawUUIDBytes.dropLast(1))
        }
    }
    
    @Test func stringBytesFromUUID() async throws {
        #expect(Self.validUUID.stringBytes == Self.rawUUIDStringBytes)
    }
    
    @Test func uuidFromStringBytes() async throws {
        #expect(try UUID(stringBytes: Self.rawUUIDStringBytes) == Self.validUUID)
        #expect(try UUID(stringBytes: Self.rawUUIDLowercaseStringBytes) == Self.validUUID)
        #expect(try UUID(stringBytes: (Self.rawUUIDStringBytes as any BytesCollection)) == Self.validUUID)
        #expect(try UUID(stringBytes: [Self.rawUUIDStringBytes.prefix(18), Self.rawUUIDStringBytes.suffix(18)].joined()) == Self.validUUID)
        
        #expect(throws: BytesError.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 36, targetType: "UUID(Byte<8-4-4-4-12>)", actualSize: 35)) {
            try UUID(stringBytes: Self.rawUUIDStringBytes.dropLast(1))
        }
        #expect(throws: BytesError.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence) {
            try UUID(stringBytes: Self.invalidUUIDStringBytes)
        }
    }
    
    @Test func bytesFromUUIDCollection() async throws {
        #expect(Array(repeating: Self.validUUID, count: 5).bytes == Self.rawUUIDBytes + Self.rawUUIDBytes + Self.rawUUIDBytes + Self.rawUUIDBytes + Self.rawUUIDBytes)
    }
    
    @Test func uuidCollectionFromNonContiguousBytes() async throws {
        #expect(try [UUID](bytes: Array(repeating: Self.rawUUIDBytes, count: 5).joined()) == Array(repeating: Self.validUUID, count: 5))
        
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UUID(Byte<16>)<1>", actualSize: 15)) {
            try [UUID](bytes: (Self.rawUUIDBytes.dropLast(1) as any BytesCollection & Sendable))
        }
    }
    
    @Test func uuidCollectionFromContiguousBytes() async throws {
        #expect(try [UUID](bytes: Array(Array(repeating: Self.rawUUIDBytes, count: 5).joined())) == Array(repeating: Self.validUUID, count: 5))
        
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UUID(Byte<16>)<1>", actualSize: 15)) {
            try [UUID](bytes: Self.rawUUIDBytes.dropLast(1))
        }
    }
    
    @Test func stringBytesFromUUIDCollection() async throws {
        #expect(Array(repeating: Self.validUUID, count: 5).stringBytes == Self.rawUUIDStringBytes + Self.rawUUIDStringBytes + Self.rawUUIDStringBytes + Self.rawUUIDStringBytes + Self.rawUUIDStringBytes)
    }
    
    @Test func uuidCollectionFromStringBytes() async throws {
        #expect(try [UUID](stringBytes: Self.rawUUIDStringBytes + Self.rawUUIDStringBytes) == [Self.validUUID, Self.validUUID])
        #expect(try [UUID](stringBytes: Self.rawUUIDLowercaseStringBytes + Self.rawUUIDStringBytes) == [Self.validUUID, Self.validUUID])
        #expect(try [UUID](stringBytes: [Self.rawUUIDStringBytes, Self.rawUUIDStringBytes].joined()) == [Self.validUUID, Self.validUUID])
        
        #expect(throws: BytesError.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 36, targetType: "UUID(Byte<8-4-4-4-12>)<1>", actualSize: 35)) {
            try [UUID](stringBytes: Self.rawUUIDStringBytes.dropLast(1))
        }
        #expect(throws: BytesError.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence) {
            try [UUID](stringBytes: Self.rawUUIDStringBytes + Self.invalidUUIDStringBytes)
        }
    }
    
    @Test func uuidSetFromNonContiguousBytes() async throws {
        #expect(try Set<UUID>(bytes: Array(repeating: Self.rawUUIDBytes, count: 5).joined()) == [Self.validUUID])
        
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UUID(Byte<16>)<1>", actualSize: 15)) {
            try Set<UUID>(bytes: (Self.rawUUIDBytes.dropLast(1) as any BytesCollection & Sendable))
        }
    }
    
    @Test func uuidSetFromContiguousBytes() async throws {
        #expect(try Set<UUID>(bytes: Array(Array(repeating: Self.rawUUIDBytes, count: 5).joined())) == [Self.validUUID])
        
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UUID(Byte<16>)<1>", actualSize: 15)) {
            try Set<UUID>(bytes: Self.rawUUIDBytes.dropLast(1))
        }
    }
    
    @Test func uuidSetFromStringBytes() async throws {
        #expect(try Set<UUID>(stringBytes: Self.rawUUIDStringBytes + Self.rawUUIDStringBytes) == [Self.validUUID])
        #expect(try Set<UUID>(stringBytes: Self.rawUUIDLowercaseStringBytes + Self.rawUUIDStringBytes) == [Self.validUUID])
        #expect(try Set<UUID>(stringBytes: [Self.rawUUIDStringBytes, Self.rawUUIDStringBytes].joined()) == [Self.validUUID])
        
        #expect(throws: BytesError.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 36, targetType: "UUID(Byte<8-4-4-4-12>)<1>", actualSize: 35)) {
            try Set<UUID>(stringBytes: Self.rawUUIDStringBytes.dropLast(1))
        }
        #expect(throws: BytesError.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence) {
            try Set<UUID>(stringBytes: Self.rawUUIDStringBytes + Self.invalidUUIDStringBytes)
        }
    }
    
    @Suite struct UUIDByteIteratorTests {
        @Test func nextUUID() async throws {
            var iterator = UUIDTests.rawUUIDBytes.makeIterator()
            #expect(try iterator.next(UUID.self) == UUIDTests.validUUID)
            
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UUID(Byte<16>)", actualSize: 0)) {
                try iterator.next(UUID.self)
            }
        }
        
        @Test func nextStringUUID() async throws {
            var iterator = UUIDTests.rawUUIDStringBytes.makeIterator()
            #expect(try iterator.next(string: UUID.self) == UUIDTests.validUUID)
            
            #expect(throws: BytesError.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 36, targetType: "UUID(Byte<8-4-4-4-12>)", actualSize: 0)) {
                try iterator.next(string: UUID.self)
            }
            
            var invalidIterator = UUIDTests.invalidUUIDStringBytes.makeIterator()
            
            #expect(throws: BytesError.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence) {
                try invalidIterator.next(string: UUID.self)
            }
        }
        
        @Test func nextIfPresentUUID() async throws {
            var iterator = (UUIDTests.rawUUIDBytes + UUIDTests.rawUUIDBytes).dropLast().makeIterator()
            #expect(try iterator.nextIfPresent(UUID.self) == UUIDTests.validUUID)
            
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UUID(Byte<16>)", actualSize: 15)) {
                try iterator.nextIfPresent(UUID.self)
            }
            
            #expect(try iterator.nextIfPresent(UUID.self) == nil)
        }
        
        @Test func nextIfPresentStringUUID() async throws {
            var iterator = (UUIDTests.rawUUIDStringBytes + UUIDTests.rawUUIDStringBytes).dropLast().makeIterator()
            #expect(try iterator.nextIfPresent(string: UUID.self) == UUIDTests.validUUID)
            
            #expect(throws: BytesError.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 36, targetType: "UUID(Byte<8-4-4-4-12>)", actualSize: 35)) {
                try iterator.nextIfPresent(string: UUID.self)
            }
            
            #expect(try iterator.nextIfPresent(string: UUID.self) == nil)
            
            var invalidIterator = UUIDTests.invalidUUIDStringBytes.makeIterator()
            
            #expect(throws: BytesError.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence) {
                try invalidIterator.nextIfPresent(string: UUID.self)
            }
        }
        
        @Test func checkUUID() async throws {
            var iterator = (UUIDTests.rawUUIDBytes + UUIDTests.rawUUIDBytes).dropLast().makeIterator()
            try iterator.check(UUIDTests.validUUID)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(UUIDTests.validUUID)
            }
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(UUIDTests.validUUID)
            }
        }
        
        @Test func checkStringUUID() async throws {
            var iterator = (UUIDTests.rawUUIDStringBytes + UUIDTests.rawUUIDStringBytes).dropLast().makeIterator()
            try iterator.check(string: UUIDTests.validUUID)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(string: UUIDTests.validUUID)
            }
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(string: UUIDTests.validUUID)
            }
            
            var invalidIterator = UUIDTests.invalidUUIDStringBytes.makeIterator()
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try invalidIterator.check(string: UUIDTests.validUUID)
            }
        }
        
        @Test func checkIfPresentUUID() async throws {
            var iterator = (UUIDTests.rawUUIDBytes + UUIDTests.rawUUIDBytes).dropLast().makeIterator()
            #expect(try iterator.checkIfPresent(UUIDTests.validUUID) == true)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.checkIfPresent(UUIDTests.validUUID)
            }
            
            #expect(try iterator.checkIfPresent(UUIDTests.validUUID) == false)
        }
        
        @Test func checkIfPresentStringUUID() async throws {
            var iterator = (UUIDTests.rawUUIDStringBytes + UUIDTests.rawUUIDStringBytes).dropLast().makeIterator()
            #expect(try iterator.checkIfPresent(string: UUIDTests.validUUID) == true)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.checkIfPresent(string: UUIDTests.validUUID)
            }
            
            #expect(try iterator.checkIfPresent(string: UUIDTests.validUUID) == false)
            
            var invalidIterator = UUIDTests.invalidUUIDStringBytes.makeIterator()
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try invalidIterator.checkIfPresent(string: UUIDTests.validUUID)
            }
            
            var differentIterator = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee".utf8Bytes.makeIterator()
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try differentIterator.checkIfPresent(string: UUIDTests.validUUID)
            }
        }
    }
    
    #if canImport(Darwin)
    @Suite struct UUIDLegacyAsyncByteIteratorTests {
        @Test func nextUUID() async throws {
            var iterator = AsyncTestIterator(UUIDTests.rawUUIDBytes)
            #expect(try await iterator.next(UUID.self) == UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UUID(Byte<16>)", actualSize: 0)) {
                try await iterator.next(UUID.self)
            }
        }
        
        @Test func nextUUIDThrows() async throws {
            var iterator = AsyncThrowingTestIterator(UUIDTests.rawUUIDBytes)
            #expect(try await iterator.next(UUID.self) == UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(UUID.self)
            }
        }
        
        @Test func nextStringUUID() async throws {
            var iterator = AsyncTestIterator(UUIDTests.rawUUIDStringBytes)
            #expect(try await iterator.next(string: UUID.self) == UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<any Error>.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 36, targetType: "UUID(Byte<8-4-4-4-12>)", actualSize: 0)) {
                try await iterator.next(string: UUID.self)
            }
            
            var invalidIterator = AsyncTestIterator(UUIDTests.invalidUUIDStringBytes)
            
            await #expect(throws: BytesError.Iteration<any Error>.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence()) {
                try await invalidIterator.next(string: UUID.self)
            }
        }
        
        @Test func nextStringUUIDThrows() async throws {
            var iterator = AsyncThrowingTestIterator(UUIDTests.rawUUIDStringBytes)
            #expect(try await iterator.next(string: UUID.self) == UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<any Error>.UUIDDecoding.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(string: UUID.self)
            }
            
            var invalidIterator = AsyncThrowingTestIterator(UUIDTests.invalidUUIDStringBytes)
            
            await #expect(throws: BytesError.Iteration<any Error>.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence()) {
                try await invalidIterator.next(string: UUID.self)
            }
        }
        
        @Test func nextIfPresentUUID() async throws {
            var iterator = AsyncTestIterator(UUIDTests.rawUUIDBytes + UUIDTests.rawUUIDBytes.dropLast())
            #expect(try await iterator.nextIfPresent(UUID.self) == UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UUID(Byte<16>)", actualSize: 15)) {
                try await iterator.nextIfPresent(UUID.self)
            }
            
            #expect(try await iterator.nextIfPresent(UUID.self) == nil)
        }
        
        @Test func nextIfPresentUUIDThrows() async throws {
            var iterator = AsyncThrowingTestIterator(UUIDTests.rawUUIDBytes + UUIDTests.rawUUIDBytes.dropLast())
            #expect(try await iterator.nextIfPresent(UUID.self) == UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(UUID.self)
            }
            
            #expect(try await iterator.nextIfPresent(UUID.self) == nil)
        }
        
        @Test func nextIfPresentStringUUID() async throws {
            var iterator = AsyncTestIterator(UUIDTests.rawUUIDStringBytes + UUIDTests.rawUUIDStringBytes.dropLast())
            #expect(try await iterator.nextIfPresent(string: UUID.self) == UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<any Error>.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 36, targetType: "UUID(Byte<8-4-4-4-12>)", actualSize: 35)) {
                try await iterator.nextIfPresent(string: UUID.self)
            }
            
            #expect(try await iterator.nextIfPresent(string: UUID.self) == nil)
            
            var invalidIterator = AsyncTestIterator(UUIDTests.invalidUUIDStringBytes)
            
            await #expect(throws: BytesError.Iteration<any Error>.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence()) {
                try await invalidIterator.nextIfPresent(string: UUID.self)
            }
        }
        
        @Test func nextIfPresentStringUUIDThrows() async throws {
            var iterator = AsyncThrowingTestIterator(UUIDTests.rawUUIDStringBytes + UUIDTests.rawUUIDStringBytes.dropLast())
            #expect(try await iterator.nextIfPresent(string: UUID.self) == UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<any Error>.UUIDDecoding.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(string: UUID.self)
            }
            
            #expect(try await iterator.nextIfPresent(string: UUID.self) == nil)
            
            var invalidIterator = AsyncThrowingTestIterator(UUIDTests.invalidUUIDStringBytes)
            
            await #expect(throws: BytesError.Iteration<any Error>.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence()) {
                try await invalidIterator.nextIfPresent(string: UUID.self)
            }
        }
        
        @Test func checkUUID() async throws {
            var iterator = AsyncTestIterator(UUIDTests.rawUUIDBytes + UUIDTests.rawUUIDBytes.dropLast())
            try await iterator.check(UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(UUIDTests.validUUID)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(UUIDTests.validUUID)
            }
        }
        
        @Test func checkUUIDThrows() async throws {
            var iterator = AsyncThrowingTestIterator(UUIDTests.rawUUIDBytes + UUIDTests.rawUUIDBytes.dropLast())
            try await iterator.check(UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(UUIDTests.validUUID)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(UUIDTests.validUUID)
            }
        }
        
        @Test func checkStringUUID() async throws {
            var iterator = AsyncTestIterator(UUIDTests.rawUUIDStringBytes + UUIDTests.rawUUIDStringBytes.dropLast())
            try await iterator.check(string: UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(string: UUIDTests.validUUID)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(string: UUIDTests.validUUID)
            }
            
            var invalidIterator = AsyncTestIterator(UUIDTests.invalidUUIDStringBytes)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await invalidIterator.check(string: UUIDTests.validUUID)
            }
        }
        
        @Test func checkStringUUIDThrows() async throws {
            var iterator = AsyncThrowingTestIterator(UUIDTests.rawUUIDStringBytes + UUIDTests.rawUUIDStringBytes.dropLast())
            try await iterator.check(string: UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(string: UUIDTests.validUUID)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(string: UUIDTests.validUUID)
            }
            
            var invalidIterator = AsyncThrowingTestIterator(UUIDTests.invalidUUIDStringBytes)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await invalidIterator.check(string: UUIDTests.validUUID)
            }
        }
        
        @Test func checkIfPresentUUID() async throws {
            var iterator = AsyncTestIterator(UUIDTests.rawUUIDBytes + UUIDTests.rawUUIDBytes.dropLast())
            #expect(try await iterator.checkIfPresent(UUIDTests.validUUID) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(UUIDTests.validUUID)
            }
            
            #expect(try await iterator.checkIfPresent(string: UUIDTests.validUUID) == false)
        }
        
        @Test func checkIfPresentUUIDThrows() async throws {
            var iterator = AsyncThrowingTestIterator(UUIDTests.rawUUIDBytes + UUIDTests.rawUUIDBytes.dropLast())
            #expect(try await iterator.checkIfPresent(UUIDTests.validUUID) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(UUIDTests.validUUID)
            }
            
            #expect(try await iterator.checkIfPresent(UUIDTests.validUUID) == false)
        }
        
        @Test func checkIfPresentStringUUID() async throws {
            var iterator = AsyncTestIterator(UUIDTests.rawUUIDStringBytes + UUIDTests.rawUUIDStringBytes.dropLast())
            #expect(try await iterator.checkIfPresent(string: UUIDTests.validUUID) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(string: UUIDTests.validUUID)
            }
            
            #expect(try await iterator.checkIfPresent(string: UUIDTests.validUUID) == false)
            
            var invalidIterator = AsyncTestIterator(UUIDTests.invalidUUIDStringBytes)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await invalidIterator.checkIfPresent(string: UUIDTests.validUUID)
            }
            
            var differentIterator = AsyncTestIterator("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee".utf8Bytes)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await differentIterator.checkIfPresent(string: UUIDTests.validUUID)
            }
        }
        
        @Test func checkIfPresentStringUUIDThrows() async throws {
            var iterator = AsyncThrowingTestIterator(UUIDTests.rawUUIDStringBytes + UUIDTests.rawUUIDStringBytes.dropLast())
            #expect(try await iterator.checkIfPresent(string: UUIDTests.validUUID) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(string: UUIDTests.validUUID)
            }
            
            #expect(try await iterator.checkIfPresent(string: UUIDTests.validUUID) == false)
            
            var invalidIterator = AsyncThrowingTestIterator(UUIDTests.invalidUUIDStringBytes)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await invalidIterator.checkIfPresent(string: UUIDTests.validUUID)
            }
            
            var differentIterator = AsyncThrowingTestIterator("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee".utf8Bytes)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await differentIterator.checkIfPresent(string: UUIDTests.validUUID)
            }
        }
    }
    #endif
    
    @Suite struct UUIDAsyncByteIteratorTests {
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextUUID() async throws {
            var iterator = AsyncTestIterator(UUIDTests.rawUUIDBytes)
            #expect(try await iterator.next(UUID.self) == UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<Never>.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UUID(Byte<16>)", actualSize: 0)) {
                try await iterator.next(UUID.self)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextUUIDThrows() async throws {
            var iterator = AsyncThrowingTestIterator(UUIDTests.rawUUIDBytes)
            #expect(try await iterator.next(UUID.self) == UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<LocalError>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(UUID.self)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextStringUUID() async throws {
            var iterator = AsyncTestIterator(UUIDTests.rawUUIDStringBytes)
            #expect(try await iterator.next(string: UUID.self) == UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<Never>.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 36, targetType: "UUID(Byte<8-4-4-4-12>)", actualSize: 0)) {
                try await iterator.next(string: UUID.self)
            }
            
            var invalidIterator = AsyncTestIterator(UUIDTests.invalidUUIDStringBytes)
            
            await #expect(throws: BytesError.Iteration<Never>.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence()) {
                try await invalidIterator.next(string: UUID.self)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextStringUUIDThrows() async throws {
            var iterator = AsyncThrowingTestIterator(UUIDTests.rawUUIDStringBytes)
            #expect(try await iterator.next(string: UUID.self) == UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<LocalError>.UUIDDecoding.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(string: UUID.self)
            }
            
            var invalidIterator = AsyncThrowingTestIterator(UUIDTests.invalidUUIDStringBytes)
            
            await #expect(throws: BytesError.Iteration<LocalError>.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence()) {
                try await invalidIterator.next(string: UUID.self)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentUUID() async throws {
            var iterator = AsyncTestIterator(UUIDTests.rawUUIDBytes + UUIDTests.rawUUIDBytes.dropLast())
            #expect(try await iterator.nextIfPresent(UUID.self) == UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<Never>.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UUID(Byte<16>)", actualSize: 15)) {
                try await iterator.nextIfPresent(UUID.self)
            }
            
            #expect(try await iterator.nextIfPresent(UUID.self) == nil)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentUUIDThrows() async throws {
            var iterator = AsyncThrowingTestIterator(UUIDTests.rawUUIDBytes + UUIDTests.rawUUIDBytes.dropLast())
            #expect(try await iterator.nextIfPresent(UUID.self) == UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<LocalError>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(UUID.self)
            }
            
            #expect(try await iterator.nextIfPresent(UUID.self) == nil)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentStringUUID() async throws {
            var iterator = AsyncTestIterator(UUIDTests.rawUUIDStringBytes + UUIDTests.rawUUIDStringBytes.dropLast())
            #expect(try await iterator.nextIfPresent(string: UUID.self) == UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<Never>.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 36, targetType: "UUID(Byte<8-4-4-4-12>)", actualSize: 35)) {
                try await iterator.nextIfPresent(string: UUID.self)
            }
            
            #expect(try await iterator.nextIfPresent(string: UUID.self) == nil)
            
            var invalidIterator = AsyncTestIterator(UUIDTests.invalidUUIDStringBytes)
            
            await #expect(throws: BytesError.Iteration<Never>.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence()) {
                try await invalidIterator.nextIfPresent(string: UUID.self)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentStringUUIDThrows() async throws {
            var iterator = AsyncThrowingTestIterator(UUIDTests.rawUUIDStringBytes + UUIDTests.rawUUIDStringBytes.dropLast())
            #expect(try await iterator.nextIfPresent(string: UUID.self) == UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<LocalError>.UUIDDecoding.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(string: UUID.self)
            }
            
            #expect(try await iterator.nextIfPresent(string: UUID.self) == nil)
            
            var invalidIterator = AsyncThrowingTestIterator(UUIDTests.invalidUUIDStringBytes)
            
            await #expect(throws: BytesError.Iteration<LocalError>.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence()) {
                try await invalidIterator.nextIfPresent(string: UUID.self)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkUUID() async throws {
            var iterator = AsyncTestIterator(UUIDTests.rawUUIDBytes + UUIDTests.rawUUIDBytes.dropLast())
            try await iterator.check(UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(UUIDTests.validUUID)
            }
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(UUIDTests.validUUID)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkUUIDThrows() async throws {
            var iterator = AsyncThrowingTestIterator(UUIDTests.rawUUIDBytes + UUIDTests.rawUUIDBytes.dropLast())
            try await iterator.check(UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(UUIDTests.validUUID)
            }
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(UUIDTests.validUUID)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkStringUUID() async throws {
            var iterator = AsyncTestIterator(UUIDTests.rawUUIDStringBytes + UUIDTests.rawUUIDStringBytes.dropLast())
            try await iterator.check(string: UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(string: UUIDTests.validUUID)
            }
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(string: UUIDTests.validUUID)
            }
            
            var invalidIterator = AsyncTestIterator(UUIDTests.invalidUUIDStringBytes)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await invalidIterator.check(string: UUIDTests.validUUID)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkStringUUIDThrows() async throws {
            var iterator = AsyncThrowingTestIterator(UUIDTests.rawUUIDStringBytes + UUIDTests.rawUUIDStringBytes.dropLast())
            try await iterator.check(string: UUIDTests.validUUID)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(string: UUIDTests.validUUID)
            }
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(string: UUIDTests.validUUID)
            }
            
            var invalidIterator = AsyncThrowingTestIterator(UUIDTests.invalidUUIDStringBytes)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await invalidIterator.check(string: UUIDTests.validUUID)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentUUID() async throws {
            var iterator = AsyncTestIterator(UUIDTests.rawUUIDBytes + UUIDTests.rawUUIDBytes.dropLast())
            #expect(try await iterator.checkIfPresent(UUIDTests.validUUID) == true)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(UUIDTests.validUUID)
            }
            
            #expect(try await iterator.checkIfPresent(UUIDTests.validUUID) == false)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentUUIDThrows() async throws {
            var iterator = AsyncThrowingTestIterator(UUIDTests.rawUUIDBytes + UUIDTests.rawUUIDBytes.dropLast())
            #expect(try await iterator.checkIfPresent(UUIDTests.validUUID) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(UUIDTests.validUUID)
            }
            
            #expect(try await iterator.checkIfPresent(UUIDTests.validUUID) == false)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentStringUUID() async throws {
            var iterator = AsyncTestIterator(UUIDTests.rawUUIDStringBytes + UUIDTests.rawUUIDStringBytes.dropLast())
            #expect(try await iterator.checkIfPresent(string: UUIDTests.validUUID) == true)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(string: UUIDTests.validUUID)
            }
            
            #expect(try await iterator.checkIfPresent(string: UUIDTests.validUUID) == false)
            
            var invalidIterator = AsyncTestIterator(UUIDTests.invalidUUIDStringBytes)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await invalidIterator.checkIfPresent(string: UUIDTests.validUUID)
            }
            
            var differentIterator = AsyncTestIterator("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee".utf8Bytes)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await differentIterator.checkIfPresent(string: UUIDTests.validUUID)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentStringUUIDThrows() async throws {
            var iterator = AsyncThrowingTestIterator(UUIDTests.rawUUIDStringBytes + UUIDTests.rawUUIDStringBytes.dropLast())
            #expect(try await iterator.checkIfPresent(string: UUIDTests.validUUID) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(string: UUIDTests.validUUID)
            }
            
            #expect(try await iterator.checkIfPresent(string: UUIDTests.validUUID) == false)
            
            var invalidIterator = AsyncThrowingTestIterator(UUIDTests.invalidUUIDStringBytes)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await invalidIterator.checkIfPresent(string: UUIDTests.validUUID)
            }
            
            var differentIterator = AsyncThrowingTestIterator("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee".utf8Bytes)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await differentIterator.checkIfPresent(string: UUIDTests.validUUID)
            }
        }
    }
}
