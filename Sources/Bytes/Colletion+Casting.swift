//
//  Collection+Casting.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 11/6/20.
//  Copyright © 2020 Mochi Development, Inc. All rights reserved.
//

import Foundation

extension BidirectionalCollection where Element == UInt8 {
    /// Cast an _entire_ Bytes sequence to the target's type.
    /// - Parameter target: The type of the target.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the memory layout of the bytes sequence does not match the desired type.
    ///     - `BytesError.contiguousMemoryUnavailable` if contiguous memory could not be made available.
    /// - Returns: An instance of the target represented by the Bytes sequence.
    @inlinable
    public func casting<R>(to target: R.Type) throws -> R {
        try casting()
    }
    
    /// Cast an _entire_ Bytes sequence to the lhs's type.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the memory layout of the bytes sequence does not match the desired type.
    ///     - `BytesError.contiguousMemoryUnavailable` if contiguous memory could not be made available.
    /// - Returns: An instance represented by the Bytes sequence.
    @inlinable
    public func casting<R>() throws -> R {
        guard MemoryLayout<R>.size == self.count else {
            throw BytesError.invalidMemorySize(targetSize: MemoryLayout<R>.size, targetType: "\(R.self)", actualSize: self.count)
        }
        
        guard
            let result = self.withContiguousStorageIfAvailable({
                $0.withUnsafeBytes {
                    $0.baseAddress!.assumingMemoryBound(to: R.self).pointee
                }
            })
            else {
                throw BytesError.contiguousMemoryUnavailable(type: "\(Self.self)")
        }
        return result
    }
    
    /// Create a new Bytes sequence from the memory occupied by the passed in value.
    /// - Parameter value: The value to cast to a sequence of bytes.
    @inlinable
    public init<T>(casting value: T) where Self: RangeReplaceableCollection {
        self = withUnsafeBytes(of: value) { Self($0) }
    }
}
