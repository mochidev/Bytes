//
//  String.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 11/7/20.
//  Copyright © 2020 Mochi Development, Inc. All rights reserved.
//

extension StringProtocol {
    /// Get the UTF-8 representation of a string as a contiguous sequence of Bytes.
    @inlinable
    public var utf8Bytes: Bytes {
        return Bytes(self.utf8)
    }
    
    /// Initialize a String from a contiguous sequence of Bytes representing UTF-8 characters.
    /// - Parameter utf8Bytes: The Bytes to interpret as a string.
    @inlinable
    public init<Bytes: BytesCollection>(utf8Bytes: Bytes) {
        self.init(decoding: utf8Bytes, as: UTF8.self)
    }
}

extension Character {
    /// Get the UTF-8 representation of a character as a contiguous sequence of Bytes.
    @inlinable
    public var utf8Bytes: Bytes {
        return Bytes(self.utf8)
    }
    
    /// Initialize a Character from a contiguous sequence of Bytes representing a UTF-8 encoded character.
    /// - Parameter utf8Bytes: The Bytes to interpret as a string.
    /// - Throws: `BytesError.invalidCharacterByteSequence` if the byte sequence does not represent a single character.
    @inlinable
    public init<Bytes: BytesCollection>(utf8Bytes: Bytes) throws {
        let string = String(utf8Bytes: utf8Bytes)
        guard string.count == 1 else {
            throw BytesError.invalidCharacterByteSequence
        }
        self.init(string)
    }
}

#if compiler(>=5.5) && canImport(_Concurrency)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncIteratorProtocol where Element == UInt8 {
    /// Asynchronously advances to the UTF-8 encoded String of size `count`, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `String.self`.
    /// - Parameter count: The number of bytes to form into a string.
    /// - Returns: A string of size `count`.
    /// - Throws: `BytesError.invalidMemorySize` if a complete string could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next(utf8 type: String.Type, count: Int) async throws -> String {
        String(utf8Bytes: try await next(bytes: Bytes.self, count: count))
    }
    
    /// Asynchronously advances to the UTF-8 encoded String with the specified minimum size, continuing until the specified maximum size, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `String.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a string.
    /// - Parameter maxCount: The maximum number of bytes to form into a string.
    /// - Returns: A string of size at least `minCount` and at most `maxCount`.
    /// - Throws: `BytesError.invalidMemorySize` if a complete string could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next(utf8 type: String.Type, min minCount: Int = 0, max maxCount: Int) async throws -> String {
        String(utf8Bytes: try await next(bytes: Bytes.self, min: minCount, max: maxCount))
    }
    
    /// Asynchronously advances to the UTF-8 encoded String of size `count`, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `String.self`.
    /// - Parameter count: The number of bytes to form into a string.
    /// - Returns: A string of size `count`, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if a complete string could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent(utf8 type: String.Type, count: Int) async throws -> String? {
        try (await nextIfPresent(bytes: Bytes.self, count: count)).map { String(utf8Bytes: $0) }
    }
    
    /// Asynchronously advances to the UTF-8 encoded String with the specified minimum size, continuing until the specified maximum size, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `String.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a string.
    /// - Parameter maxCount: The maximum number of bytes to form into a string.
    /// - Returns: A string of size at least `minCount` and at most `maxCount`, or `nil` if the sequence is finished.
    /// - Throws: `BytesError.invalidMemorySize` if a complete string could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent(utf8 type: String.Type, min minCount: Int = 0, max maxCount: Int) async throws -> String? {
        try (await nextIfPresent(bytes: Bytes.self, min: minCount, max: maxCount)).map { String(utf8Bytes: $0) }
    }
}

#endif
