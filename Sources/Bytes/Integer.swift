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
    /// - Parameter bigEndianBytes: The Bytes to interpret as a sequence of big endian integer.
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
    /// - Parameter littleEndianBytes: The Bytes to interpret as a sequence of little endian integer.
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
    /// - Parameter bigEndianBytes: The Bytes to interpret as a sequence of big endian integer.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not a multiple of the size of the integer type.
    ///     - `BytesError.contiguousMemoryUnavailable` if a byte sub-sequence cannot be made to be contiguous.
    @inlinable
    public init<Bytes: BytesCollection>(bigEndianBytes: Bytes) throws {
        try self.init(bytes: bigEndianBytes, mapping: Element.init(bigEndianBytes:))
    }
    
    /// Initialize a Set of integers with a sequence of Bytes representing a sequence of little endian types.
    /// - Parameter littleEndianBytes: The Bytes to interpret as a sequence of little endian integer.
    /// - Throws:
    ///     - `BytesError.invalidMemorySize` if the byte sequence is not a multiple of the size of the integer type.
    ///     - `BytesError.contiguousMemoryUnavailable` if a byte sub-sequence cannot be made to be contiguous.
    @inlinable
    public init<Bytes: BytesCollection>(littleEndianBytes: Bytes) throws {
        try self.init(bytes: littleEndianBytes, mapping: Element.init(littleEndianBytes:))
    }
}
