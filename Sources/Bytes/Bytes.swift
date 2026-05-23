//
//  Bytes.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 11/6/20.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

public typealias Byte = UInt8

/// A type that has the same API as ``Bytes``, ``BytesSlice``, and ``ContiguousBytes``.
public protocol BytesCollection: CustomDebugStringConvertible, CustomReflectable, CustomStringConvertible, ExpressibleByArrayLiteral, MutableCollection, RandomAccessCollection, RangeReplaceableCollection, Sendable where Element == Byte, Index == Int, SubSequence: BytesCollection {}

/// A collection that supports contiguous reads of its underlying storage
public protocol ContiguousBytesCollection: BytesCollection where Element == Byte {
    /// Calls the given closure with a pointer to the underlying bytes of the collection's contiguous storage.
    @inlinable
    func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R
}

public typealias Bytes = Array<Byte>
extension Bytes: BytesCollection, ContiguousBytesCollection {}

public typealias BytesSlice = ArraySlice<Byte>
extension BytesSlice: BytesCollection, ContiguousBytesCollection {}

public typealias ContiguousBytes = ContiguousArray<Byte>
extension ContiguousBytes: BytesCollection, ContiguousBytesCollection {}
