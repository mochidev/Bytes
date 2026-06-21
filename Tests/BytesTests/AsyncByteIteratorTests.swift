//
//  AsyncByteIteratorTests.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 2026-05-24.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

import Bytes
import Testing

#if canImport(Darwin)
@Suite struct LegacyAsyncByteIteratorTests {
    @Test func nextCountInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, count: -1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, count: -1)
        }
    }
    
    @Test func nextCount() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.next(Bytes.self, count: 0) == [])
        #expect(try await iterator.next(Bytes.self, count: 1) == [0x00])
        #expect(try await iterator.next(Bytes.self, count: 2) == [0x01, 0x02])
        #expect(try await iterator.next(Bytes.self, count: 3) == [0x03, 0x04, 0x05])
        #expect(try await iterator.next(Bytes.self, count: 2) == [0x06, 0x07])
        
        await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "Byte", actualSize: 0)) {
            try await iterator.next(Bytes.self, count: 1)
        }
        
        #expect(try await iterator.next(Bytes.self, count: 0) == [])
    }
    
    @Test func nextCountThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.next(Bytes.self, count: 0) == [])
        #expect(try await iterator.next(Bytes.self, count: 1) == [0x00])
        #expect(try await iterator.next(Bytes.self, count: 2) == [0x01, 0x02])
        #expect(try await iterator.next(Bytes.self, count: 3) == [0x03, 0x04, 0x05])
        #expect(try await iterator.next(Bytes.self, count: 2) == [0x06, 0x07])
        
        await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.iterationFailure(LocalError())) {
            try await iterator.next(Bytes.self, count: 1)
        }
        
        #expect(try await iterator.next(Bytes.self, count: 0) == [])
    }
    
    @Test func nextMinMaxInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, min: -1, max: 1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, min: -1, max: -1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, min: 1, max: 0)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, min: -1, max: 1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, min: -1, max: -1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, min: 1, max: 0)
        }
    }
    
    @Test func nextMinMax() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await  iterator.next(Bytes.self, min: 0, max: 0) == [])
        #expect(try await  iterator.next(Bytes.self, min: 0, max: 1) == [0x00])
        #expect(try await  iterator.next(Bytes.self, min: 0, max: 2) == [0x01, 0x02])
        #expect(try await  iterator.next(Bytes.self, min: 0, max: 3) == [0x03, 0x04, 0x05])
        #expect(try await iterator.next(Bytes.self, min: 0, max: 3) == [0x06, 0x07])
        #expect(try await iterator.next(Bytes.self, min: 0, max: 3) == [])
        
        await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "Byte", actualSize: 0)) {
            try await iterator.next(Bytes.self, min: 1, max: 3)
        }
    }
    
    @Test func nextMinMaxThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await  iterator.next(Bytes.self, min: 0, max: 0) == [])
        #expect(try await  iterator.next(Bytes.self, min: 0, max: 1) == [0x00])
        #expect(try await  iterator.next(Bytes.self, min: 0, max: 2) == [0x01, 0x02])
        #expect(try await  iterator.next(Bytes.self, min: 0, max: 3) == [0x03, 0x04, 0x05])
        
        await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.iterationFailure(LocalError())) {
            try await iterator.next(Bytes.self, min: 0, max: 3)
        }
    }
    
    @Test func nextMaxInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = await iterator.next(Bytes.self, max: -1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, max: -1)
        }
    }
    
    @Test func nextMax() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(await iterator.next(Bytes.self, max: 0) == [])
        #expect(await iterator.next(Bytes.self, max: 1) == [0x00])
        #expect(await iterator.next(Bytes.self, max: 2) == [0x01, 0x02])
        #expect(await iterator.next(Bytes.self, max: 3) == [0x03, 0x04, 0x05])
        #expect(await iterator.next(Bytes.self, max: 3) == [0x06, 0x07])
        #expect(await iterator.next(Bytes.self, max: 3) == [])
    }
    
    @Test func nextMaxThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.next(Bytes.self, max: 0) == [])
        #expect(try await iterator.next(Bytes.self, max: 1) == [0x00])
        #expect(try await iterator.next(Bytes.self, max: 2) == [0x01, 0x02])
        #expect(try await iterator.next(Bytes.self, max: 3) == [0x03, 0x04, 0x05])
        
        await #expect(throws: LocalError()) {
            try await iterator.next(Bytes.self, max: 3)
        }
    }
    
    @Test func nextIfPresentCountInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, count: -1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, count: -1)
        }
    }
    
    @Test func nextIfPresentCount() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 0) == [])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 1) == [0x00])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 2) == [0x01, 0x02])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 3) == [0x03, 0x04, 0x05])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 2) == [0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 1) == nil)
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 2) == nil)
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 0) == [])
    }
    
    @Test func nextIfPresentCountCastingThrows() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 0) == [])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 1) == [0x00])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 2) == [0x01, 0x02])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 3) == [0x03, 0x04, 0x05])
        
        await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.invalidBufferSize(targetSize: 3, targetType: "Byte", actualSize: 2)) {
            try await iterator.nextIfPresent(Bytes.self, count: 3)
        }
        
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 1) == nil)
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 2) == nil)
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 0) == [])
    }
    
    @Test func nextIfPresentCountIteratorThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 0) == [])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 1) == [0x00])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 2) == [0x01, 0x02])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 3) == [0x03, 0x04, 0x05])
        
        await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.iterationFailure(LocalError())) {
            try await iterator.nextIfPresent(Bytes.self, count: 3)
        }
        
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 1) == nil)
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 2) == nil)
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 0) == [])
    }
    
    @Test func nextIfPresentMinMaxInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, min: -1, max: 1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, min: -1, max: -1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, min: 1, max: 0)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, min: -1, max: 1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, min: -1, max: -1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, min: 1, max: 0)
        }
    }
    
    @Test func nextIfPresentMinMax() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 0) == [])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 1) == [0x00])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 2) == [0x01, 0x02])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == [0x03, 0x04, 0x05])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == [0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == nil)
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 0) == [])
    }
    
    @Test func nextIfPresentMinMaxCastingThrows() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 0) == [])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 1) == [0x00])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 2) == [0x01, 0x02])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == [0x03, 0x04, 0x05])
        
        await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.invalidBufferSize(targetSize: 3, targetType: "Byte", actualSize: 2)) {
            try await iterator.nextIfPresent(Bytes.self, min: 3, max: 6)
        }
        
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == nil)
    }
    
    @Test func nextIfPresentMinMaxIteratorThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 0) == [])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 1) == [0x00])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 2) == [0x01, 0x02])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == [0x03, 0x04, 0x05])
        
        await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.iterationFailure(LocalError())) {
            try await iterator.nextIfPresent(Bytes.self, min: 3, max: 6)
        }
        
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == nil)
    }
    
    @Test func nextIfPresentMaxInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = await iterator.nextIfPresent(Bytes.self, max: -1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, max: -1)
        }
    }
    
    @Test func nextIfPresentMax() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(await iterator.nextIfPresent(Bytes.self, max: 0) == [])
        #expect(await iterator.nextIfPresent(Bytes.self, max: 1) == [0x00])
        #expect(await iterator.nextIfPresent(Bytes.self, max: 2) == [0x01, 0x02])
        #expect(await iterator.nextIfPresent(Bytes.self, max: 3) == [0x03, 0x04, 0x05])
        #expect(await iterator.nextIfPresent(Bytes.self, max: 3) == [0x06, 0x07])
        #expect(await iterator.nextIfPresent(Bytes.self, max: 0) == [])
        #expect(await iterator.nextIfPresent(Bytes.self, max: 3) == nil)
    }
    
    @Test func nextIfPresentMaxThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, max: 0) == [])
        #expect(try await iterator.nextIfPresent(Bytes.self, max: 1) == [0x00])
        #expect(try await iterator.nextIfPresent(Bytes.self, max: 2) == [0x01, 0x02])
        #expect(try await iterator.nextIfPresent(Bytes.self, max: 3) == [0x03, 0x04, 0x05])
        
        await #expect(throws: LocalError()) {
            try await iterator.nextIfPresent(Bytes.self, max: 3)
        }
    }
    
    @Test func checkByte() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        try await iterator.check(0x00)
        try await iterator.check(0x01)
        try await iterator.check(0x02)
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.check(0x04)
        }
        
        try await iterator.check(0x04)
        try await iterator.check(0x05)
        try await iterator.check(0x06)
        try await iterator.check(0x07)
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.check(0x08)
        }
    }
    
    @Test func checkByteThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        try await iterator.check(0x00)
        try await iterator.check(0x01)
        try await iterator.check(0x02)
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.check(0x04)
        }
        
        try await iterator.check(0x04)
        try await iterator.check(0x05)
        try await iterator.check(0x06)
        try await iterator.check(0x07)
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
            try await iterator.check(0x08)
        }
    }
    
    @Test func checkBytes() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        try await iterator.check([])
        try await iterator.check([0x00])
        try await iterator.check([0x01, 0x02])
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.check([0x03, 0x05])
        }
        
        try await iterator.check([0x05, 0x06])
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.check([0x07, 0x08])
        }
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.check([0x09])
        }
        
        try await iterator.check([])
    }
    
    @Test func checkBytesThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        try await iterator.check([])
        try await iterator.check([0x00])
        try await iterator.check([0x01, 0x02])
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.check([0x03, 0x05])
        }
        
        try await iterator.check([0x05, 0x06])
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
            try await iterator.check([0x07, 0x08])
        }
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.check([0x09])
        }
        
        try await iterator.check([])
    }
    
    @Test func checkByteIfPresent() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.checkIfPresent(0x00) == true)
        #expect(try await iterator.checkIfPresent(0x01) == true)
        #expect(try await iterator.checkIfPresent(0x02) == true)
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.checkIfPresent(0x04)
        }
        
        #expect(try await iterator.checkIfPresent(0x04) == true)
        #expect(try await iterator.checkIfPresent(0x05) == true)
        #expect(try await iterator.checkIfPresent(0x06) == true)
        #expect(try await iterator.checkIfPresent(0x07) == true)
        #expect(try await iterator.checkIfPresent(0x08) == false)
    }
    
    @Test func checkByteIfPresentThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.checkIfPresent(0x00) == true)
        #expect(try await iterator.checkIfPresent(0x01) == true)
        #expect(try await iterator.checkIfPresent(0x02) == true)
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.checkIfPresent(0x04)
        }
        
        #expect(try await iterator.checkIfPresent(0x04) == true)
        #expect(try await iterator.checkIfPresent(0x05) == true)
        #expect(try await iterator.checkIfPresent(0x06) == true)
        #expect(try await iterator.checkIfPresent(0x07) == true)
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
            try await iterator.checkIfPresent(0x08)
        }
        
        #expect(try await iterator.checkIfPresent(0x08) == false)
    }
    
    @Test func checkBytesIfPresent() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.checkIfPresent([]) == true)
        #expect(try await iterator.checkIfPresent([0x00]) == true)
        #expect(try await iterator.checkIfPresent([0x01, 0x02]) == true)
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.checkIfPresent([0x03, 0x05])
        }
        
        #expect(try await iterator.checkIfPresent([0x05, 0x06]) == true)
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.checkIfPresent([0x07, 0x08])
        }
        
        #expect(try await iterator.checkIfPresent([0x09]) == false)
        #expect(try await iterator.checkIfPresent([]) == true)
    }
    
    @Test func checkBytesIfPresentThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.checkIfPresent([]) == true)
        #expect(try await iterator.checkIfPresent([0x00]) == true)
        #expect(try await iterator.checkIfPresent([0x01, 0x02]) == true)
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.checkIfPresent([0x03, 0x05])
        }
        
        #expect(try await iterator.checkIfPresent([0x05, 0x06]) == true)
        
        await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
            try await iterator.checkIfPresent([0x07, 0x08])
        }
        
        #expect(try await iterator.checkIfPresent([0x09]) == false)
        #expect(try await iterator.checkIfPresent([]) == true)
    }
}
#endif

@Suite struct AsyncByteIteratorTests {
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextCountInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, count: -1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, count: -1)
        }
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextCount() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.next(Bytes.self, count: 0) == [])
        #expect(try await iterator.next(Bytes.self, count: 1) == [0x00])
        #expect(try await iterator.next(Bytes.self, count: 2) == [0x01, 0x02])
        #expect(try await iterator.next(Bytes.self, count: 3) == [0x03, 0x04, 0x05])
        #expect(try await iterator.next(Bytes.self, count: 2) == [0x06, 0x07])
        
        await #expect(throws: BytesError.Iteration<Never>.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "Byte", actualSize: 0)) {
            try await iterator.next(Bytes.self, count: 1)
        }
        
        #expect(try await iterator.next(Bytes.self, count: 0) == [])
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextCountThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.next(Bytes.self, count: 0) == [])
        #expect(try await iterator.next(Bytes.self, count: 1) == [0x00])
        #expect(try await iterator.next(Bytes.self, count: 2) == [0x01, 0x02])
        #expect(try await iterator.next(Bytes.self, count: 3) == [0x03, 0x04, 0x05])
        #expect(try await iterator.next(Bytes.self, count: 2) == [0x06, 0x07])
        
        await #expect(throws: BytesError.Iteration<LocalError>.BufferSizeError.iterationFailure(LocalError())) {
            try await iterator.next(Bytes.self, count: 1)
        }
        
        #expect(try await iterator.next(Bytes.self, count: 0) == [])
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextMinMaxInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, min: -1, max: 1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, min: -1, max: -1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, min: 1, max: 0)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, min: -1, max: 1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, min: -1, max: -1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, min: 1, max: 0)
        }
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextMinMax() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await  iterator.next(Bytes.self, min: 0, max: 0) == [])
        #expect(try await  iterator.next(Bytes.self, min: 0, max: 1) == [0x00])
        #expect(try await  iterator.next(Bytes.self, min: 0, max: 2) == [0x01, 0x02])
        #expect(try await  iterator.next(Bytes.self, min: 0, max: 3) == [0x03, 0x04, 0x05])
        #expect(try await iterator.next(Bytes.self, min: 0, max: 3) == [0x06, 0x07])
        #expect(try await iterator.next(Bytes.self, min: 0, max: 3) == [])
        
        await #expect(throws: BytesError.Iteration<Never>.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "Byte", actualSize: 0)) {
            try await iterator.next(Bytes.self, min: 1, max: 3)
        }
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextMinMaxThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await  iterator.next(Bytes.self, min: 0, max: 0) == [])
        #expect(try await  iterator.next(Bytes.self, min: 0, max: 1) == [0x00])
        #expect(try await  iterator.next(Bytes.self, min: 0, max: 2) == [0x01, 0x02])
        #expect(try await  iterator.next(Bytes.self, min: 0, max: 3) == [0x03, 0x04, 0x05])
        
        await #expect(throws: BytesError.Iteration<LocalError>.BufferSizeError.iterationFailure(LocalError())) {
            try await iterator.next(Bytes.self, min: 0, max: 3)
        }
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextMaxInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = await iterator.next(Bytes.self, max: -1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.next(Bytes.self, max: -1)
        }
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextMax() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(await iterator.next(Bytes.self, max: 0) == [])
        #expect(await iterator.next(Bytes.self, max: 1) == [0x00])
        #expect(await iterator.next(Bytes.self, max: 2) == [0x01, 0x02])
        #expect(await iterator.next(Bytes.self, max: 3) == [0x03, 0x04, 0x05])
        #expect(await iterator.next(Bytes.self, max: 3) == [0x06, 0x07])
        #expect(await iterator.next(Bytes.self, max: 3) == [])
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextMaxThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.next(Bytes.self, max: 0) == [])
        #expect(try await iterator.next(Bytes.self, max: 1) == [0x00])
        #expect(try await iterator.next(Bytes.self, max: 2) == [0x01, 0x02])
        #expect(try await iterator.next(Bytes.self, max: 3) == [0x03, 0x04, 0x05])
        
        await #expect(throws: LocalError()) {
            try await iterator.next(Bytes.self, max: 3)
        }
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextIfPresentCountInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, count: -1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, count: -1)
        }
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextIfPresentCount() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 0) == [])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 1) == [0x00])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 2) == [0x01, 0x02])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 3) == [0x03, 0x04, 0x05])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 2) == [0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 1) == nil)
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 2) == nil)
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 0) == [])
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextIfPresentCountCastingThrows() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 0) == [])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 1) == [0x00])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 2) == [0x01, 0x02])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 3) == [0x03, 0x04, 0x05])
        
        await #expect(throws: BytesError.Iteration<Never>.BufferSizeError.invalidBufferSize(targetSize: 3, targetType: "Byte", actualSize: 2)) {
            try await iterator.nextIfPresent(Bytes.self, count: 3)
        }
        
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 1) == nil)
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 2) == nil)
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 0) == [])
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextIfPresentCountIteratorThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 0) == [])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 1) == [0x00])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 2) == [0x01, 0x02])
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 3) == [0x03, 0x04, 0x05])
        
        await #expect(throws: BytesError.Iteration<LocalError>.BufferSizeError.iterationFailure(LocalError())) {
            try await iterator.nextIfPresent(Bytes.self, count: 3)
        }
        
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 1) == nil)
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 2) == nil)
        #expect(try await iterator.nextIfPresent(Bytes.self, count: 0) == [])
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextIfPresentMinMaxInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, min: -1, max: 1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, min: -1, max: -1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, min: 1, max: 0)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, min: -1, max: 1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, min: -1, max: -1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, min: 1, max: 0)
        }
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextIfPresentMinMax() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 0) == [])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 1) == [0x00])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 2) == [0x01, 0x02])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == [0x03, 0x04, 0x05])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == [0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == nil)
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 0) == [])
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextIfPresentMinMaxCastingThrows() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 0) == [])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 1) == [0x00])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 2) == [0x01, 0x02])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == [0x03, 0x04, 0x05])
        
        await #expect(throws: BytesError.Iteration<Never>.BufferSizeError.invalidBufferSize(targetSize: 3, targetType: "Byte", actualSize: 2)) {
            try await iterator.nextIfPresent(Bytes.self, min: 3, max: 6)
        }
        
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == nil)
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextIfPresentMinMaxIteratorThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 0) == [])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 1) == [0x00])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 2) == [0x01, 0x02])
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == [0x03, 0x04, 0x05])
        
        await #expect(throws: BytesError.Iteration<LocalError>.BufferSizeError.iterationFailure(LocalError())) {
            try await iterator.nextIfPresent(Bytes.self, min: 3, max: 6)
        }
        
        #expect(try await iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == nil)
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextIfPresentMaxInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = await iterator.nextIfPresent(Bytes.self, max: -1)
        }
        await #expect(processExitsWith: .failure) {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            _ = try await iterator.nextIfPresent(Bytes.self, max: -1)
        }
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextIfPresentMax() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(await iterator.nextIfPresent(Bytes.self, max: 0) == [])
        #expect(await iterator.nextIfPresent(Bytes.self, max: 1) == [0x00])
        #expect(await iterator.nextIfPresent(Bytes.self, max: 2) == [0x01, 0x02])
        #expect(await iterator.nextIfPresent(Bytes.self, max: 3) == [0x03, 0x04, 0x05])
        #expect(await iterator.nextIfPresent(Bytes.self, max: 3) == [0x06, 0x07])
        #expect(await iterator.nextIfPresent(Bytes.self, max: 0) == [])
        #expect(await iterator.nextIfPresent(Bytes.self, max: 3) == nil)
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func nextIfPresentMaxThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.nextIfPresent(Bytes.self, max: 0) == [])
        #expect(try await iterator.nextIfPresent(Bytes.self, max: 1) == [0x00])
        #expect(try await iterator.nextIfPresent(Bytes.self, max: 2) == [0x01, 0x02])
        #expect(try await iterator.nextIfPresent(Bytes.self, max: 3) == [0x03, 0x04, 0x05])
        
        await #expect(throws: LocalError()) {
            try await iterator.nextIfPresent(Bytes.self, max: 3)
        }
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func checkByte() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        try await iterator.check(0x00)
        try await iterator.check(0x01)
        try await iterator.check(0x02)
        
        await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.check(0x04)
        }
        
        try await iterator.check(0x04)
        try await iterator.check(0x05)
        try await iterator.check(0x06)
        try await iterator.check(0x07)
        
        await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.check(0x08)
        }
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func checkByteThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        try await iterator.check(0x00)
        try await iterator.check(0x01)
        try await iterator.check(0x02)
        
        await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.check(0x04)
        }
        
        try await iterator.check(0x04)
        try await iterator.check(0x05)
        try await iterator.check(0x06)
        try await iterator.check(0x07)
        
        await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
            try await iterator.check(0x08)
        }
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func checkBytes() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        try await iterator.check([])
        try await iterator.check([0x00])
        try await iterator.check([0x01, 0x02])
        
        await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.check([0x03, 0x05])
        }
        
        try await iterator.check([0x05, 0x06])
        
        await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.check([0x07, 0x08])
        }
        
        await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.check([0x09])
        }
        
        try await iterator.check([])
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func checkBytesThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        try await iterator.check([])
        try await iterator.check([0x00])
        try await iterator.check([0x01, 0x02])
        
        await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.check([0x03, 0x05])
        }
        
        try await iterator.check([0x05, 0x06])
        
        await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
            try await iterator.check([0x07, 0x08])
        }
        
        await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.check([0x09])
        }
        
        try await iterator.check([])
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func checkByteIfPresent() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.checkIfPresent(0x00) == true)
        #expect(try await iterator.checkIfPresent(0x01) == true)
        #expect(try await iterator.checkIfPresent(0x02) == true)
        
        await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.checkIfPresent(0x04)
        }
        
        #expect(try await iterator.checkIfPresent(0x04) == true)
        #expect(try await iterator.checkIfPresent(0x05) == true)
        #expect(try await iterator.checkIfPresent(0x06) == true)
        #expect(try await iterator.checkIfPresent(0x07) == true)
        #expect(try await iterator.checkIfPresent(0x08) == false)
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func checkByteIfPresentThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.checkIfPresent(0x00) == true)
        #expect(try await iterator.checkIfPresent(0x01) == true)
        #expect(try await iterator.checkIfPresent(0x02) == true)
        
        await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.checkIfPresent(0x04)
        }
        
        #expect(try await iterator.checkIfPresent(0x04) == true)
        #expect(try await iterator.checkIfPresent(0x05) == true)
        #expect(try await iterator.checkIfPresent(0x06) == true)
        #expect(try await iterator.checkIfPresent(0x07) == true)
        
        await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
            try await iterator.checkIfPresent(0x08)
        }
        
        #expect(try await iterator.checkIfPresent(0x08) == false)
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func checkBytesIfPresent() async throws {
        var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.checkIfPresent([]) == true)
        #expect(try await iterator.checkIfPresent([0x00]) == true)
        #expect(try await iterator.checkIfPresent([0x01, 0x02]) == true)
        
        await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.checkIfPresent([0x03, 0x05])
        }
        
        #expect(try await iterator.checkIfPresent([0x05, 0x06]) == true)
        
        await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.checkIfPresent([0x07, 0x08])
        }
        
        #expect(try await iterator.checkIfPresent([0x09]) == false)
        #expect(try await iterator.checkIfPresent([]) == true)
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func checkBytesIfPresentThrows() async throws {
        var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        #expect(try await iterator.checkIfPresent([]) == true)
        #expect(try await iterator.checkIfPresent([0x00]) == true)
        #expect(try await iterator.checkIfPresent([0x01, 0x02]) == true)
        
        await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
            try await iterator.checkIfPresent([0x03, 0x05])
        }
        
        #expect(try await iterator.checkIfPresent([0x05, 0x06]) == true)
        
        await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
            try await iterator.checkIfPresent([0x07, 0x08])
        }
        
        #expect(try await iterator.checkIfPresent([0x09]) == false)
        #expect(try await iterator.checkIfPresent([]) == true)
    }
}
