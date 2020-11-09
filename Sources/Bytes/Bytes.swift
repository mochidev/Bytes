//
//  Bytes.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 11/6/20.
//  Copyright © 2020 Mochi Development, Inc. All rights reserved.
//

public typealias Byte = UInt8

/// A type that has the same API as `Bytes`, `BytesSlice`, and `ContiguousBytes`.
public protocol BytesCollection: CustomDebugStringConvertible, CustomReflectable, CustomStringConvertible, ExpressibleByArrayLiteral, MutableCollection, RandomAccessCollection, RangeReplaceableCollection where Element == Byte, Index == Int, SubSequence: BytesCollection {}

public typealias Bytes = Array<Byte>
extension Bytes: BytesCollection {}

public typealias BytesSlice = ArraySlice<Byte>
extension BytesSlice: BytesCollection {}

public typealias ContiguousBytes = ContiguousArray<Byte>
extension ContiguousBytes: BytesCollection {}
