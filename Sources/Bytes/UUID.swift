//
//  UUID.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 11/8/20.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

public import Foundation

/// Internal structure to use when measuring UUID bytes in collections
@usableFromInline
typealias UUIDTextualBytes = (
    /*  8 */ Byte,Byte,Byte,Byte, Byte,Byte,Byte,Byte,
    /*  - */ Byte,
    /*  4 */ Byte,Byte,Byte,Byte,
    /*  - */ Byte,
    /*  4 */ Byte,Byte,Byte,Byte,
    /*  - */ Byte,
    /*  4 */ Byte,Byte,Byte,Byte,
    /*  - */ Byte,
    /* 12 */ Byte,Byte,Byte,Byte, Byte,Byte,Byte,Byte, Byte,Byte,Byte,Byte
)

extension UUID {
    /// The 16-byte Byte representation of a UUID.
    @inlinable
    public var bytes: Bytes {
        Bytes(casting: self.uuid)
    }
    
    /// Initialize a UUID from a contiguous sequence of Bytes representing the 16-byte compact format.
    /// - Parameter bytes: The Bytes to interpret as a binary UUID.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence is not 16-bytes.
    ///     - ``BytesError/ContiguousBytesError/contiguousBytesUnavailable(type:)-enum.case`` if the byte sequence cannot be made to be contiguous.
    @inlinable
    public init<Bytes: BytesCollection>(
        bytes: Bytes
    ) throws(BytesError.ContiguousBytes.BufferSizeError) {
        self.init(uuid: try bytes.casting())
    }
    
    /// The 36-character Byte representation of a UUID.
    @inlinable
    public var stringBytes: Bytes {
        self.uuidString.utf8Bytes
    }
    
    /// Initialize a UUID from a contiguous sequence of Bytes representing the 36-character format.
    /// - Parameter stringBytes: The Bytes to interpret as a UUID string.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence is not 36-bytes.
    ///     - ``BytesError/UUIDDecodingError/invalidUUIDByteSequence`` if the byte sequence does not represent a valid UUID.
    @inlinable
    public init<Bytes: BytesCollection>(
        stringBytes: Bytes
    ) throws(BytesError.UUIDDecoding.BufferSizeError) {
        do {
            try stringBytes.canBeCasted(to: UUIDTextualBytes.self)
        } catch {
            throw .castingFailure(error)
        }
        guard let value = Self(uuidString: String(utf8Bytes: stringBytes)) else {
            throw .invalidUUIDByteSequence
        }
        self = value
    }
}

// MARK: - Collection Extensions

extension Collection where Element == UUID {
    /// The 16-byte Byte representations of a collection of a UUIDs.
    @inlinable
    public var bytes: Bytes {
        self.bytes(for: uuid_t.self, mapping: \.bytes)
    }
    
    /// Initialize a collection of UUIDs with a sequence of Bytes representing the individual 16-byte UUIDs.
    /// - Parameter bytes: The Bytes to interpret as a sequence of binary UUIDs.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence is not a multiple of 16-bytes.
    ///     - ``BytesError/ContiguousBytesError/contiguousBytesUnavailable(type:)-enum.case`` if the byte sequence cannot be made to be contiguous.
    @inlinable
    public init<Bytes: BytesCollection>(
        bytes: Bytes
    ) throws(BytesError.ContiguousBytes.BufferSizeError) where Self: RangeReplaceableCollection {
        do {
            try self.init(bytes: bytes, element: uuid_t.self, mapping: Element.init(bytes:))
        } catch {
            throw error.flattened
        }
    }
    
    /// The 36-character Byte representations of a collection of a UUIDs.
    @inlinable
    public var stringBytes: Bytes {
        self.bytes(for: UUIDTextualBytes.self, mapping: \.stringBytes)
    }
    
    /// Initialize a collection of UUIDs with a sequence of Bytes representing the individual 36-character UUIDs.
    /// - Parameter stringBytes: The Bytes to interpret as a sequence of string UUIDs.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence is not a multiple of 36-bytes.
    ///     - ``BytesError/UUIDDecodingError/invalidUUIDByteSequence`` if the byte sequence does not represent valid UUIDs.
    @inlinable
    public init<Bytes: BytesCollection>(
        stringBytes: Bytes
    ) throws(BytesError.UUIDDecoding.BufferSizeError) where Self: RangeReplaceableCollection {
        do {
            try self.init(bytes: stringBytes, element: UUIDTextualBytes.self, mapping: Element.init(stringBytes:))
        } catch {
            throw error.flattened
        }
    }
}

// MARK: - Set Extensions

extension Set where Element == UUID {
    /// Initialize a Set of UUIDs with a sequence of Bytes representing the individual 16-byte UUIDs.
    /// - Parameter bytes: The Bytes to interpret as a sequence of binary UUIDs.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence is not a multiple of 16-bytes.
    ///     - ``BytesError/ContiguousBytesError/contiguousBytesUnavailable(type:)-enum.case`` if the byte sequence cannot be made to be contiguous.
    @inlinable
    public init<Bytes: BytesCollection>(
        bytes: Bytes
    ) throws(BytesError.ContiguousBytes.BufferSizeError) {
        do {
            try self.init(bytes: bytes, element: uuid_t.self, mapping: Element.init(bytes:))
        } catch {
            throw error.flattened
        }
    }
    
    /// Initialize a Set of UUIDs with a sequence of Bytes representing the individual 36-character UUIDs.
    /// - Parameter stringBytes: The Bytes to interpret as a sequence of string UUIDs.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence is not a multiple of 36-bytes.
    ///     - ``BytesError/UUIDDecodingError/invalidUUIDByteSequence`` if the byte sequence does not represent valid UUIDs.
    @inlinable
    public init<Bytes: BytesCollection>(
        stringBytes: Bytes
    ) throws(BytesError.UUIDDecoding.BufferSizeError) {
        do {
            try self.init(bytes: stringBytes, element: UUIDTextualBytes.self, mapping: Element.init(stringBytes:))
        } catch {
            throw error.flattened
        }
    }
}


// MARK: - ByteIterator

extension IteratorProtocol where Element == Byte {
    /// Asynchronously advances to the next binary UUID, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Returns: A UUID.
    /// - Throws: ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if 16 bytes are not available.
    @inlinable
    public mutating func next(
        _ type: UUID.Type
    ) throws(BytesError.BufferSizeError) -> UUID {
        /// We know the inner `try` validates the size already, so the outer one can never fail, and we can simplify the reported error types.
        try! UUID(bytes: try next(Bytes.self, count: MemoryLayout<uuid_t>.size))
    }
    
    /// Asynchronously advances to the next UUID String, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Returns: A UUID.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if 36 bytes are not available.
    ///     - ``BytesError/UUIDDecodingError/invalidUUIDByteSequence`` if the bytes could not be decoded into a UUID.
    @inlinable
    public mutating func next(
        string type: UUID.Type
    ) throws(BytesError.UUIDDecoding.BufferSizeError) -> UUID {
        let stringBytes: Bytes
        do {
            stringBytes = try next(Bytes.self, count: MemoryLayout<UUIDTextualBytes>.size)
        } catch {
            throw .castingFailure(error)
        }
        return try UUID(stringBytes: stringBytes)
    }
    
    /// Asynchronously advances to the next binary UUID, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Returns: A UUID, or `nil` if the sequence is finished.
    /// - Throws: ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if 16 bytes are not available.
    @inlinable
    public mutating func nextIfPresent(
        _ type: UUID.Type
    ) throws(BytesError.BufferSizeError) -> UUID? {
        /// We know the first `try` validates the size already, so the mapped one can never fail, and we can simplify the reported error types.
        try nextIfPresent(Bytes.self, count: MemoryLayout<uuid_t>.size)
            .map { try! UUID(bytes: $0) }
    }
    
    /// Asynchronously advances to the next UUID String, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Returns: A UUID, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if 36 bytes are not available.
    ///     - ``BytesError/UUIDDecodingError/invalidUUIDByteSequence`` if the bytes could not be decoded into a UUID.
    @inlinable
    public mutating func nextIfPresent(
        string type: UUID.Type
    ) throws(BytesError.UUIDDecoding.BufferSizeError) -> UUID? {
        let stringBytes: Bytes?
        do {
            stringBytes = try nextIfPresent(Bytes.self, count: MemoryLayout<UUIDTextualBytes>.size)
        } catch {
            throw .castingFailure(error)
        }
        guard let stringBytes else { return nil }
        return try UUID(stringBytes: stringBytes)
    }
    
    /// Advances by the specified binary UUID if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a binary UUID to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the UUID could not be identified.
    @inlinable
    public mutating func check(
        _ uuid: UUID
    ) throws(BytesError.SequenceCheckError) {
        try check(uuid.bytes)
    }
    
    /// Advances by the specified UUID String if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a UUID String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the UUID could not be identified.
    @inlinable
    public mutating func check(
        string uuid: UUID
    ) throws(BytesError.SequenceCheckError) {
        guard try checkIfPresent(string: uuid)
        else { throw .checkedSequenceNotFound }
    }
    
    /// Advances by the specified binary UUID if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a binary UUID to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Returns: `true` if the string was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the UUID could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent(
        _ uuid: UUID
    ) throws(BytesError.SequenceCheckError) -> Bool {
        try checkIfPresent(uuid.bytes)
    }
    
    /// Advances by the specified UUID String if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a UUID String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Returns: `true` if the string was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the UUID could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent(
        string uuid: UUID
    ) throws(BytesError.SequenceCheckError) -> Bool {
        let value: UUID?
        do {
            value = try nextIfPresent(string: UUID.self)
        } catch {
            throw .checkedSequenceNotFound
        }
        
        switch value {
        case .none: return false
        case uuid:  return true
        case .some: throw .checkedSequenceNotFound
        }
    }
}


// MARK: - AsyncByteIterator

#if canImport(Darwin)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncIteratorProtocol where Element == Byte {
    /// Asynchronously advances to the next binary UUID, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Returns: A UUID.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if 16 bytes are not available.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func next(
        _ type: UUID.Type
    ) async throws(BytesError.Iteration<any Error>.BufferSizeError) -> UUID {
        /// We know the inner `try` validates the size already, so the outer one can never fail, and we can simplify the reported error types.
        try! UUID(bytes: try await next(Bytes.self, count: MemoryLayout<uuid_t>.size))
    }
    
    /// Asynchronously advances to the next UUID String, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Returns: A UUID.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if 36 bytes are not available.
    ///     - ``BytesError/UUIDDecodingError/invalidUUIDByteSequence`` if the bytes could not be decoded into a UUID.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func next(
        string type: UUID.Type
    ) async throws(BytesError.Iteration<any Error>.UUIDDecoding.BufferSizeError) -> UUID {
        let stringBytes: Bytes
        do {
            stringBytes = try await next(Bytes.self, count: MemoryLayout<UUIDTextualBytes>.size)
        } catch {
            throw error.mapCastingFailure { .castingFailure($0) }
        }
        do {
            return try UUID(stringBytes: stringBytes)
        } catch {
            throw .castingFailure(error)
        }
    }
    
    /// Asynchronously advances to the next binary UUID, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Returns: A UUID, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if 16 bytes are not available.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func nextIfPresent(
        _ type: UUID.Type
    ) async throws(BytesError.Iteration<any Error>.BufferSizeError) -> UUID? {
        /// We know the first `try` validates the size already, so the mapped one can never fail, and we can simplify the reported error types.
        try await nextIfPresent(Bytes.self, count: MemoryLayout<uuid_t>.size)
            .map { try! UUID(bytes: $0) }
    }
    
    /// Asynchronously advances to the next UUID String, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Returns: A UUID, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if 36 bytes are not available.
    ///     - ``BytesError/UUIDDecodingError/invalidUUIDByteSequence`` if the bytes could not be decoded into a UUID.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func nextIfPresent(
        string type: UUID.Type
    ) async throws(BytesError.Iteration<any Error>.UUIDDecoding.BufferSizeError) -> UUID? {
        let stringBytes: Bytes?
        do {
            stringBytes = try await nextIfPresent(Bytes.self, count: MemoryLayout<UUIDTextualBytes>.size)
        } catch {
            throw error.mapCastingFailure { .castingFailure($0) }
        }
        guard let stringBytes else { return nil }
        do {
            return try UUID(stringBytes: stringBytes)
        } catch {
            throw .castingFailure(error)
        }
    }
    
    /// Asynchronously advances by the specified binary UUID if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a binary UUID to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the UUID could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func check(
        _ uuid: UUID
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) {
        try await check(uuid.bytes)
    }
    
    /// Asynchronously advances by the specified UUID String if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a UUID String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the UUID could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func check(
        string uuid: UUID
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) {
        guard try await checkIfPresent(string: uuid)
        else { throw .checkedSequenceNotFound }
    }
    
    /// Asynchronously advances by the specified binary UUID if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a binary UUID to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Returns: `true` if the string was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the UUID could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    @discardableResult
    public mutating func checkIfPresent(
        _ uuid: UUID
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) -> Bool {
        try await checkIfPresent(uuid.bytes)
    }
    
    /// Asynchronously advances by the specified UUID String if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a UUID String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Returns: `true` if the string was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the UUID could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    @discardableResult
    public mutating func checkIfPresent(
        string uuid: UUID
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) -> Bool {
        let value: UUID?
        do {
            value = try await nextIfPresent(string: UUID.self)
        } catch {
            throw error.mapCastingFailure { _ in .checkedSequenceNotFound }
        }
        
        switch value {
        case .none: return false
        case uuid:  return true
        case .some: throw .checkedSequenceNotFound
        }
    }
}
#endif // canImport(Darwin)

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension AsyncIteratorProtocol where Element == Byte {
    /// Asynchronously advances to the next binary UUID, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A UUID.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if 16 bytes are not available.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func next(
        _ type: UUID.Type,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.BufferSizeError) -> UUID {
        /// We know the inner `try` validates the size already, so the outer one can never fail, and we can simplify the reported error types.
        try! UUID(bytes: try await next(Bytes.self, count: MemoryLayout<uuid_t>.size))
    }
    
    /// Asynchronously advances to the next UUID String, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A UUID.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if 36 bytes are not available.
    ///     - ``BytesError/UUIDDecodingError/invalidUUIDByteSequence`` if the bytes could not be decoded into a UUID.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func next(
        string type: UUID.Type,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.UUIDDecoding.BufferSizeError) -> UUID {
        let stringBytes: Bytes
        do {
            stringBytes = try await next(Bytes.self, count: MemoryLayout<UUIDTextualBytes>.size)
        } catch {
            throw error.mapCastingFailure { .castingFailure($0) }
        }
        do {
            return try UUID(stringBytes: stringBytes)
        } catch {
            throw .castingFailure(error)
        }
    }
    
    /// Asynchronously advances to the next binary UUID, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A UUID, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if 16 bytes are not available.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func nextIfPresent(
        _ type: UUID.Type,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.BufferSizeError) -> UUID? {
        /// We know the first `try` validates the size already, so the mapped one can never fail, and we can simplify the reported error types.
        try await nextIfPresent(Bytes.self, count: MemoryLayout<uuid_t>.size)
            .map { try! UUID(bytes: $0) }
    }
    
    /// Asynchronously advances to the next UUID String, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A UUID, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if 36 bytes are not available.
    ///     - ``BytesError/UUIDDecodingError/invalidUUIDByteSequence`` if the bytes could not be decoded into a UUID.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func nextIfPresent(
        string type: UUID.Type,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.UUIDDecoding.BufferSizeError) -> UUID? {
        let stringBytes: Bytes?
        do {
            stringBytes = try await nextIfPresent(Bytes.self, count: MemoryLayout<UUIDTextualBytes>.size)
        } catch {
            throw error.mapCastingFailure { .castingFailure($0) }
        }
        guard let stringBytes else { return nil }
        do {
            return try UUID(stringBytes: stringBytes)
        } catch {
            throw .castingFailure(error)
        }
    }
    
    /// Asynchronously advances by the specified binary UUID if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a binary UUID to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the UUID could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func check(
        _ uuid: UUID,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) {
        try await check(uuid.bytes)
    }
    
    /// Asynchronously advances by the specified UUID String if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a UUID String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the UUID could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func check(
        string uuid: UUID,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) {
        guard try await checkIfPresent(string: uuid)
        else { throw .checkedSequenceNotFound }
    }
    
    /// Asynchronously advances by the specified binary UUID if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a binary UUID to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: `true` if the string was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the UUID could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent(
        _ uuid: UUID,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) -> Bool {
        try await checkIfPresent(uuid.bytes)
    }
    
    /// Asynchronously advances by the specified UUID String if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a UUID String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: `true` if the string was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the UUID could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent(
        string uuid: UUID,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) -> Bool {
        let value: UUID?
        do {
            value = try await nextIfPresent(string: UUID.self)
        } catch {
            throw error.mapCastingFailure { _ in .checkedSequenceNotFound }
        }
        
        switch value {
        case .none: return false
        case uuid:  return true
        case .some: throw .checkedSequenceNotFound
        }
    }
}
