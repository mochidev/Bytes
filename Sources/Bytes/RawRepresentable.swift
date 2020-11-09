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
