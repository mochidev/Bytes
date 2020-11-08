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
    
    /// Check if a sequence of Bytes can be safely mapped to a collection of elements.
    /// - Parameter target: The type of element to map to.
    /// - Throws: `BytesError.invalidMemorySize` if the total size of the bytes sequence is not a multiple of the element's size.
    /// - Returns: `(elementSize: Int, numberOfBytes: Int, elementCount: Int)`, to aid in building the new collection.
    @usableFromInline
    func canBeMapped<Element>(to target: Element.Type) throws -> (elementSize: Int, numberOfBytes: Int, elementCount: Int) {
        let elementSize = MemoryLayout<Element>.size
        let numberOfBytes = self.count
        let (elementCount, remainingElementSize) = numberOfBytes.quotientAndRemainder(dividingBy: elementSize)
        
        guard remainingElementSize == 0 else {
            throw BytesError.invalidMemorySize(targetSize: (elementCount+1)*elementSize, targetType: "\(Element.self)", actualSize: numberOfBytes)
        }
        
        return (elementSize, numberOfBytes, elementCount)
    }
}

extension Collection {
    /// Create a new Bytes sequence mapping each element accordingly.
    /// - Parameter transform: The transformation to perform on each element.
    /// - Returns: A Bytes sequence.
    @inlinable
    public func bytes(mapping transform: (Self.Element) -> Bytes) -> Bytes {
        var bytes = Bytes()
        bytes.reserveCapacity(self.count*MemoryLayout<Self.Element>.size)
        for element in self {
            bytes.append(contentsOf: transform(element))
        }
        return bytes
    }
}

extension RangeReplaceableCollection {
    /// Creates a new collection from a sequence of bytes, transforming batches of bytes into the element type of the collection.
    /// - Parameters:
    ///   - bytes: The bytes to transform.
    ///   - transform: The transformation to perform on each element.
    /// - Throws: `BytesError.invalidMemorySize` if the total size of the bytes sequence is not a multiple of the element's size.
    @inlinable
    public init<Bytes: BytesCollection>(bytes: Bytes, mapping transform: (Bytes.SubSequence) throws -> Self.Element) throws {
        let (elementSize, numberOfBytes, elementCount) = try bytes.canBeMapped(to: Element.self)
        
        var result = Self()
        result.reserveCapacity(elementCount)
        
        for sliceStart in stride(from: 0, to: numberOfBytes, by: elementSize) {
            let slice = bytes[sliceStart..<(sliceStart+elementSize)]
            result.append(try transform(slice))
        }
        
        self = result
    }
}

extension Set {
    /// Creates a new Set from a sequence of bytes, transforming batches of bytes into the element type of the Set.
    /// - Parameters:
    ///   - bytes: The bytes to transform.
    ///   - transform: The transformation to perform on each element.
    /// - Throws: `BytesError.invalidMemorySize` if the total size of the bytes sequence is not a multiple of the element's size.
    @inlinable
    public init<Bytes: BytesCollection>(bytes: Bytes, mapping getter: (Bytes.SubSequence) throws -> Self.Element) throws {
        let (elementSize, numberOfBytes, elementCount) = try bytes.canBeMapped(to: Element.self)
        
        var result = Self()
        result.reserveCapacity(elementCount)
        
        for sliceStart in stride(from: 0, to: numberOfBytes, by: elementSize) {
            let slice = bytes[sliceStart..<(sliceStart+elementSize)]
            result.insert(try getter(slice))
        }
        
        self = result
    }
}
