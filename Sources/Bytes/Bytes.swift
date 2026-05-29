//
//  Bytes.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 11/6/20.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

/// A single byte.
public typealias Byte = UInt8

/// A type that has the same API as ``Bytes``, and ``BytesSlice``.
public protocol BytesCollection: Collection where Element == Byte, SubSequence: BytesCollection {}

/// A collection that supports contiguous reads of its underlying storage
public protocol ContiguousBytesCollection: BytesCollection {
    /// Calls the given closure with a pointer to the underlying bytes of the collection's contiguous storage.
    @inlinable
    func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R
}

/// An array of bytes.
public typealias Bytes = Array<Byte>
extension Bytes: BytesCollection, ContiguousBytesCollection {}

/// A slice of an array of bytes.
public typealias BytesSlice = ArraySlice<Byte>
extension BytesSlice: BytesCollection, ContiguousBytesCollection {}

extension Slice: BytesCollection where Base: BytesCollection {}
extension Slice: ContiguousBytesCollection where Base: ContiguousBytesCollection, Index == Int {
    @inlinable
    public func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        try base.withUnsafeBytes { rawBufferPointer in
            try body(UnsafeRawBufferPointer(rebasing: rawBufferPointer[self.startIndex..<self.endIndex]))
        }
    }
}

extension ContiguousArray<Byte>: BytesCollection, ContiguousBytesCollection {}
extension EmptyCollection<Byte>: BytesCollection, ContiguousBytesCollection {}
extension CollectionOfOne<Byte>: BytesCollection, ContiguousBytesCollection {}
extension UnsafeBufferPointer<Byte>: BytesCollection, ContiguousBytesCollection {}
extension UnsafeMutableBufferPointer<Byte>: BytesCollection, ContiguousBytesCollection {}
extension UnsafeRawBufferPointer: BytesCollection, ContiguousBytesCollection {}
extension UnsafeMutableRawBufferPointer: BytesCollection, ContiguousBytesCollection {}

#if canImport(Foundation) || canImport(FoundationEssentials)
#if canImport(Foundation)
import Foundation
#else
import FoundationEssentials
#endif

extension Data: BytesCollection, ContiguousBytesCollection {}
#endif

#if canImport(Dispatch)
import Dispatch

extension DispatchData: BytesCollection {}
extension DispatchData.Region: BytesCollection, ContiguousBytesCollection {}
#endif
