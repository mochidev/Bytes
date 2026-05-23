//
//  RawRepresentable.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 11/7/20.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

extension RawRepresentable {
    /// The ``Bytes`` representation of the `rawValue`.
    @inlinable
    public var rawBytes: Bytes {
        Bytes(casting: self.rawValue)
    }
    
    /// Initialize a raw representable type from a contiguous sequence of ``Bytes`` representing the `rawValue`.
    /// - Parameter rawBytes: The ``Bytes`` to interpret as the raw value for the type.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence does not match the size of the `rawValue`'s type.
    ///     - ``BytesError/ContiguousBytesError/contiguousBytesUnavailable(type:)-enum.case`` if the byte sequence cannot be made to be contiguous.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the byte sequence does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(
        rawBytes: Bytes
    ) throws(BytesError.RawRepresentable.ContiguousBytes.BufferSizeError) {
        let rawValue: RawValue
        do {
            rawValue = try rawBytes.casting()
        } catch {
            throw .castingFailure(error)
        }
        guard let value = Self(rawValue: rawValue)
        else { throw .invalidRawRepresentableByteSequence(rawType: "\(RawValue.self)") }
        self = value
    }
    
    /// Initialize a raw representable type from a contiguous sequence of ``Bytes`` representing the `rawValue`.
    /// - Parameter rawBytes: The ``Bytes`` to interpret as the raw value for the type.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence does not match the size of the `rawValue`'s type.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the byte sequence does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: ContiguousBytesCollection>(
        rawBytes: Bytes
    ) throws(BytesError.RawRepresentable.BufferSizeError) {
        let rawValue: RawValue
        do {
            rawValue = try rawBytes.casting()
        } catch {
            throw .castingFailure(error)
        }
        guard let value = Self(rawValue: rawValue)
        else { throw .invalidRawRepresentableByteSequence(rawType: "\(RawValue.self)") }
        self = value
    }
}

extension RawRepresentable where RawValue: FixedWidthInteger {
    /// The big endian representation of the `rawValue`'s integer.
    @inlinable
    public var bigEndianBytes: Bytes {
        self.rawValue.bigEndianBytes
    }
    
    /// Initialize a raw representable type as a fixed width integer from a contiguous sequence of ``Bytes`` representing a big endian type.
    /// - Parameter bigEndianBytes: The ``Bytes`` to interpret as a big endian integer.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence does not match the size of the integer type.
    ///     - ``BytesError/ContiguousBytesError/contiguousBytesUnavailable(type:)-enum.case`` if the byte sequence cannot be made to be contiguous.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the integer does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(
        bigEndianBytes: Bytes
    ) throws(BytesError.RawRepresentable.ContiguousBytes.BufferSizeError) {
        let rawValue: RawValue
        do {
            rawValue = try RawValue(bigEndianBytes: bigEndianBytes)
        } catch {
            throw .castingFailure(error)
        }
        guard let value = Self(rawValue: rawValue)
        else { throw .invalidRawRepresentableByteSequence(rawType: "\(RawValue.self)") }
        self = value
    }
    
    /// Initialize a raw representable type as a fixed width integer from a contiguous sequence of ``Bytes`` representing a big endian type.
    /// - Parameter bigEndianBytes: The ``Bytes`` to interpret as a big endian integer.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence does not match the size of the integer type.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the integer does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: ContiguousBytesCollection>(
        bigEndianBytes: Bytes
    ) throws(BytesError.RawRepresentable.BufferSizeError) {
        let rawValue: RawValue
        do {
            rawValue = try RawValue(bigEndianBytes: bigEndianBytes)
        } catch {
            throw .castingFailure(error)
        }
        guard let value = Self(rawValue: rawValue)
        else { throw .invalidRawRepresentableByteSequence(rawType: "\(RawValue.self)") }
        self = value
    }
    
    /// The little endian representation of the `rawValue`'s integer.
    @inlinable
    public var littleEndianBytes: Bytes {
        self.rawValue.littleEndianBytes
    }
    
    /// Initialize a raw representable type as a fixed width integer from a contiguous sequence of ``Bytes`` representing a little endian type.
    /// - Parameter littleEndianBytes: The ``Bytes`` to interpret as a little endian integer.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence does not match the size of the integer type.
    ///     - ``BytesError/ContiguousBytesError/contiguousBytesUnavailable(type:)-enum.case`` if the byte sequence cannot be made to be contiguous.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the integer does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(
        littleEndianBytes: Bytes
    ) throws(BytesError.RawRepresentable.ContiguousBytes.BufferSizeError) {
        let rawValue: RawValue
        do {
            rawValue = try RawValue(littleEndianBytes: littleEndianBytes)
        } catch {
            throw .castingFailure(error)
        }
        guard let value = Self(rawValue: rawValue)
        else { throw .invalidRawRepresentableByteSequence(rawType: "\(RawValue.self)") }
        self = value
    }
    
    /// Initialize a raw representable type as a fixed width integer from a contiguous sequence of ``Bytes`` representing a little endian type.
    /// - Parameter littleEndianBytes: The ``Bytes`` to interpret as a little endian integer.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence does not match the size of the integer type.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the integer does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: ContiguousBytesCollection>(
        littleEndianBytes: Bytes
    ) throws(BytesError.RawRepresentable.BufferSizeError) {
        let rawValue: RawValue
        do {
            rawValue = try RawValue(littleEndianBytes: littleEndianBytes)
        } catch {
            throw .castingFailure(error)
        }
        guard let value = Self(rawValue: rawValue)
        else { throw .invalidRawRepresentableByteSequence(rawType: "\(RawValue.self)") }
        self = value
    }
}

extension RawRepresentable where RawValue: StringProtocol {
    /// Get the UTF-8 representation of the `rawValue`'s string as a contiguous sequence of ``Bytes``.
    @inlinable
    public var utf8Bytes: Bytes {
        self.rawValue.utf8Bytes
    }
    
    /// Initialize a raw representable type as a String from a contiguous sequence of ``Bytes`` representing the `rawValue`.
    /// - Parameter utf8Bytes: The ``Bytes`` to interpret as a string.
    /// - Throws:
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the byte sequence does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(
        utf8Bytes: Bytes
    ) throws(BytesError.RawRepresentableError<Never>) {
        guard let value = Self(rawValue: RawValue(utf8Bytes: utf8Bytes))
        else { throw .invalidRawRepresentableByteSequence(rawType: "\(RawValue.self)") }
        self = value
    }
}

extension RawRepresentable where RawValue == Character {
    /// Get the UTF-8 representation of the `rawValue`'s character as a contiguous sequence of ``Bytes``.
    @inlinable
    public var utf8Bytes: Bytes {
        self.rawValue.utf8Bytes
    }
    
    /// Initialize a raw representable type as a Character from a contiguous sequence of ``Bytes`` representing the `rawValue`.
    /// - Parameter utf8Bytes: The ``Bytes`` to interpret as a string.
    /// - Throws:
    ///     - ``BytesError/CharacterDecodingError/invalidCharacterByteSequence`` if the byte sequence does not represent a single character.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the byte sequence does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(
        utf8Bytes: Bytes
    ) throws(BytesError.RawRepresentable.CharacterDecodingError) {
        let rawValue: RawValue
        do {
            rawValue = try RawValue(utf8Bytes: utf8Bytes)
        } catch {
            throw .castingFailure(error)
        }
        guard let value = Self(rawValue: rawValue)
        else { throw .invalidRawRepresentableByteSequence(rawType: "\(RawValue.self)") }
        self = value
    }
}

// MARK: - Collection Extensions

extension Collection where Element: RawRepresentable {
    /// The ``Bytes`` representations of a collection of `rawValue`s.
    @inlinable
    public var rawBytes: Bytes {
        self.bytes(for: Element.RawValue.self, mapping: \.rawBytes)
    }
    
    /// Initialize a collection of raw representable types with a sequence of ``Bytes`` representing the `rawValue`s.
    /// - Parameter rawBytes: The ``Bytes`` to interpret as a sequence of `rawValue`s.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence is not a multiple of the size of the `rawValue`'s type.
    ///     - ``BytesError/ContiguousBytesError/contiguousBytesUnavailable(type:)-enum.case`` if a byte sub-sequence cannot be made to be contiguous.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the byte sequence does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(
        rawBytes: Bytes
    ) throws(BytesError.RawRepresentable.ContiguousBytes.BufferSizeError) where Self: RangeReplaceableCollection {
        do {
            try self.init(bytes: rawBytes, element: Element.RawValue.self, mapping: Element.init(rawBytes:))
        } catch {
            throw error.flattened
        }
    }
}

extension Collection where Element: RawRepresentable, Element.RawValue: FixedWidthInteger {
    /// The big endian representations of a collection of `rawValue` integers.
    @inlinable
    public var bigEndianBytes: Bytes {
        self.bytes(for: Element.RawValue.self, mapping: \.bigEndianBytes)
    }
    
    /// Initialize a collection of raw representable types with a sequence of ``Bytes`` representing a sequence of big endian `rawValue`s.
    /// - Parameter bigEndianBytes: The ``Bytes`` to interpret as a sequence of big endian integer `rawValue`s.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence is not a multiple of the size of the integer type.
    ///     - ``BytesError/ContiguousBytesError/contiguousBytesUnavailable(type:)-enum.case`` if the byte sequence cannot be made to be contiguous.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the integer does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(
        bigEndianBytes: Bytes
    ) throws(BytesError.RawRepresentable.ContiguousBytes.BufferSizeError) where Self: RangeReplaceableCollection {
        do {
            try self.init(bytes: bigEndianBytes, element: Element.RawValue.self, mapping: Element.init(bigEndianBytes:))
        } catch {
            throw error.flattened
        }
    }
    
    /// The little endian representations of a collection of `rawValue` integers.
    @inlinable
    public var littleEndianBytes: Bytes {
        self.bytes(for: Element.RawValue.self, mapping: \.littleEndianBytes)
    }
    
    /// Initialize a collection of raw representable types with a sequence of ``Bytes`` representing a sequence of little endian `rawValue`s.
    /// - Parameter littleEndianBytes: The ``Bytes`` to interpret as a sequence of little endian integer `rawValue`s.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence is not a multiple of the size of the integer type.
    ///     - ``BytesError/ContiguousBytesError/contiguousBytesUnavailable(type:)-enum.case`` if the byte sequence cannot be made to be contiguous.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the integer does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(
        littleEndianBytes: Bytes
    ) throws(BytesError.RawRepresentable.ContiguousBytes.BufferSizeError) where Self: RangeReplaceableCollection {
        do {
            try self.init(bytes: littleEndianBytes, element: Element.RawValue.self, mapping: Element.init(littleEndianBytes:))
        } catch {
            throw error.flattened
        }
    }
}

// MARK: - Set Extensions

extension Set where Element: RawRepresentable {
    /// Initialize a Set of raw representable types with a sequence of ``Bytes`` representing the `rawValue`s.
    /// - Parameter rawBytes: The ``Bytes`` to interpret as a sequence of big endian integer.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence is not a multiple of the size of the `rawValue`'s type.
    ///     - ``BytesError/ContiguousBytesError/contiguousBytesUnavailable(type:)-enum.case`` if a byte sub-sequence cannot be made to be contiguous.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the byte sequence does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(
        rawBytes: Bytes
    ) throws(BytesError.RawRepresentable.ContiguousBytes.BufferSizeError) {
        do {
            try self.init(bytes: rawBytes, element: Element.RawValue.self, mapping: Element.init(rawBytes:))
        } catch {
            throw error.flattened
        }
    }
}

extension Set where Element: RawRepresentable, Element.RawValue: FixedWidthInteger {
    /// Initialize a Set of raw representable types with a sequence of ``Bytes`` representing a sequence of big endian `rawValue`s.
    /// - Parameter bigEndianBytes: The ``Bytes`` to interpret as a sequence of big endian integer `rawValue`s.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence is not a multiple of the size of the integer type.
    ///     - ``BytesError/ContiguousBytesError/contiguousBytesUnavailable(type:)-enum.case`` if the byte sequence cannot be made to be contiguous.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the integer does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(
        bigEndianBytes: Bytes
    ) throws(BytesError.RawRepresentable.ContiguousBytes.BufferSizeError) {
        do {
            try self.init(bytes: bigEndianBytes, element: Element.RawValue.self, mapping: Element.init(bigEndianBytes:))
        } catch {
            throw error.flattened
        }
    }
    
    /// Initialize a Set of raw representable types with a sequence of ``Bytes`` representing a sequence of little endian `rawValue`s.
    /// - Parameter littleEndianBytes: The ``Bytes`` to interpret as a sequence of little endian integer `rawValue`s.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the byte sequence is not a multiple of the size of the integer type.
    ///     - ``BytesError/ContiguousBytesError/contiguousBytesUnavailable(type:)-enum.case`` if the byte sequence cannot be made to be contiguous.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the integer does not correspond with a valid raw value.
    @inlinable
    public init<Bytes: BytesCollection>(
        littleEndianBytes: Bytes
    ) throws(BytesError.RawRepresentable.ContiguousBytes.BufferSizeError) {
        do {
            try self.init(bytes: littleEndianBytes, element: Element.RawValue.self, mapping: Element.init(littleEndianBytes:))
        } catch {
            throw error.flattened
        }
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
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete raw representable could not be returned by the time the sequence ended.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the byte sequence does not correspond with a valid raw value.
    @inlinable
    public mutating func next<T: RawRepresentable>(
        raw type: T.Type
    ) throws(BytesError.RawRepresentable.BufferSizeError) -> T {
        let rawBytes: Bytes
        do {
            rawBytes = try next(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw .castingFailure(error)
        }
        do {
            return try T(rawBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Advances to the next raw representable in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete raw representable could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable of type `type`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete raw representable could not be returned by the time the sequence ended.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the byte sequence does not correspond with a valid raw value.
    @inlinable
    public mutating func nextIfPresent<T: RawRepresentable>(
        raw type: T.Type
    ) throws(BytesError.RawRepresentable.BufferSizeError) -> T? {
        let rawBytes: Bytes?
        do {
            rawBytes = try nextIfPresent(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw .castingFailure(error)
        }
        guard let rawBytes else { return nil }
        do {
            return try T(rawBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Advances by the specified raw representable value if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a raw value to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter value: The raw value to check for.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the string could not be identified.
    @inlinable
    public mutating func check<Raw: RawRepresentable>(
        raw value: Raw
    ) throws(BytesError.SequenceCheckError) {
        try check(value.rawBytes)
    }
    
    /// Advances by the specified raw representable value if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a raw value to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter value: The raw value to check for.
    /// - Returns: `true` if the string was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the string could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<Raw: RawRepresentable>(
        raw value: Raw
    ) throws(BytesError.SequenceCheckError) -> Bool {
        try checkIfPresent(value.rawBytes)
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
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next<T: RawRepresentable>(
        littleEndian type: T.Type
    ) throws(BytesError.RawRepresentable.BufferSizeError) -> T where T.RawValue: FixedWidthInteger {
        let rawBytes: Bytes
        do {
            rawBytes = try next(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw .castingFailure(error)
        }
        do {
            return try T(littleEndianBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Advances to the next big endian integer in the squence and returns it, or throws if it could not.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable type as a fixed width integer of type `type`.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next<T: RawRepresentable>(
        bigEndian type: T.Type
    ) throws(BytesError.RawRepresentable.BufferSizeError) -> T where T.RawValue: FixedWidthInteger {
        let rawBytes: Bytes
        do {
            rawBytes = try next(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw .castingFailure(error)
        }
        do {
            return try T(bigEndianBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Advances to the next little endian integer in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable type as a fixed width integer of type `type`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent<T: RawRepresentable>(
        littleEndian type: T.Type
    ) throws(BytesError.RawRepresentable.BufferSizeError) -> T? where T.RawValue: FixedWidthInteger {
        let rawBytes: Bytes?
        do {
            rawBytes = try nextIfPresent(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw .castingFailure(error)
        }
        guard let rawBytes else { return nil }
        do {
            return try T(littleEndianBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Advances to the next big endian integer in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable type as a fixed width integer of type `type`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete integer could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent<T: RawRepresentable>(
        bigEndian type: T.Type
    ) throws(BytesError.RawRepresentable.BufferSizeError) -> T? where T.RawValue: FixedWidthInteger {
        let rawBytes: Bytes?
        do {
            rawBytes = try nextIfPresent(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw .castingFailure(error)
        }
        guard let rawBytes else { return nil }
        do {
            return try T(bigEndianBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Advances by the next byte if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    public mutating func check<RawInt: RawRepresentable>(
        _ integer: RawInt
    ) throws(BytesError.SequenceCheckError) where RawInt.RawValue == UInt8 {
        try check(integer.rawValue)
    }
    
    /// Advances by the next little endien integer if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    public mutating func check<RawInt: RawRepresentable>(
        littleEndian integer: RawInt
    ) throws(BytesError.SequenceCheckError) where RawInt.RawValue: FixedWidthInteger {
        try check(integer.littleEndianBytes)
    }
    
    /// Advances by the next big endien integer if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    public mutating func check<RawInt: RawRepresentable>(
        bigEndian integer: RawInt
    ) throws(BytesError.SequenceCheckError) where RawInt.RawValue: FixedWidthInteger {
        try check(integer.bigEndianBytes)
    }
    
    /// Advances by the byte if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Returns: `true` if the integer was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<RawInt: RawRepresentable>(
        _ integer: RawInt
    ) throws(BytesError.SequenceCheckError) -> Bool where RawInt.RawValue == UInt8 {
        try checkIfPresent(integer.rawValue)
    }
    
    /// Advances by the next little endien integer if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Returns: `true` if the integer was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<RawInt: RawRepresentable>(
        littleEndian integer: RawInt
    ) throws(BytesError.SequenceCheckError) -> Bool where RawInt.RawValue: FixedWidthInteger {
        try checkIfPresent(integer.littleEndianBytes)
    }
    
    /// Advances by the next big endien integer if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Returns: `true` if the integer was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<RawInt: RawRepresentable>(
        bigEndian integer: RawInt
    ) throws(BytesError.SequenceCheckError) -> Bool where RawInt.RawValue: FixedWidthInteger {
        try checkIfPresent(integer.bigEndianBytes)
    }
}

extension IteratorProtocol where Element == Byte {
    /// Advances by the specified UTF-8 encoded raw value Character if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a raw value Character to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter character: The character to check for.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the character could not be identified.
    @inlinable
    public mutating func check<RawCharacter: RawRepresentable>(
        utf8 character: RawCharacter
    ) throws(BytesError.SequenceCheckError) where RawCharacter.RawValue == Character {
        try check(character.utf8Bytes)
    }
    
    /// Advances by the specified UTF-8 encoded raw value String if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a raw value String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// If the String is empty, this method won't do anything.
    ///
    /// - Note: The string will not check for null termination unless a null character is specified.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter string: The string to check for.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the string could not be identified.
    @inlinable
    public mutating func check<RawString: RawRepresentable>(
        utf8 string: RawString
    ) throws(BytesError.SequenceCheckError) where RawString.RawValue: StringProtocol {
        try check(string.utf8Bytes)
    }
    
    /// Advances by the specified UTF-8 encoded raw value Character if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a raw value Character to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter character: The character to check for.
    /// - Returns: `true` if the character was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the character could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<RawCharacter: RawRepresentable>(
        utf8 character: RawCharacter
    ) throws(BytesError.SequenceCheckError) -> Bool where RawCharacter.RawValue == Character {
        try checkIfPresent(character.utf8Bytes)
    }
    
    /// Advances by the specified UTF-8 encoded raw value String if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a raw value String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// If the String is empty, this method won't do anything.
    ///
    /// - Note: The string will not check for null termination unless a null character is specified.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter string: The string to check for.
    /// - Returns: `true` if the string was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the string could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<RawString: RawRepresentable>(
        utf8 string: RawString
    ) throws(BytesError.SequenceCheckError) -> Bool where RawString.RawValue: StringProtocol {
        try checkIfPresent(string.utf8Bytes)
    }
}


// MARK: - AsyncByteIterator

#if canImport(Darwin)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncIteratorProtocol where Element == Byte {
    /// Asynchronously advances to the next raw representable in the squence and returns it, or throws if it could not.
    ///
    /// If a complete raw representable could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable type as a fixed width integer of type `type`.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete raw representable could not be returned by the time the sequence ended.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the byte sequence does not correspond with a valid raw value.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func next<T: RawRepresentable>(
        raw type: T.Type
    ) async throws(BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError) -> T {
        let rawBytes: Bytes
        do {
            rawBytes = try await next(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw error.mapCastingFailure { .castingFailure($0) }
        }
        do {
            return try T(rawBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Asynchronously advances to the next raw representable in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete raw representable could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable of type `type`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete raw representable could not be returned by the time the sequence ended.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the byte sequence does not correspond with a valid raw value.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func nextIfPresent<T: RawRepresentable>(
        raw type: T.Type
    ) async throws(BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError) -> T? {
        let rawBytes: Bytes?
        do {
            rawBytes = try await nextIfPresent(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw error.mapCastingFailure { .castingFailure($0) }
        }
        guard let rawBytes else { return nil }
        do {
            return try T(rawBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Asynchronously advances by the specified raw representable value if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a raw value to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter value: The raw value to check for.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the string could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func check<Raw: RawRepresentable>(
        raw value: Raw
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) {
        try await check(value.rawBytes)
    }
    
    /// Asynchronously advances by the specified raw representable value if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a raw value to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter value: The raw value to check for.
    /// - Returns: `true` if the string was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the string could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    @discardableResult
    public mutating func checkIfPresent<Raw: RawRepresentable>(
        raw value: Raw
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) -> Bool {
        try await checkIfPresent(value.rawBytes)
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
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete integer could not be returned by the time the sequence ended.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the integer does not correspond with a valid raw value.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func next<T: RawRepresentable>(
        littleEndian type: T.Type
    ) async throws(BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError) -> T where T.RawValue: FixedWidthInteger {
        let rawBytes: Bytes
        do {
            rawBytes = try await next(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw error.mapCastingFailure { .castingFailure($0) }
        }
        do {
            return try T(littleEndianBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Asynchronously advances to the next big endian integer in the squence and returns it, or throws if it could not.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable type as a fixed width integer of type `type`.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete integer could not be returned by the time the sequence ended.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the integer does not correspond with a valid raw value.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func next<T: RawRepresentable>(
        bigEndian type: T.Type
    ) async throws(BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError) -> T where T.RawValue: FixedWidthInteger {
        let rawBytes: Bytes
        do {
            rawBytes = try await next(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw error.mapCastingFailure { .castingFailure($0) }
        }
        do {
            return try T(bigEndianBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Asynchronously advances to the next little endian integer in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable type as a fixed width integer of type `type`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete integer could not be returned by the time the sequence ended.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the integer does not correspond with a valid raw value.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func nextIfPresent<T: RawRepresentable>(
        littleEndian type: T.Type
    ) async throws(BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError) -> T? where T.RawValue: FixedWidthInteger {
        let rawBytes: Bytes?
        do {
            rawBytes = try await nextIfPresent(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw error.mapCastingFailure { .castingFailure($0) }
        }
        guard let rawBytes else { return nil }
        do {
            return try T(littleEndianBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Asynchronously advances to the next big endian integer in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Returns: A raw representable type as a fixed width integer of type `type`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete integer could not be returned by the time the sequence ended.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the integer does not correspond with a valid raw value.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func nextIfPresent<T: RawRepresentable>(
        bigEndian type: T.Type
    ) async throws(BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError) -> T? where T.RawValue: FixedWidthInteger {
        let rawBytes: Bytes?
        do {
            rawBytes = try await nextIfPresent(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw error.mapCastingFailure { .castingFailure($0) }
        }
        guard let rawBytes else { return nil }
        do {
            return try T(bigEndianBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Asynchronously advances by the next byte if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func check<RawInt: RawRepresentable>(
        _ integer: RawInt
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) where RawInt.RawValue == UInt8 {
        try await check(integer.rawValue)
    }
    
    /// Asynchronously advances by the next little endien integer if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func check<RawInt: RawRepresentable>(
        littleEndian integer: RawInt
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) where RawInt.RawValue: FixedWidthInteger {
        try await check(integer.littleEndianBytes)
    }
    
    /// Asynchronously advances by the next big endien integer if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func check<RawInt: RawRepresentable>(
        bigEndian integer: RawInt
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) where RawInt.RawValue: FixedWidthInteger {
        try await check(integer.bigEndianBytes)
    }
    
    /// Asynchronously advances by the byte if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Returns: `true` if the integer was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    @discardableResult
    public mutating func checkIfPresent<RawInt: RawRepresentable>(
        _ integer: RawInt
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) -> Bool where RawInt.RawValue == UInt8 {
        try await checkIfPresent(integer.rawValue)
    }
    
    /// Asynchronously advances by the next little endien integer if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Returns: `true` if the integer was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    @discardableResult
    public mutating func checkIfPresent<RawInt: RawRepresentable>(
        littleEndian integer: RawInt
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) -> Bool where RawInt.RawValue: FixedWidthInteger {
        try await checkIfPresent(integer.littleEndianBytes)
    }
    
    /// Asynchronously advances by the next big endien integer if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Returns: `true` if the integer was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    @discardableResult
    public mutating func checkIfPresent<RawInt: RawRepresentable>(
        bigEndian integer: RawInt
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) -> Bool where RawInt.RawValue: FixedWidthInteger {
        try await checkIfPresent(integer.bigEndianBytes)
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncIteratorProtocol where Element == Byte {
    /// Asynchronously advances by the specified UTF-8 encoded raw value Character if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a raw value Character to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter character: The character to check for.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the character could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func check<RawCharacter: RawRepresentable>(
        utf8 character: RawCharacter
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) where RawCharacter.RawValue == Character {
        try await check(character.utf8Bytes)
    }
    
    /// Asynchronously advances by the specified UTF-8 encoded raw value String if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a raw value String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// If the String is empty, this method won't do anything.
    ///
    /// - Note: The string will not check for null termination unless a null character is specified.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter string: The string to check for.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the string could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func check<RawString: RawRepresentable>(
        utf8 string: RawString
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) where RawString.RawValue: StringProtocol {
        try await check(string.utf8Bytes)
    }
    
    /// Asynchronously advances by the specified UTF-8 encoded raw value Character if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a raw value Character to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter character: The character to check for.
    /// - Returns: `true` if the character was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the character could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    @discardableResult
    public mutating func checkIfPresent<RawCharacter: RawRepresentable>(
        utf8 character: RawCharacter
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) -> Bool where RawCharacter.RawValue == Character {
        try await checkIfPresent(character.utf8Bytes)
    }
    
    /// Asynchronously advances by the specified UTF-8 encoded raw value String if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a raw value String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// If the String is empty, this method won't do anything.
    ///
    /// - Note: The string will not check for null termination unless a null character is specified.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter string: The string to check for.
    /// - Returns: `true` if the character was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the character could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    @discardableResult
    public mutating func checkIfPresent<RawString: RawRepresentable>(
        utf8 string: RawString
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) -> Bool where RawString.RawValue: StringProtocol {
        try await checkIfPresent(string.utf8Bytes)
    }
}
#endif

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension AsyncIteratorProtocol where Element == Byte {
    /// Asynchronously advances to the next raw representable in the squence and returns it, or throws if it could not.
    ///
    /// If a complete raw representable could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A raw representable type as a fixed width integer of type `type`.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete raw representable could not be returned by the time the sequence ended.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the byte sequence does not correspond with a valid raw value.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func next<T: RawRepresentable>(
        raw type: T.Type,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.RawRepresentable.BufferSizeError) -> T {
        let rawBytes: Bytes
        do {
            rawBytes = try await next(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw error.mapCastingFailure { .castingFailure($0) }
        }
        do {
            return try T(rawBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Asynchronously advances to the next raw representable in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete raw representable could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A raw representable of type `type`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete raw representable could not be returned by the time the sequence ended.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the byte sequence does not correspond with a valid raw value.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func nextIfPresent<T: RawRepresentable>(
        raw type: T.Type,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.RawRepresentable.BufferSizeError) -> T? {
        let rawBytes: Bytes?
        do {
            rawBytes = try await nextIfPresent(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw error.mapCastingFailure { .castingFailure($0) }
        }
        guard let rawBytes else { return nil }
        do {
            return try T(rawBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Asynchronously advances by the specified raw representable value if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a raw value to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter value: The raw value to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the string could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func check<Raw: RawRepresentable>(
        raw value: Raw,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) {
        try await check(value.rawBytes)
    }
    
    /// Asynchronously advances by the specified raw representable value if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a raw value to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter value: The raw value to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: `true` if the string was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the string could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<Raw: RawRepresentable>(
        raw value: Raw,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) -> Bool {
        try await checkIfPresent(value.rawBytes)
    }
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension AsyncIteratorProtocol where Element == Byte {
    /// Asynchronously advances to the next little endian integer in the squence and returns it, or throws if it could not.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A raw representable type as a fixed width integer of type `type`.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete integer could not be returned by the time the sequence ended.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the integer does not correspond with a valid raw value.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func next<T: RawRepresentable>(
        littleEndian type: T.Type,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.RawRepresentable.BufferSizeError) -> T where T.RawValue: FixedWidthInteger {
        let rawBytes: Bytes
        do {
            rawBytes = try await next(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw error.mapCastingFailure { .castingFailure($0) }
        }
        do {
            return try T(littleEndianBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Asynchronously advances to the next big endian integer in the squence and returns it, or throws if it could not.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A raw representable type as a fixed width integer of type `type`.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete integer could not be returned by the time the sequence ended.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the integer does not correspond with a valid raw value.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func next<T: RawRepresentable>(
        bigEndian type: T.Type,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.RawRepresentable.BufferSizeError) -> T where T.RawValue: FixedWidthInteger {
        let rawBytes: Bytes
        do {
            rawBytes = try await next(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw error.mapCastingFailure { .castingFailure($0) }
        }
        do {
            return try T(bigEndianBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Asynchronously advances to the next little endian integer in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A raw representable type as a fixed width integer of type `type`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete integer could not be returned by the time the sequence ended.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the integer does not correspond with a valid raw value.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func nextIfPresent<T: RawRepresentable>(
        littleEndian type: T.Type,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.RawRepresentable.BufferSizeError) -> T? where T.RawValue: FixedWidthInteger {
        let rawBytes: Bytes?
        do {
            rawBytes = try await nextIfPresent(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw error.mapCastingFailure { .castingFailure($0) }
        }
        guard let rawBytes else { return nil }
        do {
            return try T(littleEndianBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Asynchronously advances to the next big endian integer in the squence and returns it, or ends the sequence if there is no next element.
    ///
    /// If a complete integer could not be constructed, an error is thrown and the sequence should be considered finished.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: The type of raw representable to decode.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A raw representable type as a fixed width integer of type `type`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete integer could not be returned by the time the sequence ended.
    ///     - ``BytesError/RawRepresentableError/invalidRawRepresentableByteSequence(rawType:)-enum.case`` if the integer does not correspond with a valid raw value.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func nextIfPresent<T: RawRepresentable>(
        bigEndian type: T.Type,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.RawRepresentable.BufferSizeError) -> T? where T.RawValue: FixedWidthInteger {
        let rawBytes: Bytes?
        do {
            rawBytes = try await nextIfPresent(Bytes.self, count: MemoryLayout<T.RawValue>.size)
        } catch {
            throw error.mapCastingFailure { .castingFailure($0) }
        }
        guard let rawBytes else { return nil }
        do {
            return try T(bigEndianBytes: rawBytes)
        } catch {
            switch error {
            case .castingFailure:
                fatalError("Transforming the raw value should always succeed.")
            case .invalidRawRepresentableByteSequence(let rawType):
                throw .invalidRawRepresentableByteSequence(rawType: rawType)
            }
        }
    }
    
    /// Asynchronously advances by the next byte if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func check<RawInt: RawRepresentable>(
        _ integer: RawInt,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) where RawInt.RawValue == UInt8 {
        try await check(integer.rawValue)
    }
    
    /// Asynchronously advances by the next little endien integer if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func check<RawInt: RawRepresentable>(
        littleEndian integer: RawInt,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) where RawInt.RawValue: FixedWidthInteger {
        try await check(integer.littleEndianBytes)
    }
    
    /// Asynchronously advances by the next big endien integer if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func check<RawInt: RawRepresentable>(
        bigEndian integer: RawInt,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) where RawInt.RawValue: FixedWidthInteger {
        try await check(integer.bigEndianBytes)
    }
    
    /// Asynchronously advances by the byte if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: `true` if the integer was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<RawInt: RawRepresentable>(
        _ integer: RawInt,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) -> Bool where RawInt.RawValue == UInt8 {
        try await checkIfPresent(integer.rawValue)
    }
    
    /// Asynchronously advances by the next little endien integer if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: `true` if the integer was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<RawInt: RawRepresentable>(
        littleEndian integer: RawInt,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) -> Bool where RawInt.RawValue: FixedWidthInteger {
        try await checkIfPresent(integer.littleEndianBytes)
    }
    
    /// Asynchronously advances by the next big endien integer if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect an integer to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter integer: The raw integer to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: `true` if the integer was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the integer could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<RawInt: RawRepresentable>(
        bigEndian integer: RawInt,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) -> Bool where RawInt.RawValue: FixedWidthInteger {
        try await checkIfPresent(integer.bigEndianBytes)
    }
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension AsyncIteratorProtocol where Element == Byte {
    /// Asynchronously advances by the specified UTF-8 encoded raw value Character if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a raw value Character to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter character: The character to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the character could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func check<RawCharacter: RawRepresentable>(
        utf8 character: RawCharacter,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) where RawCharacter.RawValue == Character {
        try await check(character.utf8Bytes)
    }
    
    /// Asynchronously advances by the specified UTF-8 encoded raw value String if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a raw value String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// If the String is empty, this method won't do anything.
    ///
    /// - Note: The string will not check for null termination unless a null character is specified.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter string: The string to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the string could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func check<RawString: RawRepresentable>(
        utf8 string: RawString,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) where RawString.RawValue: StringProtocol {
        try await check(string.utf8Bytes)
    }
    
    /// Asynchronously advances by the specified UTF-8 encoded raw value Character if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a raw value Character to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter character: The character to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: `true` if the character was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the character could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<RawCharacter: RawRepresentable>(
        utf8 character: RawCharacter,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) -> Bool where RawCharacter.RawValue == Character {
        try await checkIfPresent(character.utf8Bytes)
    }
    
    /// Asynchronously advances by the specified UTF-8 encoded raw value String if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a raw value String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// If the String is empty, this method won't do anything.
    ///
    /// - Note: The string will not check for null termination unless a null character is specified.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter string: The string to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: `true` if the character was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the character could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<RawString: RawRepresentable>(
        utf8 string: RawString,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) -> Bool where RawString.RawValue: StringProtocol {
        try await checkIfPresent(string.utf8Bytes)
    }
}
