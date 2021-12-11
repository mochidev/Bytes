//
//  Integer.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 11/7/20.
//  Copyright © 2020 Mochi Development, Inc. All rights reserved.
//

extension FixedWidthInteger {
    /// The big endian representation of the integer.
    @inlinable
    public var bigEndianBytes: Bytes {
        Bytes(casting: self.bigEndian)
    }
    
    /// Initialize a fixed width integer from a contiguous sequence of Bytes representing a big endian type.
    /// - Parameter bigEndianBytes: The Bytes to interpret as a big endian integer.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence does not match the size of the integer type.
    ///     - `BytesError.contiguousMemoryUnavailable` if the byte sequence cannot be made to be contiguous.
    @inlinable
    public init<Bytes: BytesCollection>(bigEndianBytes: Bytes) throws {
        self.init(bigEndian: try bigEndianBytes.casting())
    }
    
    /// The little endian representation of the integer.
    @inlinable
    public var littleEndianBytes: Bytes {
        Bytes(casting: self.littleEndian)
    }
    
    /// Initialize a fixed width integer from a contiguous sequence of Bytes representing a little endian type.
    /// - Parameter bigEndianBytes: The Bytes to interpret as a little endian integer.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence does not match the size of the integer type.
    ///     - `BytesError.contiguousMemoryUnavailable` if the byte sequence cannot be made to be contiguous.
    @inlinable
    public init<Bytes: BytesCollection>(littleEndianBytes: Bytes) throws {
        self.init(littleEndian: try littleEndianBytes.casting())
    }
}

extension Collection where Element: FixedWidthInteger {
    /// The big endian representations of a collection of integers.
    @inlinable
    public var bigEndianBytes: Bytes {
        self.bytes(mapping: \.bigEndianBytes)
    }
    
    /// Initialize a collection of integers with a sequence of Bytes representing a sequence of big endian types.
    /// - Parameter bigEndianBytes: The Bytes to interpret as a sequence of big endian integers.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not a multiple of the size of the integer type.
    ///     - `BytesError.contiguousMemoryUnavailable` if a byte sub-sequence cannot be made to be contiguous.
    @inlinable
    public init<Bytes: BytesCollection>(bigEndianBytes: Bytes) throws where Self: RangeReplaceableCollection {
        try self.init(bytes: bigEndianBytes, mapping: Element.init(bigEndianBytes:))
    }
    
    /// The little endian representations of a collection of integers.
    @inlinable
    public var littleEndianBytes: Bytes {
        self.bytes(mapping: \.littleEndianBytes)
    }
    
    /// Initialize a collection of integers with a sequence of Bytes representing a sequence of little endian types.
    /// - Parameter littleEndianBytes: The Bytes to interpret as a sequence of little endian integers.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not a multiple of the size of the integer type.
    ///     - `BytesError.contiguousMemoryUnavailable` if a byte sub-sequence cannot be made to be contiguous.
    @inlinable
    public init<Bytes: BytesCollection>(littleEndianBytes: Bytes) throws where Self: RangeReplaceableCollection {
        try self.init(bytes: littleEndianBytes, mapping: Element.init(littleEndianBytes:))
    }
}

extension Set where Element: FixedWidthInteger {
    /// Initialize a Set of integers with a sequence of Bytes representing a sequence of big endian types.
    /// - Parameter bigEndianBytes: The Bytes to interpret as a sequence of big endian integers.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not a multiple of the size of the integer type.
    ///     - `BytesError.contiguousMemoryUnavailable` if a byte sub-sequence cannot be made to be contiguous.
    @inlinable
    public init<Bytes: BytesCollection>(bigEndianBytes: Bytes) throws {
        try self.init(bytes: bigEndianBytes, mapping: Element.init(bigEndianBytes:))
    }
    
    /// Initialize a Set of integers with a sequence of Bytes representing a sequence of little endian types.
    /// - Parameter littleEndianBytes: The Bytes to interpret as a sequence of little endian integers.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not a multiple of the size of the integer type.
    ///     - `BytesError.contiguousMemoryUnavailable` if a byte sub-sequence cannot be made to be contiguous.
    @inlinable
    public init<Bytes: BytesCollection>(littleEndianBytes: Bytes) throws {
        try self.init(bytes: littleEndianBytes, mapping: Element.init(littleEndianBytes:))
    }
}


// MARK: - ByteIterator

extension IteratorProtocol where Element == Byte {
    /// Advances to the next little endian integer in the squence and returns it, or throws if it could not.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of integer to decode.
    /// - Returns: An integer of type `type`.
    /// - Throws: `BytesError.invalidMemorySize` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next<T: FixedWidthInteger>(littleEndian type: T.Type) throws -> T {
        try T(littleEndianBytes: next(bytes: Bytes.self, count: MemoryLayout<T>.size))
    }
    
    /// Advances to the next big endian integer in the squence and returns it, or throws if it could not.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of integer to decode.
    /// - Returns: An integer of type `type`.
    /// - Throws: `BytesError.invalidMemorySize` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next<T: FixedWidthInteger>(bigEndian type: T.Type) throws -> T {
        try T(bigEndianBytes: next(bytes: Bytes.self, count: MemoryLayout<T>.size))
    }
    
    /// Advances to the next little endian integer in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of integer to decode.
    /// - Returns: An integer of type `type`, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent<T: FixedWidthInteger>(littleEndian type: T.Type) throws -> T? {
        try nextIfPresent(bytes: Bytes.self, count: MemoryLayout<T>.size).map { try T(littleEndianBytes: $0) }
    }
    
    /// Advances to the next big endian integer in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of integer to decode.
    /// - Returns: An integer of type `type`, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent<T: FixedWidthInteger>(bigEndian type: T.Type) async throws -> T? {
        try nextIfPresent(bytes: Bytes.self, count: MemoryLayout<T>.size).map { try T(bigEndianBytes: $0) }
    }
}


// MARK: - AsyncByteIterator

#if compiler(>=5.5) && canImport(_Concurrency)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncIteratorProtocol where Element == Byte {
    /// Asynchronously advances to the next little endian integer in the squence and returns it, or throws if it could not.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of integer to decode.
    /// - Returns: An integer of type `type`.
    /// - Throws: `BytesError.invalidMemorySize` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next<T: FixedWidthInteger>(littleEndian type: T.Type) async throws -> T {
        try T(littleEndianBytes: await next(bytes: Bytes.self, count: MemoryLayout<T>.size))
    }
    
    /// Asynchronously advances to the next big endian integer in the squence and returns it, or throws if it could not.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of integer to decode.
    /// - Returns: An integer of type `type`.
    /// - Throws: `BytesError.invalidMemorySize` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next<T: FixedWidthInteger>(bigEndian type: T.Type) async throws -> T {
        try T(bigEndianBytes: await next(bytes: Bytes.self, count: MemoryLayout<T>.size))
    }
    
    /// Asynchronously advances to the next little endian integer in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of integer to decode.
    /// - Returns: An integer of type `type`, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent<T: FixedWidthInteger>(littleEndian type: T.Type) async throws -> T? {
        try await nextIfPresent(bytes: Bytes.self, count: MemoryLayout<T>.size).map { try T(littleEndianBytes: $0) }
    }
    
    /// Asynchronously advances to the next big endian integer in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of integer to decode.
    /// - Returns: An integer of type `type`, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent<T: FixedWidthInteger>(bigEndian type: T.Type) async throws -> T? {
        try await nextIfPresent(bytes: Bytes.self, count: MemoryLayout<T>.size).map { try T(bigEndianBytes: $0) }
    }
}

#endif
