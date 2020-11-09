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
