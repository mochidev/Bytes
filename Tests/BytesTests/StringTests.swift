//
//  StringTests.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 2020-11-07.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

import Bytes
import Testing

@Suite struct StringTests {
    @Test func utf8BytesFromString() async throws {
        #expect("".utf8Bytes == [])
        #expect("Hello, World!".utf8Bytes == [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
        #expect("👋👋🏻👋🏼👋🏽👋🏾👋🏿, 🌍🌏🌎".utf8Bytes == [240, 159, 145, 139, 240, 159, 145, 139, 240, 159, 143, 187, 240, 159, 145, 139, 240, 159, 143, 188, 240, 159, 145, 139, 240, 159, 143, 189, 240, 159, 145, 139, 240, 159, 143, 190, 240, 159, 145, 139, 240, 159, 143, 191, 44, 32, 240, 159, 140, 141, 240, 159, 140, 143, 240, 159, 140, 142])
        #expect("\0\0\0".utf8Bytes == [0, 0, 0])
        #expect("Hello, World!".prefix(5).utf8Bytes == [72, 101, 108, 108, 111])
    }
    
    @Test func stringFromUTF8Bytes() async throws {
        #expect(String(utf8Bytes: []) == "")
        #expect(String(utf8Bytes: [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]) == "Hello, World!")
        #expect(String(utf8Bytes: [240, 159, 145, 139, 240, 159, 145, 139, 240, 159, 143, 187, 240, 159, 145, 139, 240, 159, 143, 188, 240, 159, 145, 139, 240, 159, 143, 189, 240, 159, 145, 139, 240, 159, 143, 190, 240, 159, 145, 139, 240, 159, 143, 191, 44, 32, 240, 159, 140, 141, 240, 159, 140, 143, 240, 159, 140, 142]) == "👋👋🏻👋🏼👋🏽👋🏾👋🏿, 🌍🌏🌎")
        #expect(String(utf8Bytes: [0, 0, 0]) == "\0\0\0")
        #expect(String(utf8Bytes: [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33][..<5]) == "Hello")
    }
    
    @Test func utf8BytesFromCharacter() async throws {
        #expect((" " as Character).utf8Bytes == [32])
        #expect(("𒐫" as Character).utf8Bytes == [240, 146, 144, 171])
        #expect(("👨‍👩‍👧‍👦" as Character).utf8Bytes == [240, 159, 145, 168, 226, 128, 141, 240, 159, 145, 169, 226, 128, 141, 240, 159, 145, 167, 226, 128, 141, 240, 159, 145, 166])
    }
    
    @Test func characterFromUTF8Bytes() async throws {
        #expect(try Character(utf8Bytes: [32]) == " ")
        #expect(try Character(utf8Bytes: [240, 146, 144, 171]) == "𒐫")
        #expect(try Character(utf8Bytes: [240, 159, 145, 168, 226, 128, 141, 240, 159, 145, 169, 226, 128, 141, 240, 159, 145, 167, 226, 128, 141, 240, 159, 145, 166]) == "👨‍👩‍👧‍👦")
        
        #expect(throws: BytesError.CharacterDecodingError.invalidCharacterByteSequence) {
            try Character(utf8Bytes: [])
        }
        
        #expect(throws: BytesError.CharacterDecodingError.invalidCharacterByteSequence) {
            try Character(utf8Bytes: [32, 32])
        }
    }
    
    @Suite struct StringByteIteratorTests {
        @Test func nextUTF8StringCountInvalidInput() async throws {
            await #expect(processExitsWith: .failure) {
                let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
                var iterator = bytes.makeIterator()
                _ = try iterator.next(utf8: String.self, count: -1)
            }
        }
        
        @Test func nextUTF8StringCount() async throws {
            let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
            var iterator = bytes.makeIterator()
            #expect(try iterator.next(utf8: String.self, count: 0) == "")
            #expect(try iterator.next(utf8: String.self, count: 5) == "Hello")
            #expect(try iterator.next(utf8: String.self, count: 2) == ", ")
            #expect(try iterator.next(utf8: String.self, count: 5) == "World")
            
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try iterator.next(utf8: String.self, count: 2)
            }
        }
        
        @Test func nextUTF8StringMinMaxInvalidInput() async throws {
            await #expect(processExitsWith: .failure) {
                let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
                var iterator = bytes.makeIterator()
                _ = try iterator.next(utf8: String.self, min: -1, max: 1)
            }
            await #expect(processExitsWith: .failure) {
                let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
                var iterator = bytes.makeIterator()
                _ = try iterator.next(utf8: String.self, min: -1, max: -1)
            }
            await #expect(processExitsWith: .failure) {
                let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
                var iterator = bytes.makeIterator()
                _ = try iterator.next(utf8: String.self, min: 1, max: 0)
            }
        }
        
        @Test func nextUTF8StringMinMax() async throws {
            let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
            var iterator = bytes.makeIterator()
            #expect(try iterator.next(utf8: String.self, min: 0, max: 0) == "")
            #expect(try iterator.next(utf8: String.self, min: 0, max: 5) == "Hello")
            #expect(try iterator.next(utf8: String.self, min: 0, max: 2) == ", ")
            #expect(try iterator.next(utf8: String.self, min: 0, max: 6) == "World!")
            #expect(try iterator.next(utf8: String.self, min: 0, max: 5) == "")
            
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "Bytes", actualSize: 0)) {
                try iterator.next(utf8: String.self, min: 1, max: 3)
            }
        }
        
        @Test func nextIfPresentUTF8StringCountInvalidInput() async throws {
            await #expect(processExitsWith: .failure) {
                let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
                var iterator = bytes.makeIterator()
                _ = try iterator.nextIfPresent(utf8: String.self, count: -1)
            }
        }
        
        @Test func nextIfPresentUTF8StringCount() async throws {
            let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
            var iterator = bytes.makeIterator()
            #expect(try iterator.nextIfPresent(utf8: String.self, count: 0) == "")
            #expect(try iterator.nextIfPresent(utf8: String.self, count: 5) == "Hello")
            #expect(try iterator.nextIfPresent(utf8: String.self, count: 2) == ", ")
            #expect(try iterator.nextIfPresent(utf8: String.self, count: 6) == "World!")
            #expect(try iterator.nextIfPresent(utf8: String.self, count: 1) == nil)
            #expect(try iterator.nextIfPresent(utf8: String.self, count: 2) == nil)
            #expect(try iterator.nextIfPresent(utf8: String.self, count: 0) == "")
        }
        
        @Test func nextIfPresentUTF8StringCountThrows() async throws {
            let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
            var iterator = bytes.makeIterator()
            #expect(try iterator.nextIfPresent(utf8: String.self, count: 0) == "")
            #expect(try iterator.nextIfPresent(utf8: String.self, count: 5) == "Hello")
            #expect(try iterator.nextIfPresent(utf8: String.self, count: 2) == ", ")
            #expect(try iterator.nextIfPresent(utf8: String.self, count: 5) == "World")
            
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try iterator.nextIfPresent(utf8: String.self, count: 2)
            }
            
            #expect(try iterator.nextIfPresent(utf8: String.self, count: 1) == nil)
            #expect(try iterator.nextIfPresent(utf8: String.self, count: 2) == nil)
            #expect(try iterator.nextIfPresent(utf8: String.self, count: 0) == "")
        }
        
        @Test func nextIfPresentUTF8StringMinMaxInvalidInput() async throws {
            await #expect(processExitsWith: .failure) {
                let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
                var iterator = bytes.makeIterator()
                _ = try iterator.nextIfPresent(utf8: String.self, min: -1, max: 1)
            }
            await #expect(processExitsWith: .failure) {
                let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
                var iterator = bytes.makeIterator()
                _ = try iterator.nextIfPresent(utf8: String.self, min: -1, max: -1)
            }
            await #expect(processExitsWith: .failure) {
                let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
                var iterator = bytes.makeIterator()
                _ = try iterator.nextIfPresent(utf8: String.self, min: 1, max: 0)
            }
        }
        
        @Test func nextIfPresentUTF8StringMinMax() async throws {
            let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
            var iterator = bytes.makeIterator()
            #expect(try iterator.nextIfPresent(utf8: String.self, min: 0, max: 0) == "")
            #expect(try iterator.nextIfPresent(utf8: String.self, min: 0, max: 5) == "Hello")
            #expect(try iterator.nextIfPresent(utf8: String.self, min: 0, max: 2) == ", ")
            #expect(try iterator.nextIfPresent(utf8: String.self, min: 0, max: 6) == "World!")
            #expect(try iterator.nextIfPresent(utf8: String.self, min: 0, max: 1) == nil)
            #expect(try iterator.nextIfPresent(utf8: String.self, min: 0, max: 2) == nil)
            #expect(try iterator.nextIfPresent(utf8: String.self, min: 0, max: 0) == "")
        }
        
        @Test func nextIfPresentUTF8StringMinMaxThrows() async throws {
            let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
            var iterator = bytes.makeIterator()
            #expect(try iterator.nextIfPresent(utf8: String.self, min: 0, max: 0) == "")
            #expect(try iterator.nextIfPresent(utf8: String.self, min: 0, max: 5) == "Hello")
            #expect(try iterator.nextIfPresent(utf8: String.self, min: 0, max: 2) == ", ")
            #expect(try iterator.nextIfPresent(utf8: String.self, min: 0, max: 5) == "World")
            
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try iterator.nextIfPresent(utf8: String.self, min: 2, max: 3)
            }
            
            #expect(try iterator.nextIfPresent(utf8: String.self, min: 0, max: 1) == nil)
            #expect(try iterator.nextIfPresent(utf8: String.self, min: 0, max: 2) == nil)
            #expect(try iterator.nextIfPresent(utf8: String.self, min: 0, max: 0) == "")
        }
        
        @Test func checkCharacter() async throws {
            let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
            var iterator = bytes.makeIterator()
            try iterator.check(utf8: "H" as Character)
            try iterator.check(utf8: "e" as Character)
            try iterator.check(utf8: "l" as Character)
            try iterator.check(utf8: "l" as Character)
            try iterator.check(utf8: "o" as Character)
            try iterator.check(utf8: "," as Character)
            try iterator.check(utf8: " " as Character)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(utf8: "w" as Character)
            }
            
            try iterator.check(utf8: "o" as Character)
            try iterator.check(utf8: "r" as Character)
            try iterator.check(utf8: "l" as Character)
            try iterator.check(utf8: "d" as Character)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(utf8: "?" as Character)
            }
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(utf8: "!" as Character)
            }
            
            try iterator.check(utf8: "")
        }
        
        @Test func checkString() async throws {
            let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
            var iterator = bytes.makeIterator()
            try iterator.check(utf8: "")
            try iterator.check(utf8: "Hello")
            try iterator.check(utf8: ", ")
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(utf8: "Wow")
            }
            
            try iterator.check(utf8: "ld")
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(utf8: "!!")
            }
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(utf8: "!")
            }
            
            try iterator.check(utf8: "")
        }
        
        @Test func checkIfPresentCharacter() async throws {
            let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
            var iterator = bytes.makeIterator()
            #expect(try iterator.checkIfPresent(utf8: "H" as Character) == true)
            #expect(try iterator.checkIfPresent(utf8: "e" as Character) == true)
            #expect(try iterator.checkIfPresent(utf8: "l" as Character) == true)
            #expect(try iterator.checkIfPresent(utf8: "l" as Character) == true)
            #expect(try iterator.checkIfPresent(utf8: "o" as Character) == true)
            #expect(try iterator.checkIfPresent(utf8: "," as Character) == true)
            #expect(try iterator.checkIfPresent(utf8: " " as Character) == true)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.checkIfPresent(utf8: "w" as Character)
            }
            
            #expect(try iterator.checkIfPresent(utf8: "o" as Character) == true)
            #expect(try iterator.checkIfPresent(utf8: "r" as Character) == true)
            #expect(try iterator.checkIfPresent(utf8: "l" as Character) == true)
            #expect(try iterator.checkIfPresent(utf8: "d" as Character) == true)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.checkIfPresent(utf8: "?" as Character)
            }
            
            #expect(try iterator.checkIfPresent(utf8: "!" as Character) == false)
            #expect(try iterator.checkIfPresent(utf8: "") == true)
        }
        
        @Test func checkIfPresentString() async throws {
            let bytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
            var iterator = bytes.makeIterator()
            #expect(try iterator.checkIfPresent(utf8: "") == true)
            #expect(try iterator.checkIfPresent(utf8: "Hello") == true)
            #expect(try iterator.checkIfPresent(utf8: ", ") == true)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.checkIfPresent(utf8: "Wow")
            }
            
            #expect(try iterator.checkIfPresent(utf8: "ld") == true)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.checkIfPresent(utf8: "!!")
            }
            
            #expect(try iterator.checkIfPresent(utf8: "!") == false)
            #expect(try iterator.checkIfPresent(utf8: "") == true)
        }
    }
    
    #if canImport(Darwin)
    @Suite struct StringLegacyAsyncByteIteratorTests {
        @Test func nextUTF8StringCountInvalidInput() async throws {
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.next(utf8: String.self, count: -1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.next(utf8: String.self, count: -1)
            }
        }
        
        @Test func nextUTF8StringCount() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.next(utf8: String.self, count: 0) == "")
            #expect(try await iterator.next(utf8: String.self, count: 5) == "Hello")
            #expect(try await iterator.next(utf8: String.self, count: 2) == ", ")
            #expect(try await iterator.next(utf8: String.self, count: 5) == "World")
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try await iterator.next(utf8: String.self, count: 2)
            }
        }
        
        @Test func nextUTF8StringCountThrows() async throws {
            var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.next(utf8: String.self, count: 0) == "")
            #expect(try await iterator.next(utf8: String.self, count: 5) == "Hello")
            #expect(try await iterator.next(utf8: String.self, count: 2) == ", ")
            #expect(try await iterator.next(utf8: String.self, count: 5) == "World")
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(utf8: String.self, count: 2)
            }
        }
        
        @Test func nextUTF8StringMinMaxInvalidInput() async throws {
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.next(utf8: String.self, min: -1, max: 1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.next(utf8: String.self, min: -1, max: -1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.next(utf8: String.self, min: 1, max: 0)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.next(utf8: String.self, min: -1, max: 1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.next(utf8: String.self, min: -1, max: -1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.next(utf8: String.self, min: 1, max: 0)
            }
        }
        
        @Test func nextUTF8StringMinMax() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 0) == "")
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 5) == "Hello")
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 2) == ", ")
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 6) == "World!")
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 5) == "")
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "Bytes", actualSize: 0)) {
                try await iterator.next(utf8: String.self, min: 1, max: 3)
            }
        }
        
        @Test func nextUTF8StringMinMaxThrows() async throws {
            var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 0) == "")
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 5) == "Hello")
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 2) == ", ")
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 6) == "World!")
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(utf8: String.self, min: 0, max: 5)
            }
        }
        
        @Test func nextIfPresentUTF8StringCountInvalidInput() async throws {
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.nextIfPresent(utf8: String.self, count: -1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.nextIfPresent(utf8: String.self, count: -1)
            }
        }
        
        @Test func nextIfPresentUTF8StringCount() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 0) == "")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 5) == "Hello")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 2) == ", ")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 6) == "World!")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 1) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 2) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 0) == "")
        }
        
        @Test func nextIfPresentUTF8StringCountCastingThrows() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 0) == "")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 5) == "Hello")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 2) == ", ")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 5) == "World")
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try await iterator.nextIfPresent(utf8: String.self, count: 2)
            }
            
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 1) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 2) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 0) == "")
        }
        
        @Test func nextIfPresentUTF8StringCountIteratorThrows() async throws {
            var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 0) == "")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 5) == "Hello")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 2) == ", ")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 5) == "World")
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(utf8: String.self, count: 2)
            }
            
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 1) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 2) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 0) == "")
        }
        
        @Test func nextIfPresentUTF8StringMinMaxInvalidInput() async throws {
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.nextIfPresent(utf8: String.self, min: -1, max: 1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.nextIfPresent(utf8: String.self, min: -1, max: -1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.nextIfPresent(utf8: String.self, min: 1, max: 0)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.nextIfPresent(utf8: String.self, min: -1, max: 1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.nextIfPresent(utf8: String.self, min: -1, max: -1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.nextIfPresent(utf8: String.self, min: 1, max: 0)
            }
        }
        
        @Test func nextIfPresentUTF8StringMinMax() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 0) == "")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 5) == "Hello")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 2) == ", ")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 6) == "World!")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 1) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 2) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 0) == "")
        }
        
        @Test func nextIfPresentUTF8StringMinMaxCastingThrows() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 0) == "")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 5) == "Hello")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 2) == ", ")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 5) == "World")
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try await iterator.nextIfPresent(utf8: String.self, min: 2, max: 3)
            }
            
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 1) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 2) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 0) == "")
        }
        
        @Test func nextIfPresentUTF8StringMinMaxIteratorThrows() async throws {
            var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 0) == "")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 5) == "Hello")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 2) == ", ")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 5) == "World")
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(utf8: String.self, min: 2, max: 3)
            }
            
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 1) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 2) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 0) == "")
        }
        
        @Test func checkCharacter() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            try await iterator.check(utf8: "H" as Character)
            try await iterator.check(utf8: "e" as Character)
            try await iterator.check(utf8: "l" as Character)
            try await iterator.check(utf8: "l" as Character)
            try await iterator.check(utf8: "o" as Character)
            try await iterator.check(utf8: "," as Character)
            try await iterator.check(utf8: " " as Character)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "w" as Character)
            }
            
            try await iterator.check(utf8: "o" as Character)
            try await iterator.check(utf8: "r" as Character)
            try await iterator.check(utf8: "l" as Character)
            try await iterator.check(utf8: "d" as Character)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "?" as Character)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "!" as Character)
            }
            
            try await iterator.check(utf8: "")
        }
        
        @Test func checkCharacterThrows() async throws {
            var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            try await iterator.check(utf8: "H" as Character)
            try await iterator.check(utf8: "e" as Character)
            try await iterator.check(utf8: "l" as Character)
            try await iterator.check(utf8: "l" as Character)
            try await iterator.check(utf8: "o" as Character)
            try await iterator.check(utf8: "," as Character)
            try await iterator.check(utf8: " " as Character)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "w" as Character)
            }
            
            try await iterator.check(utf8: "o" as Character)
            try await iterator.check(utf8: "r" as Character)
            try await iterator.check(utf8: "l" as Character)
            try await iterator.check(utf8: "d" as Character)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "?" as Character)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(utf8: "!" as Character)
            }
            
            try await iterator.check(utf8: "")
        }
        
        @Test func checkString() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            try await iterator.check(utf8: "")
            try await iterator.check(utf8: "Hello")
            try await iterator.check(utf8: ", ")
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "Wow")
            }
            
            try await iterator.check(utf8: "ld")
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "!!")
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "!")
            }
            
            try await iterator.check(utf8: "")
        }
        
        @Test func checkStringThrows() async throws {
            var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            try await iterator.check(utf8: "")
            try await iterator.check(utf8: "Hello")
            try await iterator.check(utf8: ", ")
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "Wow")
            }
            
            try await iterator.check(utf8: "ld")
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(utf8: "!!")
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "!")
            }
            
            try await iterator.check(utf8: "")
        }
        
        @Test func checkIfPresentCharacter() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.checkIfPresent(utf8: "H" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "e" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "l" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "l" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "o" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "," as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: " " as Character) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: "w" as Character)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: "o" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "r" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "l" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "d" as Character) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: "?" as Character)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: "!" as Character) == false)
            #expect(try await iterator.checkIfPresent(utf8: "") == true)
        }
        
        @Test func checkIfPresentCharacterThrows() async throws {
            var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.checkIfPresent(utf8: "H" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "e" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "l" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "l" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "o" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "," as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: " " as Character) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: "w" as Character)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: "o" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "r" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "l" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "d" as Character) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: "?" as Character)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(utf8: "!" as Character)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: "") == true)
        }
        
        @Test func checkIfPresentString() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.checkIfPresent(utf8: "") == true)
            #expect(try await iterator.checkIfPresent(utf8: "Hello") == true)
            #expect(try await iterator.checkIfPresent(utf8: ", ") == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: "Wow")
            }
            
            #expect(try await iterator.checkIfPresent(utf8: "ld") == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: "!!")
            }
            
            #expect(try await iterator.checkIfPresent(utf8: "!") == false)
            #expect(try await iterator.checkIfPresent(utf8: "") == true)
        }
        
        @Test func checkIfPresentStringThrows() async throws {
            var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.checkIfPresent(utf8: "") == true)
            #expect(try await iterator.checkIfPresent(utf8: "Hello") == true)
            #expect(try await iterator.checkIfPresent(utf8: ", ") == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: "Wow")
            }
            
            #expect(try await iterator.checkIfPresent(utf8: "ld") == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(utf8: "!!")
            }
            
            #expect(try await iterator.checkIfPresent(utf8: "!") == false)
            #expect(try await iterator.checkIfPresent(utf8: "") == true)
        }
    }
    #endif
    
    @Suite struct StringAsyncByteIteratorTests {
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextUTF8StringCountInvalidInput() async throws {
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.next(utf8: String.self, count: -1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.next(utf8: String.self, count: -1)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextUTF8StringCount() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.next(utf8: String.self, count: 0) == "")
            #expect(try await iterator.next(utf8: String.self, count: 5) == "Hello")
            #expect(try await iterator.next(utf8: String.self, count: 2) == ", ")
            #expect(try await iterator.next(utf8: String.self, count: 5) == "World")
            
            await #expect(throws: BytesError.Iteration<Never>.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try await iterator.next(utf8: String.self, count: 2)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextUTF8StringCountThrows() async throws {
            var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.next(utf8: String.self, count: 0) == "")
            #expect(try await iterator.next(utf8: String.self, count: 5) == "Hello")
            #expect(try await iterator.next(utf8: String.self, count: 2) == ", ")
            #expect(try await iterator.next(utf8: String.self, count: 5) == "World")
            
            await #expect(throws: BytesError.Iteration<LocalError>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(utf8: String.self, count: 2)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextUTF8StringMinMaxInvalidInput() async throws {
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.next(utf8: String.self, min: -1, max: 1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.next(utf8: String.self, min: -1, max: -1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.next(utf8: String.self, min: 1, max: 0)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.next(utf8: String.self, min: -1, max: 1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.next(utf8: String.self, min: -1, max: -1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.next(utf8: String.self, min: 1, max: 0)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextUTF8StringMinMax() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 0) == "")
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 5) == "Hello")
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 2) == ", ")
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 6) == "World!")
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 5) == "")
            
            await #expect(throws: BytesError.Iteration<Never>.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "Bytes", actualSize: 0)) {
                try await iterator.next(utf8: String.self, min: 1, max: 3)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextUTF8StringMinMaxThrows() async throws {
            var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 0) == "")
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 5) == "Hello")
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 2) == ", ")
            #expect(try await iterator.next(utf8: String.self, min: 0, max: 6) == "World!")
            
            await #expect(throws: BytesError.Iteration<LocalError>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(utf8: String.self, min: 0, max: 5)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentUTF8StringCountInvalidInput() async throws {
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.nextIfPresent(utf8: String.self, count: -1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.nextIfPresent(utf8: String.self, count: -1)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentUTF8StringCount() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 0) == "")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 5) == "Hello")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 2) == ", ")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 6) == "World!")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 1) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 2) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 0) == "")
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentUTF8StringCountCastingThrows() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 0) == "")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 5) == "Hello")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 2) == ", ")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 5) == "World")
            
            await #expect(throws: BytesError.Iteration<Never>.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try await iterator.nextIfPresent(utf8: String.self, count: 2)
            }
            
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 1) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 2) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 0) == "")
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentUTF8StringCountIteratorThrows() async throws {
            var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 0) == "")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 5) == "Hello")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 2) == ", ")
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 5) == "World")
            
            await #expect(throws: BytesError.Iteration<LocalError>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(utf8: String.self, count: 2)
            }
            
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 1) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 2) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, count: 0) == "")
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentUTF8StringMinMaxInvalidInput() async throws {
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.nextIfPresent(utf8: String.self, min: -1, max: 1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.nextIfPresent(utf8: String.self, min: -1, max: -1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.nextIfPresent(utf8: String.self, min: 1, max: 0)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.nextIfPresent(utf8: String.self, min: -1, max: 1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.nextIfPresent(utf8: String.self, min: -1, max: -1)
            }
            await #expect(processExitsWith: .failure) {
                var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
                _ = try await iterator.nextIfPresent(utf8: String.self, min: 1, max: 0)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentUTF8StringMinMax() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 0) == "")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 5) == "Hello")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 2) == ", ")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 6) == "World!")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 1) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 2) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 0) == "")
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentUTF8StringMinMaxCastingThrows() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 0) == "")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 5) == "Hello")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 2) == ", ")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 5) == "World")
            
            await #expect(throws: BytesError.Iteration<Never>.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try await iterator.nextIfPresent(utf8: String.self, min: 2, max: 3)
            }
            
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 1) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 2) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 0) == "")
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentUTF8StringMinMaxIteratorThrows() async throws {
            var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 0) == "")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 5) == "Hello")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 2) == ", ")
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 5) == "World")
            
            await #expect(throws: BytesError.Iteration<LocalError>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(utf8: String.self, min: 2, max: 3)
            }
            
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 1) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 2) == nil)
            #expect(try await iterator.nextIfPresent(utf8: String.self, min: 0, max: 0) == "")
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkCharacter() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            try await iterator.check(utf8: "H" as Character)
            try await iterator.check(utf8: "e" as Character)
            try await iterator.check(utf8: "l" as Character)
            try await iterator.check(utf8: "l" as Character)
            try await iterator.check(utf8: "o" as Character)
            try await iterator.check(utf8: "," as Character)
            try await iterator.check(utf8: " " as Character)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "w" as Character)
            }
            
            try await iterator.check(utf8: "o" as Character)
            try await iterator.check(utf8: "r" as Character)
            try await iterator.check(utf8: "l" as Character)
            try await iterator.check(utf8: "d" as Character)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "?" as Character)
            }
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "!" as Character)
            }
            
            try await iterator.check(utf8: "")
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkCharacterThrows() async throws {
            var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            try await iterator.check(utf8: "H" as Character)
            try await iterator.check(utf8: "e" as Character)
            try await iterator.check(utf8: "l" as Character)
            try await iterator.check(utf8: "l" as Character)
            try await iterator.check(utf8: "o" as Character)
            try await iterator.check(utf8: "," as Character)
            try await iterator.check(utf8: " " as Character)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "w" as Character)
            }
            
            try await iterator.check(utf8: "o" as Character)
            try await iterator.check(utf8: "r" as Character)
            try await iterator.check(utf8: "l" as Character)
            try await iterator.check(utf8: "d" as Character)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "?" as Character)
            }
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(utf8: "!" as Character)
            }
            
            try await iterator.check(utf8: "")
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkString() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            try await iterator.check(utf8: "")
            try await iterator.check(utf8: "Hello")
            try await iterator.check(utf8: ", ")
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "Wow")
            }
            
            try await iterator.check(utf8: "ld")
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "!!")
            }
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "!")
            }
            
            try await iterator.check(utf8: "")
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkStringThrows() async throws {
            var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            try await iterator.check(utf8: "")
            try await iterator.check(utf8: "Hello")
            try await iterator.check(utf8: ", ")
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "Wow")
            }
            
            try await iterator.check(utf8: "ld")
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(utf8: "!!")
            }
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: "!")
            }
            
            try await iterator.check(utf8: "")
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentCharacter() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.checkIfPresent(utf8: "H" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "e" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "l" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "l" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "o" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "," as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: " " as Character) == true)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: "w" as Character)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: "o" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "r" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "l" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "d" as Character) == true)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: "?" as Character)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: "!" as Character) == false)
            #expect(try await iterator.checkIfPresent(utf8: "") == true)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentCharacterThrows() async throws {
            var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.checkIfPresent(utf8: "H" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "e" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "l" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "l" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "o" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "," as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: " " as Character) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: "w" as Character)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: "o" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "r" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "l" as Character) == true)
            #expect(try await iterator.checkIfPresent(utf8: "d" as Character) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: "?" as Character)
            }
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(utf8: "!" as Character)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: "") == true)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentString() async throws {
            var iterator = AsyncTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.checkIfPresent(utf8: "") == true)
            #expect(try await iterator.checkIfPresent(utf8: "Hello") == true)
            #expect(try await iterator.checkIfPresent(utf8: ", ") == true)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: "Wow")
            }
            
            #expect(try await iterator.checkIfPresent(utf8: "ld") == true)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: "!!")
            }
            
            #expect(try await iterator.checkIfPresent(utf8: "!") == false)
            #expect(try await iterator.checkIfPresent(utf8: "") == true)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentStringThrows() async throws {
            var iterator = AsyncThrowingTestIterator([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33])
            #expect(try await iterator.checkIfPresent(utf8: "") == true)
            #expect(try await iterator.checkIfPresent(utf8: "Hello") == true)
            #expect(try await iterator.checkIfPresent(utf8: ", ") == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: "Wow")
            }
            
            #expect(try await iterator.checkIfPresent(utf8: "ld") == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(utf8: "!!")
            }
            
            #expect(try await iterator.checkIfPresent(utf8: "!") == false)
            #expect(try await iterator.checkIfPresent(utf8: "") == true)
        }
    }
}
