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
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter count: The number of bytes to form into a byte array.
    /// - Returns: A byte array of size `count`.
    /// - Throws: ``BytesError/invalidMemorySize(targetSize:targetType:actualSize:)`` if a complete byte array could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next(
        _ bytes: Bytes.Type,
        count: Int
    ) throws -> Bytes {
        assert(count >= 0, "count must be larger than 0")
        return try next(bytes, min: count, max: count)
    }
    
    /// Please use ``next(_:count:)`` instead.
    @available(*, deprecated, renamed: "next(_:count:)")
    @inlinable
    public mutating func next(bytes type: Bytes.Type, count: Int) throws -> Bytes {
        try next(type, count: count)
    }
    
    /// Advances a byte array with the specified minimum size, continuing until the specified maximum size, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a byte array.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Returns: A byte array of size at least `minCount` and at most `maxCount`.
    /// - Throws: ``BytesError/invalidMemorySize(targetSize:targetType:actualSize:)`` if a complete byte array could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next(
        _ bytes: Bytes.Type,
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
    
    /// Please use ``next(_:min:max:)`` instead.
    @available(*, deprecated, renamed: "next(_:min:max:)")
    @inlinable
    public mutating func next(bytes type: Bytes.Type, min minCount: Int, max maxCount: Int) throws -> Bytes {
        try next(type, min: minCount, max: maxCount)
    }
    
    /// Advances a byte array with the specified maximum size.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Returns: A byte array of size at least `minCount` and at most `maxCount`.
    @inlinable
    public mutating func next(
        _ bytes: Bytes.Type,
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
    
    /// Please use ``next(_:max:)`` instead.
    @available(*, deprecated, renamed: "next(_:max:)")
    @inlinable
    public mutating func next(bytes type: Bytes.Type, max maxCount: Int) -> Bytes {
        next(type, max: maxCount)
    }
    
    /// Advances a byte array of size `count`, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter count: The number of bytes to form into a byte array.
    /// - Returns: A byte array of size `count`, or `nil` if the sequence is finished.
    /// - Throws: ``BytesError/invalidMemorySize(targetSize:targetType:actualSize:)`` if a complete byte array could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent(
        _ bytes: Bytes.Type,
        count: Int
    ) throws -> Bytes? {
        assert(count >= 0, "count must be larger than 0")
        return try nextIfPresent(bytes, min: count, max: count)
    }
    
    /// Please use ``nextIfPresent(_:count:)`` instead.
    @available(*, deprecated, renamed: "nextIfPresent(_:count:)")
    @inlinable
    public mutating func nextIfPresent(bytes type: Bytes.Type, count: Int) throws -> Bytes? {
        try nextIfPresent(type, count: count)
    }
    
    /// Advances a byte array with the specified minimum size, continuing until the specified maximum size, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a byte array.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Returns: A byte array of size at least `minCount` and at most `maxCount`, or `nil` if the sequence is finished.
    /// - Throws: ``BytesError/invalidMemorySize(targetSize:targetType:actualSize:)`` if a complete byte array could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent(
        _ bytes: Bytes.Type,
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
    
    /// Please use ``nextIfPresent(_:min:max:)`` instead.
    @available(*, deprecated, renamed: "nextIfPresent(_:min:max:)")
    @inlinable
    public mutating func nextIfPresent(bytes type: Bytes.Type, min minCount: Int, max maxCount: Int) throws -> Bytes? {
        try nextIfPresent(type, min: minCount, max: maxCount)
    }
    
    /// Advances a byte array with the specified maximum size, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Returns: A byte array of size at most `maxCount`, or `nil` if the sequence is finished.
    @inlinable
    public mutating func nextIfPresent(
        _ bytes: Bytes.Type,
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
    
    /// Please use ``nextIfPresent(_:max:)`` instead.
    @available(*, deprecated, renamed: "nextIfPresent(_:max:)")
    @inlinable
    public mutating func nextIfPresent(bytes type: Bytes.Type, max maxCount: Int) -> Bytes? {
        nextIfPresent(type, max: maxCount)
    }
}
