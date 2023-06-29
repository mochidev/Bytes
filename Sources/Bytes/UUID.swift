//
//  UUID.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 11/8/20.
//  Copyright © 2020 Mochi Development, Inc. All rights reserved.
//

import Foundation

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
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not 16-bytes.
    ///     - `BytesError.contiguousMemoryUnavailable` if the byte sequence cannot be made to be contiguous.
    @inlinable
    public init<Bytes: BytesCollection>(bytes: Bytes) throws {
        try self.init(uuid: bytes.casting())
    }
    
    /// The 36-character Byte representation of a UUID.
    @inlinable
    public var stringBytes: Bytes {
        self.uuidString.utf8Bytes
    }
    
    /// Initialize a UUID from a contiguous sequence of Bytes representing the 36-character format.
    /// - Parameter bytes: The Bytes to interpret as a UUID string.
    /// - Throws:
    ///     - `BytesError.invalidUUIDByteSequence` if the byte sequence does not represent a valid UUID.
    @inlinable
    public init<Bytes: BytesCollection>(stringBytes: Bytes) throws {
        try stringBytes.canBeCasted(to: UUIDTextualBytes.self)
        guard let value = Self(uuidString: String(utf8Bytes: stringBytes)) else {
            throw BytesError.invalidUUIDByteSequence
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
    /// - Parameter rawBytes: The Bytes to interpret as a sequence of binary UUIDs.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not a multiple of 16-bytes.
    ///     - `BytesError.contiguousMemoryUnavailable` if the byte sequence cannot be made to be contiguous.
    @inlinable
    public init<Bytes: BytesCollection>(bytes: Bytes) throws where Self: RangeReplaceableCollection {
        try self.init(bytes: bytes, element: uuid_t.self, mapping: Element.init(bytes:))
    }
    
    /// The 36-character Byte representations of a collection of a UUIDs.
    @inlinable
    public var stringBytes: Bytes {
        self.bytes(for: UUIDTextualBytes.self, mapping: \.stringBytes)
    }
    
    /// Initialize a collection of UUIDs with a sequence of Bytes representing the individual 36-character UUIDs.
    /// - Parameter rawBytes: The Bytes to interpret as a sequence of binary UUIDs.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not a multiple of 36-bytes.
    ///     - `BytesError.contiguousMemoryUnavailable` if the byte sequence cannot be made to be contiguous.
    ///     - `BytesError.invalidUUIDByteSequence` if the byte sequence does not represent valid UUIDs.
    @inlinable
    public init<Bytes: BytesCollection>(stringBytes: Bytes) throws where Self: RangeReplaceableCollection {
        try self.init(bytes: stringBytes, element: UUIDTextualBytes.self, mapping: Element.init(stringBytes:))
    }
}

// MARK: - Set Extensions

extension Set where Element == UUID {
    /// Initialize a Set of UUIDs with a sequence of Bytes representing the individual 16-byte UUIDs.
    /// - Parameter rawBytes: The Bytes to interpret as a sequence of binary UUIDs.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not a multiple of 16-bytes.
    ///     - `BytesError.contiguousMemoryUnavailable` if the byte sequence cannot be made to be contiguous.
    @inlinable
    public init<Bytes: BytesCollection>(bytes: Bytes) throws {
        try self.init(bytes: bytes, element: uuid_t.self, mapping: Element.init(bytes:))
    }
    
    /// Initialize a Set of UUIDs with a sequence of Bytes representing the individual 36-character UUIDs.
    /// - Parameter rawBytes: The Bytes to interpret as a sequence of binary UUIDs.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not a multiple of 36-bytes.
    ///     - `BytesError.contiguousMemoryUnavailable` if the byte sequence cannot be made to be contiguous.
    ///     - `BytesError.invalidUUIDByteSequence` if the byte sequence does not represent valid UUIDs.
    @inlinable
    public init<Bytes: BytesCollection>(stringBytes: Bytes) throws {
        try self.init(bytes: stringBytes, element: UUIDTextualBytes.self, mapping: Element.init(stringBytes:))
    }
}


// MARK: - ByteIterator

extension IteratorProtocol where Element == Byte {
    /// Asynchronously advances to the next binary UUID, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Returns: A UUID.
    /// - Throws: `BytesError.invalidMemorySize` if 16 bytes are not available.
    @inlinable
    public mutating func next(_ type: UUID.Type) throws -> UUID {
        try UUID(bytes: next(Bytes.self, count: MemoryLayout<uuid_t>.size))
    }
    
    /// Asynchronously advances to the next UUID String, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Returns: A UUID.
    /// - Throws: `BytesError.invalidMemorySize` if 36 bytes are not available.
    @inlinable
    public mutating func next(string type: UUID.Type) throws -> UUID {
        try UUID(stringBytes: next(Bytes.self, count: MemoryLayout<UUIDTextualBytes>.size))
    }
    
    /// Asynchronously advances to the next binary UUID, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Returns: A UUID, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if 16 bytes are not available.
    @inlinable
    public mutating func nextIfPresent(_ type: UUID.Type) throws -> UUID? {
        try nextIfPresent(Bytes.self, count: MemoryLayout<uuid_t>.size).map { try UUID(bytes: $0) }
    }
    
    /// Asynchronously advances to the next UUID String, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Returns: A UUID, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if 36 bytes are not available.
    @inlinable
    public mutating func nextIfPresent(string type: UUID.Type) throws -> UUID? {
        try nextIfPresent(Bytes.self, count: MemoryLayout<UUIDTextualBytes>.size).map { try UUID(stringBytes: $0) }
    }
    
    /// Advances by the specified binary UUID if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a binary UUID to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the string could not be identified.
    @inlinable
    public mutating func check(
        _ uuid: UUID
    ) throws {
        try check(uuid.bytes)
    }
    
    /// Advances by the specified UUID String if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a UUID String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the string could not be identified.
    @inlinable
    public mutating func check(
        string uuid: UUID
    ) throws {
        let value = try next(string: UUID.self)
        
        guard value == uuid
        else { throw BytesError.checkedSequenceNotFound }
    }
    
    /// Advances by the specified binary UUID if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a binary UUID to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Returns: `true` if the string was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the string could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent(
        _ uuid: UUID
    ) throws -> Bool {
        try checkIfPresent(uuid.bytes)
    }
    
    /// Advances by the specified UUID String if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a UUID String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Returns: `true` if the string was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the string could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent(
        string uuid: UUID
    ) throws -> Bool {
        guard let value = try nextIfPresent(string: UUID.self) else { return false }
        
        guard value == uuid
        else { throw BytesError.checkedSequenceNotFound }
        
        return true
    }
}


// MARK: - AsyncByteIterator

#if compiler(>=5.5) && canImport(_Concurrency)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncIteratorProtocol where Element == Byte {
    /// Asynchronously advances to the next binary UUID, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Returns: A UUID.
    /// - Throws: `BytesError.invalidMemorySize` if 16 bytes are not available.
    @inlinable
    public mutating func next(_ type: UUID.Type) async throws -> UUID {
        try UUID(bytes: await next(Bytes.self, count: MemoryLayout<uuid_t>.size))
    }
    
    /// Asynchronously advances to the next UUID String, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Returns: A UUID.
    /// - Throws: `BytesError.invalidMemorySize` if 36 bytes are not available.
    @inlinable
    public mutating func next(string type: UUID.Type) async throws -> UUID {
        try UUID(stringBytes: await next(Bytes.self, count: MemoryLayout<UUIDTextualBytes>.size))
    }
    
    /// Asynchronously advances to the next binary UUID, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Returns: A UUID, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if 16 bytes are not available.
    @inlinable
    public mutating func nextIfPresent(_ type: UUID.Type) async throws -> UUID? {
        try await nextIfPresent(Bytes.self, count: MemoryLayout<uuid_t>.size).map { try UUID(bytes: $0) }
    }
    
    /// Asynchronously advances to the next UUID String, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `UUID.self`.
    /// - Returns: A UUID, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if 36 bytes are not available.
    @inlinable
    public mutating func nextIfPresent(string type: UUID.Type) async throws -> UUID? {
        try await nextIfPresent(Bytes.self, count: MemoryLayout<UUIDTextualBytes>.size).map { try UUID(stringBytes: $0) }
    }
    
    /// Asynchronously advances by the specified binary UUID if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a binary UUID to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the string could not be identified.
    @inlinable
    public mutating func check(
        _ uuid: UUID
    ) async throws {
        try await check(uuid.bytes)
    }
    
    /// Asynchronously advances by the specified UUID String if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a UUID String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the string could not be identified.
    @inlinable
    public mutating func check(
        string uuid: UUID
    ) async throws {
        let value = try await next(string: UUID.self)
        
        guard value == uuid
        else { throw BytesError.checkedSequenceNotFound }
    }
    
    /// Asynchronously advances by the specified binary UUID if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a binary UUID to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Returns: `true` if the string was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the string could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent(
        _ uuid: UUID
    ) async throws -> Bool {
        try await checkIfPresent(uuid.bytes)
    }
    
    /// Asynchronously advances by the specified UUID String if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a UUID String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter uuid: The UUID to check for.
    /// - Returns: `true` if the string was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the string could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent(
        string uuid: UUID
    ) async throws -> Bool {
        guard let value = try await nextIfPresent(string: UUID.self) else { return false }
        
        guard value == uuid
        else { throw BytesError.checkedSequenceNotFound }
        
        return true
    }
}

#endif
