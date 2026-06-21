//
//  AsyncByteIterator.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 2021-11-12.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

#if canImport(Darwin)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncIteratorProtocol where Element == Byte {
    /// Asynchronously advances a byte array of size `count`, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter count: The number of bytes to form into a byte array.
    /// - Parameter targetType: The target type that is being decoded. Defaults to `"Bytes"` if not specified.
    /// - Returns: A byte array of size `count`.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete byte array could not be returned by the time the sequence ended.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func next(
        _ bytes: Bytes.Type,
        count: Int,
        targetType: String = "Byte"
    ) async throws(BytesError.Iteration<any Error>.BufferSizeError) -> Bytes {
        assert(count >= 0, "count must be larger than 0")
        return try await next(bytes, min: count, max: count, targetType: targetType)
    }
    
    /// Asynchronously advances a byte array with the specified minimum size, continuing until the specified maximum size, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a byte array.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Parameter targetType: The target type that is being decoded. Defaults to `"Bytes"` if not specified.
    /// - Returns: A byte array of size at least `minCount` and at most `maxCount`.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete byte array could not be returned by the time the sequence ended.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func next(
        _ bytes: Bytes.Type,
        min minCount: Int,
        max maxCount: Int,
        targetType: String = "Byte"
    ) async throws(BytesError.Iteration<any Error>.BufferSizeError) -> Bytes {
        precondition(minCount <= maxCount, "maxCount must be larger than or equal to minCount")
        precondition(minCount >= 0, "minCount must be larger than 0")
        guard maxCount > 0 else { return [] }
        
        var result = Bytes()
        result.reserveCapacity(minCount)
        
        do {
            while let next = try await next() {
                result.append(next)
                
                if result.count == maxCount {
                    return result
                }
            }
        } catch {
            throw .iterationFailure(error)
        }
        
        guard result.count >= minCount else {
            throw .invalidBufferSize(targetSize: minCount, targetType: targetType, actualSize: result.count)
        }
        
        return result
    }
    
    /// Asynchronously advances a byte array with the specified maximum size.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Returns: A byte array of size at least `minCount` and at most `maxCount`.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func next(
        _ bytes: Bytes.Type,
        max maxCount: Int
    ) async rethrows -> Bytes {
        precondition(maxCount >= 0, "maxCount must be larger than 0")
        guard maxCount > 0 else { return [] }
        
        var result = Bytes()
        result.reserveCapacity(maxCount)
        
        while let next = try await next() {
            result.append(next)
            
            if result.count == maxCount {
                return result
            }
        }
        
        return result
    }
    
    /// Asynchronously advances a byte array of size `count`, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter count: The number of bytes to form into a byte array.
    /// - Parameter targetType: The target type that is being decoded. Defaults to `"Bytes"` if not specified.
    /// - Returns: A byte array of size `count`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete byte array could not be returned by the time the sequence ended.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func nextIfPresent(
        _ bytes: Bytes.Type,
        count: Int,
        targetType: String = "Byte"
    ) async throws(BytesError.Iteration<any Error>.BufferSizeError) -> Bytes? {
        assert(count >= 0, "count must be larger than 0")
        return try await nextIfPresent(bytes, min: count, max: count, targetType: targetType)
    }
    
    /// Asynchronously advances a byte array with the specified minimum size, continuing until the specified maximum size, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a byte array.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Parameter targetType: The target type that is being decoded. Defaults to `"Bytes"` if not specified.
    /// - Returns: A byte array of size at least `minCount` and at most `maxCount`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete byte array could not be returned by the time the sequence ended.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func nextIfPresent(
        _ bytes: Bytes.Type,
        min minCount: Int,
        max maxCount: Int,
        targetType: String = "Byte"
    ) async throws(BytesError.Iteration<any Error>.BufferSizeError) -> Bytes? {
        precondition(minCount <= maxCount, "maxCount must be larger than or equal to minCount")
        precondition(minCount >= 0, "minCount must be larger than 0")
        guard maxCount > 0 else { return [] }
        
        var result = Bytes()
        result.reserveCapacity(minCount)
        
        do {
            while let next = try await next() {
                result.append(next)
                
                if result.count == maxCount {
                    return result
                }
            }
        } catch {
            throw .iterationFailure(error)
        }
        
        guard !result.isEmpty else { return nil }
        
        guard result.count >= minCount else {
            throw .invalidBufferSize(targetSize: minCount, targetType: targetType, actualSize: result.count)
        }
        
        return result
    }
    
    /// Asynchronously advances a byte array with the specified maximum size, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Returns: A byte array of size at most `maxCount`, or `nil` if the sequence is finished.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func nextIfPresent(
        _ bytes: Bytes.Type,
        max maxCount: Int
    ) async rethrows -> Bytes? {
        precondition(maxCount >= 0, "maxCount must be larger than 0")
        guard maxCount > 0 else { return [] }
        
        var result = Bytes()
        result.reserveCapacity(maxCount)
        
        while let next = try await next() {
            result.append(next)
            
            if result.count == maxCount {
                return result
            }
        }
        
        guard !result.isEmpty else { return nil }
        
        return result
    }
    
    /// Asynchronously advances by the specified byte if found, or throws if the next byte does not match.
    ///
    /// Use this method when you expect a byte to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter byte: The byte to check for.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the bytes could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func check(
        _ byte: UInt8
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) {
        let value: Element?
        do {
            value = try await next()
        } catch {
            throw .iterationFailure(error)
        }
        if value != byte {
            throw .checkedSequenceNotFound
        }
    }
    
    /// Asynchronously advances by the specified bytes if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a collection of bytes to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// If the bytes collection is an empty array, this method won't do anything.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: The bytes to check for.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the bytes could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func check<Bytes: BytesCollection>(
        _ bytes: Bytes
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) {
        for byte in bytes {
            try await check(byte)
        }
    }
    
    /// Asynchronously advances by the specified byte if found, throws if the next byte does not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a byte to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter byte: The byte to check for.
    /// - Returns: `true` if the byte was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the bytes could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @discardableResult
    @_disfavoredOverload
    public mutating func checkIfPresent(
        _ byte: UInt8
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) -> Bool {
        let value: Element?
        do {
            value = try await next()
        } catch {
            throw .iterationFailure(error)
        }
        guard let value else { return false }
        if value != byte {
            throw .checkedSequenceNotFound
        }
        
        return true
    }
    
    /// Asynchronously advances by the specified bytes if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a collection of bytes to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// If the bytes collection is an empty array, this method won't do anything.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: The bytes to check for.
    /// - Returns: `true` if the bytes were found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the bytes could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @discardableResult
    @_disfavoredOverload
    public mutating func checkIfPresent<Bytes: BytesCollection>(
        _ bytes: Bytes
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) -> Bool {
        var first = true
        for byte in bytes {
            if first {
                guard try await checkIfPresent(byte) else { return false }
                first = false
            } else {
                try await check(byte)
            }
        }
        
        return true
    }
}
#endif // canImport(Darwin)

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension AsyncIteratorProtocol where Element == Byte {
    /// Asynchronously advances a byte array of size `count`, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter count: The number of bytes to form into a byte array.
    /// - Parameter targetType: The target type that is being decoded. Defaults to `"Bytes"` if not specified.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A byte array of size `count`.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete byte array could not be returned by the time the sequence ended.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func next(
        _ bytes: Bytes.Type,
        count: Int,
        targetType: String = "Byte",
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.BufferSizeError) -> Bytes {
        assert(count >= 0, "count must be larger than 0")
        return try await next(bytes, min: count, max: count, targetType: targetType)
    }
    
    /// Asynchronously advances a byte array with the specified minimum size, continuing until the specified maximum size, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a byte array.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Parameter targetType: The target type that is being decoded. Defaults to `"Bytes"` if not specified.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A byte array of size at least `minCount` and at most `maxCount`.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete byte array could not be returned by the time the sequence ended.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func next(
        _ bytes: Bytes.Type,
        min minCount: Int,
        max maxCount: Int,
        targetType: String = "Byte",
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.BufferSizeError) -> Bytes {
        precondition(minCount <= maxCount, "maxCount must be larger than or equal to minCount")
        precondition(minCount >= 0, "minCount must be larger than 0")
        guard maxCount > 0 else { return [] }
        
        var result = Bytes()
        result.reserveCapacity(minCount)
        
        do {
            while let next = try await next(isolation: actor) {
                result.append(next)
                
                if result.count == maxCount {
                    return result
                }
            }
        } catch {
            throw .iterationFailure(error)
        }
        
        guard result.count >= minCount else {
            throw .invalidBufferSize(targetSize: minCount, targetType: targetType, actualSize: result.count)
        }
        
        return result
    }
    
    /// Asynchronously advances a byte array with the specified maximum size.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A byte array of size at least `minCount` and at most `maxCount`.
    @inlinable
    public mutating func next(
        _ bytes: Bytes.Type,
        max maxCount: Int,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(Failure) -> Bytes {
        precondition(maxCount >= 0, "maxCount must be larger than 0")
        guard maxCount > 0 else { return [] }
        
        var result = Bytes()
        result.reserveCapacity(maxCount)
        
        while let next = try await next(isolation: actor) {
            result.append(next)
            
            if result.count == maxCount {
                return result
            }
        }
        
        return result
    }
    
    /// Asynchronously advances a byte array of size `count`, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter count: The number of bytes to form into a byte array.
    /// - Parameter targetType: The target type that is being decoded. Defaults to `"Bytes"` if not specified.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A byte array of size `count`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete byte array could not be returned by the time the sequence ended.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func nextIfPresent(
        _ bytes: Bytes.Type,
        count: Int,
        targetType: String = "Byte",
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.BufferSizeError) -> Bytes? {
        assert(count >= 0, "count must be larger than 0")
        return try await nextIfPresent(bytes, min: count, max: count, targetType: targetType)
    }
    
    /// Asynchronously advances a byte array with the specified minimum size, continuing until the specified maximum size, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a byte array.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Parameter targetType: The target type that is being decoded. Defaults to `"Bytes"` if not specified.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A byte array of size at least `minCount` and at most `maxCount`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete byte array could not be returned by the time the sequence ended.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func nextIfPresent(
        _ bytes: Bytes.Type,
        min minCount: Int,
        max maxCount: Int,
        targetType: String = "Byte",
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.BufferSizeError) -> Bytes? {
        precondition(minCount <= maxCount, "maxCount must be larger than or equal to minCount")
        precondition(minCount >= 0, "minCount must be larger than 0")
        guard maxCount > 0 else { return [] }
        
        var result = Bytes()
        result.reserveCapacity(minCount)
        
        do {
            while let next = try await next(isolation: actor) {
                result.append(next)
                
                if result.count == maxCount {
                    return result
                }
            }
        } catch {
            throw .iterationFailure(error)
        }
        
        guard !result.isEmpty else { return nil }
        
        guard result.count >= minCount else {
            throw .invalidBufferSize(targetSize: minCount, targetType: targetType, actualSize: result.count)
        }
        
        return result
    }
    
    /// Asynchronously advances a byte array with the specified maximum size, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: This should be set to `Bytes.self`.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Parameter maxCount: The maximum number of bytes to form into a byte array.
    /// - Returns: A byte array of size at most `maxCount`, or `nil` if the sequence is finished.
    @inlinable
    public mutating func nextIfPresent(
        _ bytes: Bytes.Type,
        max maxCount: Int,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(Failure) -> Bytes? {
        precondition(maxCount >= 0, "maxCount must be larger than 0")
        guard maxCount > 0 else { return [] }
        
        var result = Bytes()
        result.reserveCapacity(maxCount)
        
        while let next = try await next(isolation: actor) {
            result.append(next)
            
            if result.count == maxCount {
                return result
            }
        }
        
        guard !result.isEmpty else { return nil }
        
        return result
    }
    
    /// Asynchronously advances by the specified byte if found, or throws if the next byte does not match.
    ///
    /// Use this method when you expect a byte to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter byte: The byte to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the bytes could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func check(
        _ byte: UInt8,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) {
        let value: Element?
        do {
            value = try await next(isolation: actor)
        } catch {
            throw .iterationFailure(error)
        }
        if value != byte {
            throw .checkedSequenceNotFound
        }
    }
    
    /// Asynchronously advances by the specified bytes if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a collection of bytes to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// If the bytes collection is an empty array, this method won't do anything.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: The bytes to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the bytes could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func check<Bytes: BytesCollection>(
        _ bytes: Bytes,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) {
        for byte in bytes {
            try await check(byte)
        }
    }
    
    /// Asynchronously advances by the specified byte if found, throws if the next byte does not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a byte to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter byte: The byte to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: `true` if the byte was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the bytes could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent(
        _ byte: UInt8,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) -> Bool {
        let value: Element?
        do {
            value = try await next(isolation: actor)
        } catch {
            throw .iterationFailure(error)
        }
        guard let value else { return false }
        if value != byte {
            throw .checkedSequenceNotFound
        }
        
        return true
    }
    
    /// Asynchronously advances by the specified bytes if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a collection of bytes to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// If the bytes collection is an empty array, this method won't do anything.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter bytes: The bytes to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: `true` if the bytes were found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the bytes could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<Bytes: BytesCollection>(
        _ bytes: Bytes,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) -> Bool {
        var first = true
        for byte in bytes {
            if first {
                guard try await checkIfPresent(byte) else { return false }
                first = false
            } else {
                try await  check(byte)
            }
        }
        
        return true
    }
}
