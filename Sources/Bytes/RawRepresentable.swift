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
