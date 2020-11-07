//
//  Bytes.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 11/6/20.
//  Copyright © 2020 Mochi Development, Inc. All rights reserved.
//

/// A type that has the same API as `Bytes`, `BytesSlice`, and `ContiguousBytes`.
public protocol BytesCollection: CustomDebugStringConvertible, CustomReflectable, CustomStringConvertible, ExpressibleByArrayLiteral, MutableCollection, RandomAccessCollection, RangeReplaceableCollection where Element == UInt8, Index == Int, SubSequence: BytesCollection {}

public typealias Bytes = Array<UInt8>
extension Bytes: BytesCollection {}

public typealias BytesSlice = ArraySlice<UInt8>
extension BytesSlice: BytesCollection {}

public typealias ContiguousBytes = ContiguousArray<UInt8>
extension ContiguousBytes: BytesCollection {}
