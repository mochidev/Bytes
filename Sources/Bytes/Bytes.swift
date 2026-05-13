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

public typealias Bytes = Array<Byte>
extension Bytes: BytesCollection {}

public typealias BytesSlice = ArraySlice<Byte>
extension BytesSlice: BytesCollection {}

public typealias ContiguousBytes = ContiguousArray<Byte>
extension ContiguousBytes: BytesCollection {}
