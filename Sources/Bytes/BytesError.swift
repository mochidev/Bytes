//
//  BytesError.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 11/6/20.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//


// MARK: - BytesError

public enum BytesError: Error {
    case invalidMemorySize(targetSize: Int, targetType: String, actualSize: Int)
    case contiguousMemoryUnavailable(type: String)
    
    case invalidCharacterByteSequence
    case invalidRawRepresentableByteSequence
    case invalidUUIDByteSequence
    
    case checkedSequenceNotFound
}


// MARK: - ByteCastingError

public protocol ByteCastingError: Error, Equatable, Hashable {}
extension Never: ByteCastingError {}

public protocol ByteCastingErrorWrapper<CastingFailure>: Error {
    associatedtype CastingFailure: ByteCastingError
    static func castingFailure(_ castingFailure: CastingFailure) -> Self
}


// MARK: - BufferSizeError

extension BytesError {
    /// An error thrown when an insufficient or invalid number of bytes were available before the ``Bytes`` sequence ended.
    public enum BufferSizeError: ByteCastingError {
        /// An error thrown when an insufficient or invalid number of bytes were available before the ``Bytes`` sequence ended.
        /// - Parameter targetSize: The required size of the buffer.
        /// - Parameter targetType: The type that was being casted.
        /// - Parameter actualSize: The actual available size of the buffer.
        case invalidBufferSize(targetSize: Int, targetType: String, actualSize: Int)
    }
}

extension ByteCastingError where
    Self == BytesError.BufferSizeError
{
    /// An error thrown when an insufficient or invalid number of bytes were available before the ``Bytes`` sequence ended.
    @inlinable
    @_disfavoredOverload
    public static func invalidBufferSize(targetSize: Int, targetType: String, actualSize: Int) -> Self {
        .invalidBufferSize(targetSize: targetSize, targetType: targetType, actualSize: actualSize)
    }
}

extension ByteCastingErrorWrapper where
    CastingFailure == BytesError.BufferSizeError
{
    /// An error thrown when an insufficient or invalid number of bytes were available before the ``Bytes`` sequence ended, wrapped in a parent error.
    @inlinable
    public static func invalidBufferSize(targetSize: Int, targetType: String, actualSize: Int) -> Self {
        .castingFailure(.invalidBufferSize(targetSize: targetSize, targetType: targetType, actualSize: actualSize))
    }
}


// MARK: - IterationError

extension BytesError {
    /// An error thrown when consuming a sequence.
    public enum IterationError<
        CastingFailure: ByteCastingError,
        IterationFailure: Error
    >: Error, ByteCastingErrorWrapper {
        /// An error was thrown casting bytes off the sequence.
        case castingFailure(CastingFailure)
        /// An error was thrown by the underlying iterator.
        case iterationFailure(IterationFailure)
    }
}

extension BytesError.IterationError: Equatable where IterationFailure: Equatable {}
extension BytesError.IterationError: Hashable where IterationFailure: Hashable {}


// MARK: - SequenceCheckError

extension BytesError {
    /// An error thrown when the checked byte was not found as the next consumable element.
    public enum SequenceCheckError: ByteCastingError {
        /// An error thrown when the checked byte was not found as the next consumable element.
        case checkedSequenceNotFound
    }
}

extension ByteCastingError where
    Self == BytesError.SequenceCheckError
{
    /// An error thrown when the checked byte was not found as the next consumable element.
    @inlinable
    @_disfavoredOverload
    public static var checkedSequenceNotFound: Self {
        .checkedSequenceNotFound
    }
}

extension ByteCastingErrorWrapper where
    CastingFailure == BytesError.SequenceCheckError
{
    /// An error thrown when the checked byte was not found as the next consumable element, wrapped in a parent error.
    @inlinable
    public static var checkedSequenceNotFound: Self {
        .castingFailure(.checkedSequenceNotFound)
    }
}


// MARK: - Bytes Error Type Alias Tree

extension BytesError {
    /// A namespace for errors wrapped within a ``IterationError``.
    public enum Iteration<IterationFailure: Error> {
        /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped in a ``BytesError/IterationError``.
        public typealias BufferSizeError = IterationError<BytesError.BufferSizeError, IterationFailure>
                
        /// A ``BytesError/SequenceCheckError`` error thrown when the checked byte was not found as the next consumable element, wrapped in a ``BytesError/IterationError``.
        public typealias SequenceCheckError = IterationError<BytesError.SequenceCheckError, IterationFailure>
    }
}
