//
//  TestHelpers.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 2026-05-23.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

import Bytes

// MARK: - Test Errors

struct LocalError: Error, Equatable {}

struct AsyncTestIterator: AsyncIteratorProtocol {
    typealias Element = Byte
    typealias Failure = Never
    
    let bytes: Bytes
    var index = 0
    
    init(_ bytes: Bytes) {
        self.bytes = bytes
    }
    
    mutating func next() async throws(Failure) -> Byte? {
        defer { index += 1 }
        if bytes.indices ~= index {
            return self.bytes[index]
        } else {
            return nil
        }
    }
}

struct AsyncTestSequence: AsyncSequence {
    let bytes: Bytes = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
    
    func makeAsyncIterator() -> AsyncTestIterator {
        AsyncTestIterator(bytes)
    }
}

struct AsyncThrowingTestIterator: AsyncIteratorProtocol {
    typealias Element = Byte
    typealias Failure = LocalError
    
    let bytes: Bytes
    var index = 0
    
    init(_ bytes: Bytes) {
        self.bytes = bytes
    }
    
    mutating func next() async throws(Failure) -> Byte? {
        defer { index += 1 }
        if bytes.indices ~= index {
            return self.bytes[index]
        } else if index == bytes.count {
            throw LocalError()
        } else {
            return nil
        }
    }
}

struct AsyncThrowingTestSequence: AsyncSequence {
    let bytes: Bytes = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
    
    func makeAsyncIterator() -> AsyncThrowingTestIterator {
        AsyncThrowingTestIterator(bytes)
    }
}

// MARK: - Test Structs

struct Byte1: Equatable {
    var a: Byte
    
    static let zero = Self(a: 0)
}

extension Byte1: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Byte) {
        self.a = value
    }
}

struct Byte4: Equatable {
    var a: Byte1
    var b: Byte1
    var c: Byte1
    var d: Byte1
    
    static let zero = Self(a: .zero, b: .zero, c: .zero, d: .zero)
}

struct Byte16: Equatable {
    var a: Byte4
    var b: Byte4
    var c: Byte4
    var d: Byte4
    
    static let zero = Self(a: .zero, b: .zero, c: .zero, d: .zero)
}

struct Byte64: Equatable {
    var a: Byte16
    var b: Byte16
    var c: Byte16
    var d: Byte16
    
    static let zero = Self(a: .zero, b: .zero, c: .zero, d: .zero)
}

struct Byte256: Equatable {
    var a: Byte64
    var b: Byte64
    var c: Byte64
    var d: Byte64
    
    static let zero = Self(a: .zero, b: .zero, c: .zero, d: .zero)
}

struct Byte1024: Equatable {
    var a: Byte256
    var b: Byte256
    var c: Byte256
    var d: Byte256
    
    static let zero = Self(a: .zero, b: .zero, c: .zero, d: .zero)
}

struct Byte4096: Equatable {
    var a: Byte1024
    var b: Byte1024
    var c: Byte1024
    var d: Byte1024
    
    static let zero = Self(a: .zero, b: .zero, c: .zero, d: .zero)
}
