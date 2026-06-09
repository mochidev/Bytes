//
//  AsyncChunkedBytesTests.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 2026-06-09.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

import Bytes
import Testing

@Suite struct AsyncChunkedBytesTests {
    @Test func chunkedInvalidInput() async throws {
        await #expect(processExitsWith: .failure) {
            let sequence = AsyncTestSequence()
            _ = sequence.chuncked(-1)
        }
        await #expect(processExitsWith: .failure) {
            let sequence = AsyncTestSequence()
            _ = sequence.chuncked(0)
        }
        await #expect(processExitsWith: .failure) {
            let sequence = AsyncThrowingTestSequence()
            _ = sequence.chuncked(-1)
        }
        await #expect(processExitsWith: .failure) {
            let sequence = AsyncThrowingTestSequence()
            _ = sequence.chuncked(0)
        }
    }
    
    @Test func chunked() async throws {
        let sequence = AsyncTestSequence()
        var iterator = sequence.chuncked(3).makeAsyncIterator()
        #expect(await iterator.next() == [0x00, 0x01, 0x02])
        #expect(await iterator.next() == [0x03, 0x04, 0x05])
        #expect(await iterator.next() == [0x06, 0x07])
        #expect(await iterator.next() == nil)
    }
    
    @Test func chunkedThrows() async throws {
        let sequence = AsyncThrowingTestSequence()
        var iterator = sequence.chuncked(3).makeAsyncIterator()
        #expect(try await iterator.next() == [0x00, 0x01, 0x02])
        #expect(try await iterator.next() == [0x03, 0x04, 0x05])
        
        await #expect(throws: LocalError()) {
            try await iterator.next()
        }
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func isolatedChunked() async throws {
        let sequence = AsyncTestSequence()
        var iterator = sequence.chuncked(3).makeAsyncIterator()
        #expect(await iterator.next(isolation: #isolation) == [0x00, 0x01, 0x02])
        #expect(await iterator.next(isolation: #isolation) == [0x03, 0x04, 0x05])
        #expect(await iterator.next(isolation: #isolation) == [0x06, 0x07])
        #expect(await iterator.next(isolation: #isolation) == nil)
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func isolatedChunkedThrows() async throws {
        let sequence = AsyncThrowingTestSequence()
        var iterator = sequence.chuncked(3).makeAsyncIterator()
        #expect(try await iterator.next(isolation: #isolation) == [0x00, 0x01, 0x02])
        #expect(try await iterator.next(isolation: #isolation) == [0x03, 0x04, 0x05])
        
        await #expect(throws: LocalError()) {
            try await iterator.next(isolation: #isolation)
        }
    }
}
