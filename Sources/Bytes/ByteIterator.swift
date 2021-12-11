//
//  ByteIterator.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 2021-12-10.
//  Copyright © 2020-2021 Mochi Development, Inc. All rights reserved.
//

extension IteratorProtocol where Element == Byte {
    /// Advances a byte array of size `count`, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `Bytes.self`.
    /// - Parameter count: The number of bytes to form into a byte array.
    /// - Returns: A byte array of size `count`.
    /// - Throws: `BytesError.invalidMemorySize` if a complete byte array could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next(
        bytes type: Bytes.Type,
        count: Int
    ) throws -> Bytes {
        assert(count >= 0, "count must be larger than 0")
        return try next(bytes: type, min: count, max: count)
    }
    
    /// Advances a byte array with the specified minimum size, continuing until the specified maximum size, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `Bytes.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a byte array.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Returns: A byte array of size at least `minCount` and at most `maxCount`.
    /// - Throws: `BytesError.invalidMemorySize` if a complete byte array could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next(
        bytes type: Bytes.Type,
        min minCount: Int,
        max maxCount: Int
    ) throws -> Bytes {
        precondition(minCount <= maxCount, "maxCount must be larger than or equal to minCount")
        precondition(minCount >= 0, "minCount must be larger than 0")
        guard maxCount > 0 else { return [] }
        
        var result = Bytes()
        result.reserveCapacity(minCount)
        
        while let next = next() {
            result.append(next)
            
            if result.count == maxCount {
                return result
            }
        }
        
        guard result.count >= minCount else {
            throw BytesError.invalidMemorySize(targetSize: minCount, targetType: "\(Bytes.self)", actualSize: result.count)
        }
        
        return result
    }
    
    /// Advances a byte array with the specified maximum size.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `Bytes.self`.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Returns: A byte array of size at least `minCount` and at most `maxCount`.
    @inlinable
    public mutating func next(
        bytes type: Bytes.Type,
        max maxCount: Int
    ) -> Bytes {
        precondition(maxCount >= 0, "maxCount must be larger than 0")
        guard maxCount > 0 else { return [] }
        
        var result = Bytes()
        result.reserveCapacity(maxCount)
        
        while let next = next() {
            result.append(next)
            
            if result.count == maxCount {
                return result
            }
        }
        
        return result
    }
    
    /// Advances a byte array of size `count`, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `Bytes.self`.
    /// - Parameter count: The number of bytes to form into a byte array.
    /// - Returns: A byte array of size `count`, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if a complete byte array could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent(
        bytes type: Bytes.Type,
        count: Int
    ) throws -> Bytes? {
        assert(count >= 0, "count must be larger than 0")
        return try nextIfPresent(bytes: type, min: count, max: count)
    }
    
    /// Advances a byte array with the specified minimum size, continuing until the specified maximum size, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `Bytes.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a byte array.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Returns: A byte array of size at least `minCount` and at most `maxCount`, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if a complete byte array could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent(
        bytes type: Bytes.Type,
        min minCount: Int,
        max maxCount: Int
    ) throws -> Bytes? {
        precondition(minCount <= maxCount, "maxCount must be larger than or equal to minCount")
        precondition(minCount >= 0, "minCount must be larger than 0")
        guard maxCount > 0 else { return [] }
        
        var result = Bytes()
        result.reserveCapacity(minCount)
        
        while let next = next() {
            result.append(next)
            
            if result.count == maxCount {
                return result
            }
        }
        
        guard !result.isEmpty else { return nil }
        
        guard result.count >= minCount else {
            throw BytesError.invalidMemorySize(targetSize: minCount, targetType: "\(Bytes.self)", actualSize: result.count)
        }
        
        return result
    }
    
    /// Advances a byte array with the specified maximum size, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `Bytes.self`.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Returns: A byte array of size at most `maxCount`, or `nil` if the sequence is finished.
    @inlinable
    public mutating func nextIfPresent(
        bytes type: Bytes.Type,
        max maxCount: Int
    ) -> Bytes? {
        precondition(maxCount >= 0, "maxCount must be larger than 0")
        guard maxCount > 0 else { return [] }
        
        var result = Bytes()
        result.reserveCapacity(maxCount)
        
        while let next = next() {
            result.append(next)
            
            if result.count == maxCount {
                return result
            }
        }
        
        guard !result.isEmpty else { return nil }
        
        return result
    }
}
