//
//  Collection+Casting.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 11/6/20.
//  Copyright © 2020 Mochi Development, Inc. All rights reserved.
//

import Foundation

extension BidirectionalCollection where Element == UInt8 {
    @inlinable
    public func casting<R>(to target: R.Type) throws -> R {
        try casting()
    }
    
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
    
    @inlinable
    public init<T>(casting value: T) where Self: RangeReplaceableCollection {
        self = withUnsafeBytes(of: value) { Self($0) }
    }
}
