//
//  ByteIteratorTests.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 2026-05-24.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

import Bytes
import Testing

@Suite struct ByteIteratorTests {
    let bytes: Bytes = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
    
    @Test func nextCountInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            let bytes: Bytes = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
            var iterator = bytes.makeIterator()
            _ = try iterator.next(Bytes.self, count: -1)
        }
    }
    
    @Test func nextCount() async throws {
        var iterator = bytes.makeIterator()
        #expect(try iterator.next(Bytes.self, count: 0) == [])
        #expect(try iterator.next(Bytes.self, count: 1) == [0x00])
        #expect(try iterator.next(Bytes.self, count: 2) == [0x01, 0x02])
        #expect(try iterator.next(Bytes.self, count: 3) == [0x03, 0x04, 0x05])
        #expect(try iterator.next(Bytes.self, count: 2) == [0x06, 0x07])
        
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "Byte", actualSize: 0)) {
            try iterator.next(Bytes.self, count: 1)
        }
        
        #expect(try iterator.next(Bytes.self, count: 0) == [])
    }
    
    @Test func nextMinMaxInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            let bytes: Bytes = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
            var iterator = bytes.makeIterator()
            _ = try iterator.next(Bytes.self, min: -1, max: 1)
        }
        await #expect(processExitsWith: .failure) {
            let bytes: Bytes = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
            var iterator = bytes.makeIterator()
            _ = try iterator.next(Bytes.self, min: -1, max: -1)
        }
        await #expect(processExitsWith: .failure) {
            let bytes: Bytes = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
            var iterator = bytes.makeIterator()
            _ = try iterator.next(Bytes.self, min: 1, max: 0)
        }
    }
    
    @Test func nextMinMax() async throws {
        var iterator = bytes.makeIterator()
        #expect(try iterator.next(Bytes.self, min: 0, max: 0) == [])
        #expect(try iterator.next(Bytes.self, min: 0, max: 1) == [0x00])
        #expect(try iterator.next(Bytes.self, min: 0, max: 2) == [0x01, 0x02])
        #expect(try iterator.next(Bytes.self, min: 0, max: 3) == [0x03, 0x04, 0x05])
        #expect(try iterator.next(Bytes.self, min: 0, max: 3) == [0x06, 0x07])
        #expect(try iterator.next(Bytes.self, min: 0, max: 3) == [])
        
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "Byte", actualSize: 0)) {
            try iterator.next(Bytes.self, min: 1, max: 3)
        }
    }
    
    @Test func nextMaxInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            let bytes: Bytes = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
            var iterator = bytes.makeIterator()
            _ = iterator.next(Bytes.self, max: -1)
        }
    }
    
    @Test func nextMax() async throws {
        var iterator = bytes.makeIterator()
        #expect(iterator.next(Bytes.self, max: 0) == [])
        #expect(iterator.next(Bytes.self, max: 1) == [0x00])
        #expect(iterator.next(Bytes.self, max: 2) == [0x01, 0x02])
        #expect(iterator.next(Bytes.self, max: 3) == [0x03, 0x04, 0x05])
        #expect(iterator.next(Bytes.self, max: 3) == [0x06, 0x07])
        #expect(iterator.next(Bytes.self, max: 3) == [])
    }
    
    @Test func nextIfPresentCountInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            let bytes: Bytes = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
            var iterator = bytes.makeIterator()
            _ = try iterator.nextIfPresent(Bytes.self, count: -1)
        }
    }
    
    @Test func nextIfPresentCount() async throws {
        var iterator = bytes.makeIterator()
        #expect(try iterator.nextIfPresent(Bytes.self, count: 0) == [])
        #expect(try iterator.nextIfPresent(Bytes.self, count: 1) == [0x00])
        #expect(try iterator.nextIfPresent(Bytes.self, count: 2) == [0x01, 0x02])
        #expect(try iterator.nextIfPresent(Bytes.self, count: 3) == [0x03, 0x04, 0x05])
        #expect(try iterator.nextIfPresent(Bytes.self, count: 2) == [0x06, 0x07])
        #expect(try iterator.nextIfPresent(Bytes.self, count: 1) == nil)
        #expect(try iterator.nextIfPresent(Bytes.self, count: 2) == nil)
        #expect(try iterator.nextIfPresent(Bytes.self, count: 0) == [])
    }
    
    @Test func nextIfPresentCountThrows() async throws {
        var iterator = bytes.makeIterator()
        #expect(try iterator.nextIfPresent(Bytes.self, count: 0) == [])
        #expect(try iterator.nextIfPresent(Bytes.self, count: 1) == [0x00])
        #expect(try iterator.nextIfPresent(Bytes.self, count: 2) == [0x01, 0x02])
        #expect(try iterator.nextIfPresent(Bytes.self, count: 3) == [0x03, 0x04, 0x05])
        
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 3, targetType: "Byte", actualSize: 2)) {
            try iterator.nextIfPresent(Bytes.self, count: 3)
        }
        
        #expect(try iterator.nextIfPresent(Bytes.self, count: 1) == nil)
        #expect(try iterator.nextIfPresent(Bytes.self, count: 2) == nil)
        #expect(try iterator.nextIfPresent(Bytes.self, count: 0) == [])
    }
    
    @Test func nextIfPresentMinMaxInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            let bytes: Bytes = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
            var iterator = bytes.makeIterator()
            _ = try iterator.nextIfPresent(Bytes.self, min: -1, max: 1)
        }
        await #expect(processExitsWith: .failure) {
            let bytes: Bytes = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
            var iterator = bytes.makeIterator()
            _ = try iterator.nextIfPresent(Bytes.self, min: -1, max: -1)
        }
        await #expect(processExitsWith: .failure) {
            let bytes: Bytes = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
            var iterator = bytes.makeIterator()
            _ = try iterator.nextIfPresent(Bytes.self, min: 1, max: 0)
        }
    }
    
    @Test func nextIfPresentMinMax() async throws {
        var iterator = bytes.makeIterator()
        #expect(try iterator.nextIfPresent(Bytes.self, min: 0, max: 0) == [])
        #expect(try iterator.nextIfPresent(Bytes.self, min: 0, max: 1) == [0x00])
        #expect(try iterator.nextIfPresent(Bytes.self, min: 0, max: 2) == [0x01, 0x02])
        #expect(try iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == [0x03, 0x04, 0x05])
        #expect(try iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == [0x06, 0x07])
        #expect(try iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == nil)
        #expect(try iterator.nextIfPresent(Bytes.self, min: 0, max: 0) == [])
    }
    
    @Test func nextIfPresentMinMaxThrows() async throws {
        var iterator = bytes.makeIterator()
        #expect(try iterator.nextIfPresent(Bytes.self, min: 0, max: 0) == [])
        #expect(try iterator.nextIfPresent(Bytes.self, min: 0, max: 1) == [0x00])
        #expect(try iterator.nextIfPresent(Bytes.self, min: 0, max: 2) == [0x01, 0x02])
        #expect(try iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == [0x03, 0x04, 0x05])
        
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 3, targetType: "Byte", actualSize: 2)) {
            try iterator.nextIfPresent(Bytes.self, min: 3, max: 6)
        }
        
        #expect(try iterator.nextIfPresent(Bytes.self, min: 0, max: 3) == nil)
    }

    @Test func nextIfPresentMaxInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            let bytes: Bytes = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
            var iterator = bytes.makeIterator()
            _ = iterator.nextIfPresent(Bytes.self, max: -1)
        }
    }
    
    @Test func nextIfPresentMax() async throws {
        var iterator = bytes.makeIterator()
        #expect(iterator.nextIfPresent(Bytes.self, max: 0) == [])
        #expect(iterator.nextIfPresent(Bytes.self, max: 1) == [0x00])
        #expect(iterator.nextIfPresent(Bytes.self, max: 2) == [0x01, 0x02])
        #expect(iterator.nextIfPresent(Bytes.self, max: 3) == [0x03, 0x04, 0x05])
        #expect(iterator.nextIfPresent(Bytes.self, max: 3) == [0x06, 0x07])
        #expect(iterator.nextIfPresent(Bytes.self, max: 0) == [])
        #expect(iterator.nextIfPresent(Bytes.self, max: 3) == nil)
    }
    
    @Test func checkByte() async throws {
        var iterator = bytes.makeIterator()
        try iterator.check(0x00)
        try iterator.check(0x01)
        try iterator.check(0x02)
        
        #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
            try iterator.check(0x04)
        }
        
        try iterator.check(0x04)
        try iterator.check(0x05)
        try iterator.check(0x06)
        try iterator.check(0x07)
        
        #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
            try iterator.check(0x08)
        }
    }
    
    @Test func checkBytes() async throws {
        var iterator = bytes.makeIterator()
        try iterator.check([])
        try iterator.check([0x00])
        try iterator.check([0x01, 0x02])
        
        #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
            try iterator.check([0x03, 0x05])
        }
        
        try iterator.check([0x05, 0x06])
        
        #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
            try iterator.check([0x07, 0x08])
        }
        
        #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
            try iterator.check([0x09])
        }
        
        try iterator.check([])
    }
    
    @Test func checkByteIfPresent() async throws {
        var iterator = bytes.makeIterator()
        #expect(try iterator.checkIfPresent(0x00) == true)
        #expect(try iterator.checkIfPresent(0x01) == true)
        #expect(try iterator.checkIfPresent(0x02) == true)
        
        #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
            try iterator.checkIfPresent(0x04)
        }
        
        #expect(try iterator.checkIfPresent(0x04) == true)
        #expect(try iterator.checkIfPresent(0x05) == true)
        #expect(try iterator.checkIfPresent(0x06) == true)
        #expect(try iterator.checkIfPresent(0x07) == true)
        #expect(try iterator.checkIfPresent(0x08) == false)
    }
    
    @Test func checkBytesIfPresent() async throws {
        var iterator = bytes.makeIterator()
        #expect(try iterator.checkIfPresent([]) == true)
        #expect(try iterator.checkIfPresent([0x00]) == true)
        #expect(try iterator.checkIfPresent([0x01, 0x02]) == true)
        
        #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
            try iterator.checkIfPresent([0x03, 0x05])
        }
        
        #expect(try iterator.checkIfPresent([0x05, 0x06]) == true)
        
        #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
            try iterator.checkIfPresent([0x07, 0x08])
        }
        
        #expect(try iterator.checkIfPresent([0x09]) == false)
        #expect(try iterator.checkIfPresent([]) == true)
    }
}
