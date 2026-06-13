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

// MARK: - Test Structs

struct Byte1: Equatable {
    let a: Byte
    
    static let zero = Self(a: 0)
}

struct Byte4: Equatable {
    let a: Byte1
    let b: Byte1
    let c: Byte1
    let d: Byte1
    
    static let zero = Self(a: .zero, b: .zero, c: .zero, d: .zero)
}

struct Byte16: Equatable {
    let a: Byte4
    let b: Byte4
    let c: Byte4
    let d: Byte4
    
    static let zero = Self(a: .zero, b: .zero, c: .zero, d: .zero)
}

struct Byte64: Equatable {
    let a: Byte16
    let b: Byte16
    let c: Byte16
    let d: Byte16
    
    static let zero = Self(a: .zero, b: .zero, c: .zero, d: .zero)
}

struct Byte256: Equatable {
    let a: Byte64
    let b: Byte64
    let c: Byte64
    let d: Byte64
    
    static let zero = Self(a: .zero, b: .zero, c: .zero, d: .zero)
}

struct Byte1024: Equatable {
    let a: Byte256
    let b: Byte256
    let c: Byte256
    let d: Byte256
    
    static let zero = Self(a: .zero, b: .zero, c: .zero, d: .zero)
}

struct Byte4096: Equatable {
    let a: Byte1024
    let b: Byte1024
    let c: Byte1024
    let d: Byte1024
    
    static let zero = Self(a: .zero, b: .zero, c: .zero, d: .zero)
}
