//
//  String.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 11/7/20.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

extension StringProtocol {
    /// Get the UTF-8 representation of a string as a contiguous sequence of ``Bytes``.
    @inlinable
    public var utf8Bytes: Bytes {
        return Bytes(self.utf8)
    }
    
    /// Initialize a String from a contiguous sequence of ``Bytes`` representing UTF-8 characters.
    /// - Parameter utf8Bytes: The ``Bytes`` to interpret as a string.
    @inlinable
    public init<Bytes: BytesCollection>(utf8Bytes: Bytes) {
        self.init(decoding: utf8Bytes, as: UTF8.self)
    }
}

extension Character {
    /// Get the UTF-8 representation of a character as a contiguous sequence of ``Bytes``.
    @inlinable
    public var utf8Bytes: Bytes {
        return Bytes(self.utf8)
    }
    
    /// Initialize a Character from a contiguous sequence of ``Bytes`` representing a UTF-8 encoded character.
    /// - Parameter utf8Bytes: The ``Bytes`` to interpret as a string.
    /// - Throws: ``BytesError/CharacterDecodingError/invalidCharacterByteSequence`` if the byte sequence does not represent a single character.
    @inlinable
    public init<Bytes: BytesCollection>(utf8Bytes: Bytes) throws(BytesError.CharacterDecodingError) {
        let string = String(utf8Bytes: utf8Bytes)
        guard string.count == 1
        else { throw .invalidCharacterByteSequence }
        self.init(string)
    }
}


// MARK: - ByteIterator

extension IteratorProtocol where Element == Byte {
    /// Advances to the UTF-8 encoded String of size `count`, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `String.self`.
    /// - Parameter count: The number of bytes to form into a string.
    /// - Returns: A string of size `count`.
    /// - Throws: ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete string could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next(
        utf8 type: String.Type,
        count: Int
    ) throws(BytesError.BufferSizeError) -> String {
        String(utf8Bytes: try next(Bytes.self, count: count))
    }
    
    /// Advances to the UTF-8 encoded String with the specified minimum size, continuing until the specified maximum size, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `String.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a string.
    /// - Parameter maxCount: The maximum number of bytes to form into a string.
    /// - Returns: A string of size at least `minCount` and at most `maxCount`.
    /// - Throws: ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete string could not be returned by the time the sequence ended.
    @inlinable
    public mutating func next(
        utf8 type: String.Type,
        min minCount: Int = 0,
        max maxCount: Int
    ) throws(BytesError.BufferSizeError) -> String {
        String(utf8Bytes: try next(Bytes.self, min: minCount, max: maxCount))
    }
    
    /// Advances to the UTF-8 encoded String of size `count`, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `String.self`.
    /// - Parameter count: The number of bytes to form into a string.
    /// - Returns: A string of size `count`, or `nil` if the sequence is finished.
    /// - Throws: ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete string could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent(
        utf8 type: String.Type,
        count: Int
    ) throws(BytesError.BufferSizeError) -> String? {
        try nextIfPresent(Bytes.self, count: count).map { String(utf8Bytes: $0) }
    }
    
    /// Advances to the UTF-8 encoded String with the specified minimum size, continuing until the specified maximum size, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `String.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a string.
    /// - Parameter maxCount: The maximum number of bytes to form into a string.
    /// - Returns: A string of size at least `minCount` and at most `maxCount`, or `nil` if the sequence is finished.
    /// - Throws: ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete string could not be returned by the time the sequence ended.
    @inlinable
    public mutating func nextIfPresent(
        utf8 type: String.Type,
        min minCount: Int = 0,
        max maxCount: Int
    ) throws(BytesError.BufferSizeError) -> String? {
        try nextIfPresent(Bytes.self, min: minCount, max: maxCount).map { String(utf8Bytes: $0) }
    }
    
    /// Advances by the specified UTF-8 encoded Character if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a Character to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter character: The character to check for.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the character could not be identified.
    @inlinable
    public mutating func check(
        utf8 character: Character
    ) throws(BytesError.SequenceCheckError) {
        try check(character.utf8Bytes)
    }
    
    /// Advances by the specified UTF-8 encoded String if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// If the String is empty, this method won't do anything.
    ///
    /// - Note: The string will not check for null termination unless a null character is specified.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter string: The string to check for.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the string could not be identified.
    @inlinable
    public mutating func check<String: StringProtocol>(
        utf8 string: String
    ) throws(BytesError.SequenceCheckError) {
        try check(string.utf8Bytes)
    }
    
    /// Advances by the specified UTF-8 encoded Character if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a Character to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter character: The character to check for.
    /// - Returns: `true` if the character was found, or `false` if the sequence finished.
    /// - Throws: ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the character could not be identified.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent(
        utf8 character: Character
    ) throws(BytesError.SequenceCheckError) -> Bool {
        try checkIfPresent(character.utf8Bytes)
    }
    
    /// Advances by the specified UTF-8 encoded String if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a String to be next in the sequence, and it would be an error if something else were encountered.
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
    public mutating func checkIfPresent<String: StringProtocol>(
        utf8 string: String
    ) throws(BytesError.SequenceCheckError) -> Bool {
        try checkIfPresent(string.utf8Bytes)
    }
}


// MARK: - AsyncByteIterator

#if canImport(Darwin)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncIteratorProtocol where Element == Byte {
    /// Asynchronously advances to the UTF-8 encoded String of size `count`, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `String.self`.
    /// - Parameter count: The number of bytes to form into a string.
    /// - Returns: A string of size `count`.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete string could not be returned by the time the sequence ended.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func next(
        utf8 type: String.Type,
        count: Int
    ) async throws(BytesError.Iteration<any Error>.BufferSizeError) -> String {
        String(utf8Bytes: try await next(Bytes.self, count: count))
    }
    
    /// Asynchronously advances to the UTF-8 encoded String with the specified minimum size, continuing until the specified maximum size, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `String.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a string.
    /// - Parameter maxCount: The maximum number of bytes to form into a string.
    /// - Returns: A string of size at least `minCount` and at most `maxCount`.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete string could not be returned by the time the sequence ended.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func next(
        utf8 type: String.Type,
        min minCount: Int = 0,
        max maxCount: Int
    ) async throws(BytesError.Iteration<any Error>.BufferSizeError) -> String {
        String(utf8Bytes: try await next(Bytes.self, min: minCount, max: maxCount))
    }
    
    /// Asynchronously advances to the UTF-8 encoded String of size `count`, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `String.self`.
    /// - Parameter count: The number of bytes to form into a string.
    /// - Returns: A string of size `count`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete string could not be returned by the time the sequence ended.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func nextIfPresent(
        utf8 type: String.Type,
        count: Int
    ) async throws(BytesError.Iteration<any Error>.BufferSizeError) -> String? {
        try await nextIfPresent(Bytes.self, count: count).map { String(utf8Bytes: $0) }
    }
    
    /// Asynchronously advances to the UTF-8 encoded String with the specified minimum size, continuing until the specified maximum size, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `String.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a string.
    /// - Parameter maxCount: The maximum number of bytes to form into a string.
    /// - Returns: A string of size at least `minCount` and at most `maxCount`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete string could not be returned by the time the sequence ended.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @_disfavoredOverload
    public mutating func nextIfPresent(
        utf8 type: String.Type,
        min minCount: Int = 0,
        max maxCount: Int
    ) async throws(BytesError.Iteration<any Error>.BufferSizeError) -> String? {
        try await nextIfPresent(Bytes.self, min: minCount, max: maxCount).map { String(utf8Bytes: $0) }
    }
    
    /// Asynchronously advances by the specified UTF-8 encoded Character if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a Character to be next in the sequence, and it would be an error if something else were encountered.
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
    public mutating func check(
        utf8 string: Character
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) {
        try await check(string.utf8Bytes)
    }
    
    /// Asynchronously advances by the specified UTF-8 encoded String if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a String to be next in the sequence, and it would be an error if something else were encountered.
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
    public mutating func check<String: StringProtocol>(
        utf8 string: String
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) {
        try await check(string.utf8Bytes)
    }
    
    /// Asynchronously advances by the specified UTF-8 encoded Character if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a Character to be next in the sequence, and it would be an error if something else were encountered.
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
    @discardableResult
    @_disfavoredOverload
    public mutating func checkIfPresent(
        utf8 string: Character
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) -> Bool {
        try await checkIfPresent(string.utf8Bytes)
    }
    
    /// Asynchronously advances by the specified UTF-8 encoded String if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// If the String is empty, this method won't do anything.
    ///
    /// - Note: The string will not check for null termination unless a null character is specified.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter string: The string to check for.
    /// - Returns: `true` if the string was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the string could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    #if swift(>=6.2)
    @concurrent
    #endif
    @inlinable
    @discardableResult
    @_disfavoredOverload
    public mutating func checkIfPresent<String: StringProtocol>(
        utf8 string: String
    ) async throws(BytesError.Iteration<any Error>.SequenceCheckError) -> Bool {
        try await checkIfPresent(string.utf8Bytes)
    }
}
#endif // canImport(Darwin)

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension AsyncIteratorProtocol where Element == Byte {
    /// Asynchronously advances to the UTF-8 encoded String of size `count`, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `String.self`.
    /// - Parameter count: The number of bytes to form into a string.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A string of size `count`.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete string could not be returned by the time the sequence ended.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func next(
        utf8 type: String.Type,
        count: Int,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.BufferSizeError) -> String {
        String(utf8Bytes: try await next(Bytes.self, count: count))
    }
    
    /// Asynchronously advances to the UTF-8 encoded String with the specified minimum size, continuing until the specified maximum size, or throws if it could not.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `String.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a string.
    /// - Parameter maxCount: The maximum number of bytes to form into a string.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A string of size at least `minCount` and at most `maxCount`.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete string could not be returned by the time the sequence ended.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func next(
        utf8 type: String.Type,
        min minCount: Int = 0,
        max maxCount: Int,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.BufferSizeError) -> String {
        String(utf8Bytes: try await next(Bytes.self, min: minCount, max: maxCount))
    }
    
    /// Asynchronously advances to the UTF-8 encoded String of size `count`, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `String.self`.
    /// - Parameter count: The number of bytes to form into a string.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A string of size `count`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete string could not be returned by the time the sequence ended.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func nextIfPresent(
        utf8 type: String.Type,
        count: Int,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.BufferSizeError) -> String? {
        try await nextIfPresent(Bytes.self, count: count).map { String(utf8Bytes: $0) }
    }
    
    /// Asynchronously advances to the UTF-8 encoded String with the specified minimum size, continuing until the specified maximum size, or ends the sequence if there is no next element.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter type: This should be set to `String.self`.
    /// - Parameter minCount: The minimum number of bytes to form into a string.
    /// - Parameter maxCount: The maximum number of bytes to form into a string.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: A string of size at least `minCount` and at most `maxCount`, or `nil` if the sequence is finished.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if a complete string could not be returned by the time the sequence ended.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func nextIfPresent(
        utf8 type: String.Type,
        min minCount: Int = 0,
        max maxCount: Int,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.BufferSizeError) -> String? {
        try await nextIfPresent(Bytes.self, min: minCount, max: maxCount).map { String(utf8Bytes: $0) }
    }
    
    /// Asynchronously advances by the specified UTF-8 encoded Character if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a Character to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter character: The character to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the character could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    public mutating func check(
        utf8 string: Character,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) {
        try await check(string.utf8Bytes)
    }
    
    /// Asynchronously advances by the specified UTF-8 encoded String if found, or throws if the next bytes in the iterator do not match.
    ///
    /// Use this method when you expect a String to be next in the sequence, and it would be an error if something else were encountered.
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
    public mutating func check<String: StringProtocol>(
        utf8 string: String,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) {
        try await check(string.utf8Bytes)
    }
    
    /// Asynchronously advances by the specified UTF-8 encoded Character if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a Character to be next in the sequence, and it would be an error if something else were encountered.
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
    public mutating func checkIfPresent(
        utf8 string: Character,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) -> Bool {
        try await checkIfPresent(string.utf8Bytes)
    }
    
    /// Asynchronously advances by the specified UTF-8 encoded String if found, throws if the next bytes in the iterator do not match, or returns false if the sequence ended.
    ///
    /// Use this method when you expect a String to be next in the sequence, and it would be an error if something else were encountered.
    ///
    /// If the String is empty, this method won't do anything.
    ///
    /// - Note: The string will not check for null termination unless a null character is specified.
    ///
    /// **Learn More:** [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes)
    /// - Parameter string: The string to check for.
    /// - Parameter actor: The isolation context to run the reciever on.
    /// - Returns: `true` if the string was found, or `false` if the sequence finished.
    /// - Throws:
    ///     - ``BytesError/SequenceCheckError/checkedSequenceNotFound`` if the string could not be identified.
    ///     - ``BytesError/IterationError/iterationFailure(_:)`` if the underlying sequence threw an error while producing bytes.
    @inlinable
    @discardableResult
    public mutating func checkIfPresent<String: StringProtocol>(
        utf8 string: String,
        isolation actor: isolated (any Actor)? = #isolation
    ) async throws(BytesError.Iteration<Failure>.SequenceCheckError) -> Bool {
        try await checkIfPresent(string.utf8Bytes)
    }
}
