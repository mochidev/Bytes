//
//  ByteIterator.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 2021-12-10.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

extension IteratorProtocol where Element == Byte {
    /// Advances a byte array of size `count`, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter count: The number of bytes to form into a byte array.
    /// - Returns: A byte array of size `count`.
    /// - Throws: ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete byte array could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next(
        _ bytes: Bytes.Type,
        count: Int
    ) throws(BytesError.BufferSizeError) -> Bytes {
        assert(count >= 0, "count must be larger than 0")
        return try next(bytes, min: count, max: count)
    }
    
    /// Advances a byte array with the specified minimum size, continuing until the specified maximum size, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a byte array.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Returns: A byte array of size at least `minCount` and at most `maxCount`.
    /// - Throws: ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete byte array could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next(
        _ bytes: Bytes.Type,
        min minCount: Int,
        max maxCount: Int
    ) throws(BytesError.BufferSizeError) -> Bytes {
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
            throw .invalidBufferSize(targetSize: minCount, targetType: "\(Bytes.self)", actualSize: result.count)
        }
        
        return result
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
    
    /// Advances a byte array of size `count`, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter count: The number of bytes to form into a byte array.
    /// - Returns: A byte array of size `count`, or `nil` if the sequence is finished.
    /// - Throws: ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete byte array could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent(
        _ bytes: Bytes.Type,
        count: Int
    ) throws(BytesError.BufferSizeError) -> Bytes? {
        assert(count >= 0, "count must be larger than 0")
        return try nextIfPresent(bytes, min: count, max: count)
    }
    
    /// Advances a byte array with the specified minimum size, continuing until the specified maximum size, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a byte array.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Returns: A byte array of size at least `minCount` and at most `maxCount`, or `nil` if the sequence is finished.
    /// - Throws: ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete byte array could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent(
        _ bytes: Bytes.Type,
        min minCount: Int,
        max maxCount: Int
    ) throws(BytesError.BufferSizeError) -> Bytes? {
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
            throw .invalidBufferSize(targetSize: minCount, targetType: "\(Bytes.self)", actualSize: result.count)
        }
        
        return result
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
    
    /// Advances by the specified byte if found, or throws if the next byte does not match.
    ///
    /// Use this method when you expect a byte to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter byte: The byte to check for.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the bytes could not be identified.
    @inlinable
    public mutating func check(
        _ byte: UInt8
    ) throws(BytesError.SequenceCheckError) {
        let value = next()
        
        guard value == byte
        else { throw .checkedSequenceNotFound }
    }
    
    /// Advances by the specified bytes if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a collection of bytes to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// If the bytes collection is an empty array, this method won't do anything.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: The bytes to check for.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the bytes could not be identified.
    @inlinable
    public mutating func check<Bytes: BytesCollection>(
        _ bytes: Bytes
    ) throws(BytesError.SequenceCheckError) {
        for byte in bytes {
            try check(byte)
        }
    }
    
    /// Advances by the specified byte if found, throws if the next byte does not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a byte to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter byte: The byte to check for.
    /// - Returns: `true` if the byte was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the bytes could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent(
        _ byte: UInt8
    ) throws(BytesError.SequenceCheckError) -> Bool {
        guard let value = next() else { return false }
        
        guard value == byte
        else { throw .checkedSequenceNotFound }
        
        return true
    }
    
    /// Advances by the specified bytes if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a collection of bytes to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// If the bytes collection is an empty array, this method won't do anything.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: The bytes to check for.
    /// - Returns: `true` if the bytes were found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the bytes could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<Bytes: BytesCollection>(
        _ bytes: Bytes
    ) throws(BytesError.SequenceCheckError) -> Bool {
        var first = true
        for byte in bytes {
            if first {
                guard try checkIfPresent(byte) else { return false }
                first = false
            } else {
                try check(byte)
            }
        }
        
        return true
    }
}
