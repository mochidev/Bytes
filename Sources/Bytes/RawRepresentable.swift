//
//  RawRepresentable.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 11/7/20.
//  Copyright © 2020 Mochi Development, Inc. All rights reserved.
//

extension RawRepresentable {
    /// The Bytes representation of the `rawValue`.
    @inlinable
    public var rawBytes: Bytes {
        Bytes(casting: self.rawValue)
    }
    
    /// Initialize a raw representable type from a contiguous sequence of Bytes representing the `rawValue`.
    /// - Parameter bigEndianBytes: The Bytes to interpret as a big endian integer.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence does not match the size of the `rawValue`'s type.
    ///     - `BytesError.contiguousMemoryUnavailable` if the byte sequence cannot be made to be contiguous.
    ///     - `BytesError.invalidRawRepresentableByteSequence` if the byte sequence does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(rawBytes: Bytes) throws {
        guard let value = Self(rawValue: try rawBytes.casting()) else {
            throw BytesError.invalidRawRepresentableByteSequence
        }
        self = value
    }
}

extension RawRepresentable where RawValue: FixedWidthInteger {
    /// The big endian representation of the `rawValue`'s integer.
    @inlinable
    public var bigEndianBytes: Bytes {
        self.rawValue.bigEndianBytes
    }
    
    /// Initialize a raw representable type as a fixed width integer from a contiguous sequence of Bytes representing a big endian type.
    /// - Parameter bigEndianBytes: The Bytes to interpret as a big endian integer.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence does not match the size of the integer type.
    ///     - `BytesError.contiguousMemoryUnavailable` if the byte sequence cannot be made to be contiguous.
    ///     - `BytesError.invalidRawRepresentableByteSequence` if the integer does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(bigEndianBytes: Bytes) throws {
        guard let value = Self(rawValue: try RawValue(bigEndianBytes: bigEndianBytes)) else {
            throw BytesError.invalidRawRepresentableByteSequence
        }
        self = value
    }
    
    /// The little endian representation of the `rawValue`'s integer.
    @inlinable
    public var littleEndianBytes: Bytes {
        self.rawValue.littleEndianBytes
    }
    
    /// Initialize a raw representable type as a fixed width integer from a contiguous sequence of Bytes representing a little endian type.
    /// - Parameter bigEndianBytes: The Bytes to interpret as a little endian integer.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence does not match the size of the integer type.
    ///     - `BytesError.contiguousMemoryUnavailable` if the byte sequence cannot be made to be contiguous.
    ///     - `BytesError.invalidRawRepresentableByteSequence` if the integer does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(littleEndianBytes: Bytes) throws  {
        guard let value = Self(rawValue: try RawValue(littleEndianBytes: littleEndianBytes)) else {
            throw BytesError.invalidRawRepresentableByteSequence
        }
        self = value
    }
}

extension RawRepresentable where RawValue: StringProtocol {
    /// Get the UTF-8 representation of the `rawValue`'s string as a contiguous sequence of Bytes.
    @inlinable
    public var utf8Bytes: Bytes {
        self.rawValue.utf8Bytes
    }
    
    /// Initialize a raw representable type as a String from a contiguous sequence of Bytes representing the `rawValue`.
    /// - Parameter utf8Bytes: The Bytes to interpret as a string.
    /// - Throws:
    ///     - `BytesError.invalidRawRepresentableByteSequence` if the byte sequence does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(utf8Bytes: Bytes) throws {
        guard let value = Self(rawValue: RawValue(utf8Bytes: utf8Bytes)) else {
            throw BytesError.invalidRawRepresentableByteSequence
        }
        self = value
    }
}

extension RawRepresentable where RawValue == Character {
    /// Get the UTF-8 representation of the `rawValue`'s character as a contiguous sequence of Bytes.
    @inlinable
    public var utf8Bytes: Bytes {
        self.rawValue.utf8Bytes
    }
    
    /// Initialize a raw representable type as a Character from a contiguous sequence of Bytes representing the `rawValue`.
    /// - Parameter utf8Bytes: The Bytes to interpret as a string.
    /// - Throws:
    ///     - `BytesError.invalidCharacterByteSequence` if the byte sequence does not represent a single character.
    ///     - `BytesError.invalidRawRepresentableByteSequence` if the byte sequence does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(utf8Bytes: Bytes) throws {
        guard let value = try Self(rawValue: RawValue(utf8Bytes: utf8Bytes)) else {
            throw BytesError.invalidRawRepresentableByteSequence
        }
        self = value
    }
}

// MARK: - Collection Extensions

extension Collection where Element: RawRepresentable {
    /// The Bytes representations of a collection of `rawValue`s.
    @inlinable
    public var rawBytes: Bytes {
        self.bytes(for: Element.RawValue.self, mapping: \.rawBytes)
    }
    
    /// Initialize a collection of raw representable types with a sequence of Bytes representing the `rawValue`s.
    /// - Parameter rawBytes: The Bytes to interpret as a sequence of `rawValue`s.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not a multiple of the size of the `rawValue`'s type.
    ///     - `BytesError.contiguousMemoryUnavailable` if a byte sub-sequence cannot be made to be contiguous.
    ///     - `BytesError.invalidRawRepresentableByteSequence` if the byte sequence does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(rawBytes: Bytes) throws where Self: RangeReplaceableCollection {
        try self.init(bytes: rawBytes, element: Element.RawValue.self, mapping: Element.init(rawBytes:))
    }
}

extension Collection where Element: RawRepresentable, Element.RawValue: FixedWidthInteger {
    /// The big endian representations of a collection of `rawValue` integers.
    @inlinable
    public var bigEndianBytes: Bytes {
        self.bytes(for: Element.RawValue.self, mapping: \.bigEndianBytes)
    }
    
    /// Initialize a collection of raw representable types with a sequence of Bytes representing a sequence of big endian `rawValue`s.
    /// - Parameter bigEndianBytes: The Bytes to interpret as a sequence of big endian integer `rawValue`s.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not a multiple of the size of the integer type.
    ///     - `BytesError.contiguousMemoryUnavailable` if the byte sequence cannot be made to be contiguous.
    ///     - `BytesError.invalidRawRepresentableByteSequence` if the integer does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(bigEndianBytes: Bytes) throws where Self: RangeReplaceableCollection {
        try self.init(bytes: bigEndianBytes, element: Element.RawValue.self, mapping: Element.init(bigEndianBytes:))
    }
    
    /// The little endian representations of a collection of `rawValue` integers.
    @inlinable
    public var littleEndianBytes: Bytes {
        self.bytes(for: Element.RawValue.self, mapping: \.littleEndianBytes)
    }
    
    /// Initialize a collection of raw representable types with a sequence of Bytes representing a sequence of little endian `rawValue`s.
    /// - Parameter littleEndianBytes: The Bytes to interpret as a sequence of little endian integer `rawValue`s.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not a multiple of the size of the integer type.
    ///     - `BytesError.contiguousMemoryUnavailable` if the byte sequence cannot be made to be contiguous.
    ///     - `BytesError.invalidRawRepresentableByteSequence` if the integer does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(littleEndianBytes: Bytes) throws where Self: RangeReplaceableCollection {
        try self.init(bytes: littleEndianBytes, element: Element.RawValue.self, mapping: Element.init(littleEndianBytes:))
    }
}

// MARK: - Set Extensions

extension Set where Element: RawRepresentable {
    /// Initialize a Set of raw representable types with a sequence of Bytes representing the `rawValue`s.
    /// - Parameter rawBytes: The Bytes to interpret as a sequence of big endian integer.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not a multiple of the size of the `rawValue`'s type.
    ///     - `BytesError.contiguousMemoryUnavailable` if a byte sub-sequence cannot be made to be contiguous.
    ///     - `BytesError.invalidRawRepresentableByteSequence` if the byte sequence does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(rawBytes: Bytes) throws {
        try self.init(bytes: rawBytes, element: Element.RawValue.self, mapping: Element.init(rawBytes:))
    }
}

extension Set where Element: RawRepresentable, Element.RawValue: FixedWidthInteger {
    /// Initialize a Set of raw representable types with a sequence of Bytes representing a sequence of big endian `rawValue`s.
    /// - Parameter bigEndianBytes: The Bytes to interpret as a sequence of big endian integer `rawValue`s.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not a multiple of the size of the integer type.
    ///     - `BytesError.contiguousMemoryUnavailable` if the byte sequence cannot be made to be contiguous.
    ///     - `BytesError.invalidRawRepresentableByteSequence` if the integer does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(bigEndianBytes: Bytes) throws {
        try self.init(bytes: bigEndianBytes, element: Element.RawValue.self, mapping: Element.init(bigEndianBytes:))
    }
    
    /// Initialize a Set of raw representable types with a sequence of Bytes representing a sequence of little endian `rawValue`s.
    /// - Parameter littleEndianBytes: The Bytes to interpret as a sequence of little endian integer `rawValue`s.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not a multiple of the size of the integer type.
    ///     - `BytesError.contiguousMemoryUnavailable` if the byte sequence cannot be made to be contiguous.
    ///     - `BytesError.invalidRawRepresentableByteSequence` if the integer does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(littleEndianBytes: Bytes) throws {
        try self.init(bytes: littleEndianBytes, element: Element.RawValue.self, mapping: Element.init(littleEndianBytes:))
    }
}


// MARK: - ByteIterator

extension IteratorProtocol where Element == Byte {
    /// Advances to the next raw representable in the squence and returns it, or throws if it could not.
    ///
    /// If a complete raw representable could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable of type `type`.
    /// - Throws: `BytesError.invalidMemorySize` if a complete raw representable could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next<T: RawRepresentable>(raw type: T.Type) throws -> T {
        try T(rawBytes: next(Bytes.self, count: MemoryLayout<T.RawValue>.size))
    }
    
    /// Advances to the next raw representable in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete raw representable could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable of type `type`, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if a complete raw representable could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent<T: RawRepresentable>(raw type: T.Type) throws -> T? {
        try nextIfPresent(Bytes.self, count: MemoryLayout<T.RawValue>.size).map { try T(rawBytes: $0) }
    }
}

extension IteratorProtocol where Element == Byte {
    /// Advances to the next little endian integer in the squence and returns it, or throws if it could not.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable type as a fixed width integer of type `type`.
    /// - Throws: `BytesError.invalidMemorySize` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next<T: RawRepresentable>(littleEndian type: T.Type) throws -> T where T.RawValue: FixedWidthInteger {
        try T(littleEndianBytes: next(Bytes.self, count: MemoryLayout<T.RawValue>.size))
    }
    
    /// Advances to the next big endian integer in the squence and returns it, or throws if it could not.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable type as a fixed width integer of type `type`.
    /// - Throws: `BytesError.invalidMemorySize` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next<T: RawRepresentable>(bigEndian type: T.Type) throws -> T where T.RawValue: FixedWidthInteger {
        try T(bigEndianBytes: next(Bytes.self, count: MemoryLayout<T.RawValue>.size))
    }
    
    /// Advances to the next little endian integer in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable type as a fixed width integer of type `type`, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent<T: RawRepresentable>(littleEndian type: T.Type) throws -> T? where T.RawValue: FixedWidthInteger {
        try nextIfPresent(Bytes.self, count: MemoryLayout<T.RawValue>.size).map { try T(littleEndianBytes: $0) }
    }
    
    /// Advances to the next big endian integer in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable type as a fixed width integer of type `type`, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent<T: RawRepresentable>(bigEndian type: T.Type) throws -> T? where T.RawValue: FixedWidthInteger {
        try nextIfPresent(Bytes.self, count: MemoryLayout<T.RawValue>.size).map { try T(bigEndianBytes: $0) }
    }
    
    /// Advances by the next byte if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    public mutating func check<RawInt: RawRepresentable>(
        _ integer: RawInt
    ) throws where RawInt.RawValue == UInt8 {
        try check(integer.rawValue)
    }
    
    /// Advances by the next little endien integer if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    public mutating func check<RawInt: RawRepresentable>(
        littleEndian integer: RawInt
    ) throws where RawInt.RawValue: FixedWidthInteger {
        try check(integer.littleEndianBytes)
    }
    
    /// Advances by the next big endien integer if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    public mutating func check<RawInt: RawRepresentable>(
        bigEndian integer: RawInt
    ) throws where RawInt.RawValue: FixedWidthInteger {
        try check(integer.bigEndianBytes)
    }
    
    /// Advances by the byte if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Returns: `true` if the integer was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<RawInt: RawRepresentable>(
        _ integer: RawInt
    ) throws -> Bool where RawInt.RawValue == UInt8 {
        try checkIfPresent(integer.rawValue)
    }
    
    /// Advances by the next little endien integer if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Returns: `true` if the integer was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<RawInt: RawRepresentable>(
        littleEndian integer: RawInt
    ) throws -> Bool where RawInt.RawValue: FixedWidthInteger {
        try checkIfPresent(integer.littleEndianBytes)
    }
    
    /// Advances by the next big endien integer if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Returns: `true` if the integer was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<RawInt: RawRepresentable>(
        bigEndian integer: RawInt
    ) throws -> Bool where RawInt.RawValue: FixedWidthInteger {
        try checkIfPresent(integer.bigEndianBytes)
    }
}


// MARK: - AsyncByteIterator

#if compiler(>=5.5) && canImport(_Concurrency)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncIteratorProtocol where Element == Byte {
    /// Asynchronously advances to the next raw representable in the squence and returns it, or throws if it could not.
    ///
    /// If a complete raw representable could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable type as a fixed width integer of type `type`.
    /// - Throws: `BytesError.invalidMemorySize` if a complete raw representable could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next<T: RawRepresentable>(raw type: T.Type) async throws -> T {
        try T(rawBytes: await next(Bytes.self, count: MemoryLayout<T.RawValue>.size))
    }
    
    /// Asynchronously advances to the next raw representable in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete raw representable could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable of type `type`, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if a complete raw representable could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent<T: RawRepresentable>(raw type: T.Type) async throws -> T? {
        try await nextIfPresent(Bytes.self, count: MemoryLayout<T.RawValue>.size).map { try T(rawBytes: $0) }
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncIteratorProtocol where Element == Byte {
    /// Asynchronously advances to the next little endian integer in the squence and returns it, or throws if it could not.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable type as a fixed width integer of type `type`.
    /// - Throws: `BytesError.invalidMemorySize` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next<T: RawRepresentable>(littleEndian type: T.Type) async throws -> T where T.RawValue: FixedWidthInteger {
        try T(littleEndianBytes: await next(Bytes.self, count: MemoryLayout<T.RawValue>.size))
    }
    
    /// Asynchronously advances to the next big endian integer in the squence and returns it, or throws if it could not.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable type as a fixed width integer of type `type`.
    /// - Throws: `BytesError.invalidMemorySize` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next<T: RawRepresentable>(bigEndian type: T.Type) async throws -> T where T.RawValue: FixedWidthInteger {
        try T(bigEndianBytes: await next(Bytes.self, count: MemoryLayout<T.RawValue>.size))
    }
    
    /// Asynchronously advances to the next little endian integer in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable type as a fixed width integer of type `type`, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent<T: RawRepresentable>(littleEndian type: T.Type) async throws -> T? where T.RawValue: FixedWidthInteger {
        try await nextIfPresent(Bytes.self, count: MemoryLayout<T.RawValue>.size).map { try T(littleEndianBytes: $0) }
    }
    
    /// Asynchronously advances to the next big endian integer in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable type as a fixed width integer of type `type`, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent<T: RawRepresentable>(bigEndian type: T.Type) async throws -> T? where T.RawValue: FixedWidthInteger {
        try await nextIfPresent(Bytes.self, count: MemoryLayout<T.RawValue>.size).map { try T(bigEndianBytes: $0) }
    }
    
    /// Asynchronously advances by the next byte if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    public mutating func check<RawInt: RawRepresentable>(
        _ integer: RawInt
    ) async throws where RawInt.RawValue == UInt8 {
        try await check(integer.rawValue)
    }
    
    /// Asynchronously advances by the next little endien integer if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    public mutating func check<RawInt: RawRepresentable>(
        littleEndian integer: RawInt
    ) async throws where RawInt.RawValue: FixedWidthInteger {
        try await check(integer.littleEndianBytes)
    }
    
    /// Asynchronously advances by the next big endien integer if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    public mutating func check<RawInt: RawRepresentable>(
        bigEndian integer: RawInt
    ) async throws where RawInt.RawValue: FixedWidthInteger {
        try await check(integer.bigEndianBytes)
    }
    
    /// Asynchronously advances by the byte if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Returns: `true` if the integer was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<RawInt: RawRepresentable>(
        _ integer: RawInt
    ) async throws -> Bool where RawInt.RawValue == UInt8 {
        try await checkIfPresent(integer.rawValue)
    }
    
    /// Asynchronously advances by the next little endien integer if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Returns: `true` if the integer was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<RawInt: RawRepresentable>(
        littleEndian integer: RawInt
    ) async throws -> Bool where RawInt.RawValue: FixedWidthInteger {
        try await checkIfPresent(integer.littleEndianBytes)
    }
    
    /// Asynchronously advances by the next big endien integer if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Returns: `true` if the integer was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<RawInt: RawRepresentable>(
        bigEndian integer: RawInt
    ) async throws -> Bool where RawInt.RawValue: FixedWidthInteger {
        try await checkIfPresent(integer.bigEndianBytes)
    }
}

#endif
