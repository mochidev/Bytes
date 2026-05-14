//
//  BytesError.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 11/6/20.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//


// MARK: - BytesError

public enum BytesError: Error {}


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

extension ByteCastingErrorWrapper where
    CastingFailure: ByteCastingErrorWrapper,
    CastingFailure.CastingFailure == BytesError.BufferSizeError
{
    /// An error thrown when an insufficient or invalid number of bytes were available before the ``Bytes`` sequence ended, wrapped in a parent error.
    @inlinable
    public static func invalidBufferSize(targetSize: Int, targetType: String, actualSize: Int) -> Self {
        .castingFailure(.invalidBufferSize(targetSize: targetSize, targetType: targetType, actualSize: actualSize))
    }
}

extension ByteCastingErrorWrapper where
    CastingFailure: ByteCastingErrorWrapper,
    CastingFailure.CastingFailure: ByteCastingErrorWrapper,
    CastingFailure.CastingFailure.CastingFailure == BytesError.BufferSizeError
{
    /// An error thrown when an insufficient or invalid number of bytes were available before the ``Bytes`` sequence ended, wrapped in a parent error.
    @inlinable
    public static func invalidBufferSize(targetSize: Int, targetType: String, actualSize: Int) -> Self {
        .castingFailure(.invalidBufferSize(targetSize: targetSize, targetType: targetType, actualSize: actualSize))
    }
}


// MARK: - CharacterDecodingError

extension BytesError {
    /// An error thrown when a character could not be constructed from the byte sequence.
    public enum CharacterDecodingError: ByteCastingError {
        /// An error thrown when a character could not be constructed from the byte sequence.
        case invalidCharacterByteSequence
    }
}

extension ByteCastingError where
    Self == BytesError.CharacterDecodingError
{
    /// An error thrown when a character could not be constructed from the byte sequence.
    @inlinable
    @_disfavoredOverload
    public static var invalidCharacterByteSequence: Self {
        .invalidCharacterByteSequence
    }
}

extension ByteCastingErrorWrapper where
    CastingFailure == BytesError.CharacterDecodingError
{
    /// An error thrown when a character could not be constructed from the byte sequence, wrapped in a parent error.
    @inlinable
    public static var invalidCharacterByteSequence: Self {
        .castingFailure(.invalidCharacterByteSequence)
    }
}

extension ByteCastingErrorWrapper where
    CastingFailure: ByteCastingErrorWrapper,
    CastingFailure.CastingFailure == BytesError.CharacterDecodingError
{
    /// An error thrown when the a character could not be constructed from the byte sequence, wrapped in a parent error.
    @inlinable
    public static var invalidCharacterByteSequence: Self {
        .castingFailure(.invalidCharacterByteSequence)
    }
}


// MARK: - ContiguousBytesError

extension BytesError {
    /// An error thrown when the receiving buffer cannot efficiently be made contiguous for casting.
    public enum ContiguousBytesError<CastingFailure: ByteCastingError>: ByteCastingError, ByteCastingErrorWrapper {
        /// An error thrown while casting the specified bytes.
        case castingFailure(CastingFailure)
        /// An error was thrown because the underlying buffer is not contiguous and is over 4KB in size.
        /// - Note: Copy the sequence first if you know the expected casting size is correct.
        case contiguousBytesUnavailable(type: String)
    }
}

extension ByteCastingError {
    /// An error was thrown because the underlying buffer is not contiguous and is over 4KB in size.
    /// - Note: Copy the sequence first if you know the expected casting size is correct.
    @inlinable
    @_disfavoredOverload
    public static func contiguousBytesUnavailable<CastingFailure: ByteCastingError>(
        type: String
    ) -> BytesError.ContiguousBytesError<CastingFailure> {
        .contiguousBytesUnavailable(type: type)
    }
}

extension ByteCastingErrorWrapper {
    /// An error was thrown because the underlying buffer is not contiguous and is over 4KB in size, wrapped in a parent error.
    /// - Note: Copy the sequence first if you know the expected casting size is correct.
    @inlinable
    public static func contiguousBytesUnavailable<InnerCastingFailure: ByteCastingError>(
        type: String
    ) -> Self where CastingFailure == BytesError.ContiguousBytesError<InnerCastingFailure> {
        .castingFailure(.contiguousBytesUnavailable(type: type))
    }
}

extension ByteCastingErrorWrapper where
    CastingFailure: ByteCastingErrorWrapper
{
    /// An error was thrown because the underlying buffer is not contiguous and is over 4KB in size, wrapped in a parent error.
    /// - Note: Copy the sequence first if you know the expected casting size is correct.
    @inlinable
    public static func contiguousBytesUnavailable<InnerCastingFailure: ByteCastingError>(
        type: String
    ) -> Self where CastingFailure.CastingFailure == BytesError.ContiguousBytesError<InnerCastingFailure> {
        .castingFailure(.contiguousBytesUnavailable(type: type))
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

extension BytesError.IterationError {
    @inlinable
    public func mapCastingFailure<NewCastingFailure: ByteCastingError>(
        _ transform: (CastingFailure) -> NewCastingFailure
    ) -> BytesError.IterationError<NewCastingFailure, IterationFailure> {
        switch self {
        case .castingFailure(let error):    .castingFailure(transform(error))
        case .iterationFailure(let error):  .iterationFailure(error)
        }
    }
}

// MARK: - RawRepresentableError

extension BytesError {
    /// An error thrown while initializing a `RawRepresentable` type with raw bytes.
    public enum RawRepresentableError<CastingFailure: ByteCastingError>: ByteCastingError, ByteCastingErrorWrapper {
        /// An error was thrown because the raw value could not be casted from the specified bytes.
        case castingFailure(CastingFailure)
        /// An error was thrown because the raw value evaluated to a `nil` `RawRepresentable` value.
        case invalidRawRepresentableByteSequence(rawType: String)
    }
}

extension ByteCastingError {
    /// Consuming the sequence failed because the raw value evaluated to a `nil` `RawRepresentable` value.
    @inlinable
    @_disfavoredOverload
    public static func invalidRawRepresentableByteSequence<CastingFailure: ByteCastingError>(rawType: String) -> BytesError.RawRepresentableError<CastingFailure> {
        .invalidRawRepresentableByteSequence(rawType: rawType)
    }
}

extension ByteCastingErrorWrapper {
    /// Consuming the sequence failed because the raw value evaluated to a `nil` `RawRepresentable` value, wrapped in a parent error.
    @inlinable
    public static func invalidRawRepresentableByteSequence<InnerCastingFailure: ByteCastingError>(rawType: String) -> Self where CastingFailure == BytesError.RawRepresentableError<InnerCastingFailure> {
        .castingFailure(.invalidRawRepresentableByteSequence(rawType: rawType))
    }
}

extension ByteCastingErrorWrapper where
    CastingFailure: ByteCastingErrorWrapper
{
    /// Consuming the sequence failed because the raw value evaluated to a `nil` `RawRepresentable` value, wrapped in a parent error.
    @inlinable
    public static func invalidRawRepresentableByteSequence<InnerCastingFailure: ByteCastingError>(rawType: String) -> Self where CastingFailure.CastingFailure == BytesError.RawRepresentableError<InnerCastingFailure> {
        .castingFailure(.invalidRawRepresentableByteSequence(rawType: rawType))
    }
}


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

extension ByteCastingErrorWrapper where
    CastingFailure: ByteCastingErrorWrapper,
    CastingFailure.CastingFailure == BytesError.SequenceCheckError
{
    /// An error thrown when the checked byte was not found as the next consumable element, wrapped in a parent error.
    @inlinable
    public static var checkedSequenceNotFound: Self {
        .castingFailure(.checkedSequenceNotFound)
    }
}


// MARK: - TransformationError

extension BytesError {
    /// An error thrown when consuming a sequence.
    public enum TransformationError<
        CastingFailure: ByteCastingError,
        TransformationFailure: Error
    >: Error, ByteCastingErrorWrapper {
        /// An error was thrown casting bytes off the sequence.
        case castingFailure(CastingFailure)
        /// An error was thrown during transformation.
        case transformationFailure(TransformationFailure)
    }
}

extension BytesError.TransformationError: Equatable where TransformationFailure: Equatable {}
extension BytesError.TransformationError: Hashable where TransformationFailure: Hashable {}

extension BytesError.TransformationError {
    @inlinable
    public func mapCastingFailure<NewCastingFailure: ByteCastingError>(
        _ transform: (CastingFailure) -> NewCastingFailure
    ) -> BytesError.TransformationError<NewCastingFailure, TransformationFailure> {
        switch self {
        case .castingFailure(let error):        .castingFailure(transform(error))
        case .transformationFailure(let error): .transformationFailure(error)
        }
    }
}

extension BytesError.TransformationError where
    TransformationFailure: ByteCastingErrorWrapper,
    TransformationFailure.CastingFailure == CastingFailure
{
    /// Flatten a ``BytesError/TransformationError`` whose cases both contain an identical leaf error into a single non-branching error.
    @inlinable
    public var flattened: TransformationFailure {
        switch self {
        case .castingFailure(let error):
            .castingFailure(error)
        case .transformationFailure(let error):
            error
        }
    }
}

extension BytesError.TransformationError where
    TransformationFailure: ByteCastingErrorWrapper,
    TransformationFailure.CastingFailure: ByteCastingErrorWrapper,
    TransformationFailure.CastingFailure.CastingFailure == CastingFailure
{
    /// Flatten a ``BytesError/TransformationError`` whose cases both contain an identical leaf error into a single non-branching error.
    @inlinable
    public var flattened: TransformationFailure {
        switch self {
        case .castingFailure(let error):
            .castingFailure(.castingFailure(error))
        case .transformationFailure(let error):
            error
        }
    }
}


// MARK: - UUIDDecodingError

extension BytesError {
    /// An error thrown when a UUID could not be constructed from the byte sequence.
    public enum UUIDDecodingError<CastingFailure: ByteCastingError>: ByteCastingError, ByteCastingErrorWrapper {
        /// An error thrown while casting the specified bytes.
        case castingFailure(CastingFailure)
        /// An error thrown when a UUID could not be constructed from the byte sequence.
        case invalidUUIDByteSequence
    }
}

extension ByteCastingError {
    /// An error thrown when a UUID could not be constructed from the byte sequence.
    @inlinable
    @_disfavoredOverload
    public static func invalidUUIDByteSequence<CastingFailure: ByteCastingError>() -> BytesError.UUIDDecodingError<CastingFailure> {
        .invalidUUIDByteSequence
    }
}

extension ByteCastingErrorWrapper {
    /// An error thrown when a UUID could not be constructed from the byte sequence, wrapped in a parent error.
    @inlinable
    public static func invalidUUIDByteSequence<InnerCastingFailure: ByteCastingError>() -> Self where CastingFailure == BytesError.UUIDDecodingError<InnerCastingFailure> {
        .castingFailure(.invalidUUIDByteSequence())
    }
}


// MARK: - Bytes Error Type Alias Tree

extension BytesError {
    /// A namespace for errors wrapped within a ``ContiguousBytesError``.
    public enum ContiguousBytes {
        /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped in a ``BytesError/ContiguousBytesError``.
        public typealias BufferSizeError = ContiguousBytesError<BytesError.BufferSizeError>
    }
    
    /// A namespace for errors wrapped within a ``RawRepresentableError``.
    public enum RawRepresentable {
        /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped in a ``BytesError/RawRepresentableError``.
        public typealias BufferSizeError = RawRepresentableError<BytesError.BufferSizeError>
        
        /// A ``BytesError/CharacterDecodingError`` error thrown when the a character could not be constructed from the byte sequence, wrapped in a ``BytesError/RawRepresentableError``.
        public typealias CharacterDecodingError = RawRepresentableError<BytesError.CharacterDecodingError>
        
        /// A ``BytesError/ContiguousBytesError`` error thrown when the receiving buffer cannot efficiently be made contiguous for casting, wrapped in a ``BytesError/RawRepresentableError``.
        public typealias ContiguousBytesError<CastingFailure: ByteCastingError> = RawRepresentableError<BytesError.ContiguousBytesError<CastingFailure>>
        
        /// A namespace for errors wrapped within ``BytesError/ContiguousBytesError`` and ``BytesError/RawRepresentableError`` respectively.
        public enum ContiguousBytes {
            /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped within ``BytesError/ContiguousBytesError`` and ``BytesError/RawRepresentableError`` respectively.
            public typealias BufferSizeError = ContiguousBytesError<BytesError.BufferSizeError>
        }
        
        /// A ``BytesError/SequenceCheckError`` error thrown when the checked byte was not found as the next consumable element, wrapped in a ``BytesError/RawRepresentableError``.
        public typealias SequenceCheckError = RawRepresentableError<BytesError.SequenceCheckError>
        
        /// A ``BytesError/UUIDDecodingError`` error thrown when a UUID could not be constructed from the byte sequence, wrapped in a ``BytesError/RawRepresentableError``.
        public typealias UUIDDecodingError<CastingFailure: ByteCastingError> = RawRepresentableError<BytesError.UUIDDecodingError<CastingFailure>>
        
        /// A namespace for errors wrapped within ``BytesError/UUIDDecodingError`` and ``BytesError/RawRepresentableError`` respectively.
        public enum UUIDDecoding {
            /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped within ``BytesError/UUIDDecodingError`` and ``BytesError/RawRepresentableError`` respectively.
            public typealias BufferSizeError = UUIDDecodingError<BytesError.BufferSizeError>
            
            /// A ``BytesError/ContiguousBytesError`` error thrown when the receiving buffer cannot efficiently be made contiguous for casting, wrapped within ``BytesError/UUIDDecodingError`` and ``BytesError/RawRepresentableError``.
            public typealias ContiguousBytesError<CastingFailure: ByteCastingError> = UUIDDecodingError<BytesError.ContiguousBytesError<CastingFailure>>
            
            /// A namespace for errors wrapped within ``BytesError/ContiguousBytesError``, ``BytesError/UUIDDecodingError`` and ``BytesError/RawRepresentableError`` respectively.
            public enum ContiguousBytes {
                /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped within ``BytesError/ContiguousBytesError``, ``BytesError/UUIDDecodingError``, and ``BytesError/RawRepresentableError`` respectively.
                public typealias BufferSizeError = ContiguousBytesError<BytesError.BufferSizeError>
            }
        }
    }
    
    /// A namespace for errors wrapped within a ``IterationError``.
    public enum Iteration<IterationFailure: Error> {
        /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped in a ``BytesError/IterationError``.
        public typealias BufferSizeError = IterationError<BytesError.BufferSizeError, IterationFailure>
        
        /// A ``BytesError/CharacterDecodingError`` error thrown when a character could not be constructed from the byte sequence, wrapped in a ``BytesError/IterationError``.
        public typealias CharacterDecodingError = IterationError<BytesError.CharacterDecodingError, IterationFailure>
        
        /// A ``BytesError/ContiguousBytesError`` error thrown when the receiving buffer cannot efficiently be made contiguous for casting, wrapped in a ``BytesError/IterationError``.
        public typealias ContiguousBytesError<CastingFailure: ByteCastingError> = IterationError<BytesError.ContiguousBytesError<CastingFailure>, IterationFailure>
        
        /// A namespace for errors wrapped within ``BytesError/ContiguousBytesError`` and ``BytesError/IterationError`` respectively.
        public enum ContiguousBytes {
            /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped within ``BytesError/ContiguousBytesError`` and ``BytesError/IterationError`` respectively.
            public typealias BufferSizeError = ContiguousBytesError<BytesError.BufferSizeError>
        }
        
        /// A ``BytesError/RawRepresentableError`` error thrown while initializing a `RawRepresentable` type with raw bytes, wrapped in a ``BytesError/IterationError``.
        public typealias RawRepresentableError<CastingFailure: ByteCastingError> = IterationError<BytesError.RawRepresentableError<CastingFailure>, IterationFailure>
        
        /// A namespace for errors wrapped within ``BytesError/RawRepresentableError`` and ``BytesError/IterationError`` respectively.
        public enum RawRepresentable {
            /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, within ``BytesError/RawRepresentableError`` and ``BytesError/IterationError`` respectively.
            public typealias BufferSizeError = RawRepresentableError<BytesError.BufferSizeError>
            
            /// A ``BytesError/CharacterDecodingError`` error thrown when the a character could not be constructed from the byte sequence, within ``BytesError/RawRepresentableError`` and ``BytesError/IterationError`` respectively.
            public typealias CharacterDecodingError = RawRepresentableError<BytesError.CharacterDecodingError>
            
            /// A ``BytesError/ContiguousBytesError`` error thrown when the receiving buffer cannot efficiently be made contiguous for casting, within ``BytesError/RawRepresentableError`` and ``BytesError/IterationError`` respectively.
            public typealias ContiguousBytesError<CastingFailure: ByteCastingError> = RawRepresentableError<BytesError.ContiguousBytesError<CastingFailure>>
            
            /// A namespace for errors wrapped within ``BytesError/ContiguousBytesError`` and ``BytesError/RawRepresentableError`` respectively.
            public enum ContiguousBytes {
                /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped within ``BytesError/ContiguousBytesError``, ``BytesError/RawRepresentableError``, and ``BytesError/IterationError`` respectively.
                public typealias BufferSizeError = ContiguousBytesError<BytesError.BufferSizeError>
            }
            
            /// A ``BytesError/SequenceCheckError`` error thrown when the checked byte was not found as the next consumable element, wrapped within ``BytesError/RawRepresentableError`` and ``BytesError/IterationError`` respectively.
            public typealias SequenceCheckError = RawRepresentableError<BytesError.SequenceCheckError>
            
            /// A ``BytesError/UUIDDecodingError`` error thrown when a UUID could not be constructed from the byte sequence, wrapped within ``BytesError/RawRepresentableError`` and ``BytesError/IterationError`` respectively.
            public typealias UUIDDecodingError<CastingFailure: ByteCastingError> = RawRepresentableError<BytesError.UUIDDecodingError<CastingFailure>>
            
            /// A namespace for errors wrapped within ``BytesError/UUIDDecodingError``, ``BytesError/RawRepresentableError``, and ``BytesError/IterationError`` respectively.
            public enum UUIDDecoding {
                /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped within ``BytesError/UUIDDecodingError``, ``BytesError/RawRepresentableError``, and ``BytesError/IterationError`` respectively.
                public typealias BufferSizeError = UUIDDecodingError<BytesError.BufferSizeError>
                
                /// A ``BytesError/ContiguousBytesError`` error thrown when the receiving buffer cannot efficiently be made contiguous for casting, wrapped within ``BytesError/UUIDDecodingError``, ``BytesError/RawRepresentableError``, and ``BytesError/IterationError``.
                public typealias ContiguousBytesError<CastingFailure: ByteCastingError> = UUIDDecodingError<BytesError.ContiguousBytesError<CastingFailure>>
                
                /// A namespace for errors wrapped within ``BytesError/ContiguousBytesError``, ``BytesError/UUIDDecodingError``, ``BytesError/RawRepresentableError``, and ``BytesError/IterationError`` respectively.
                public enum ContiguousBytes {
                    /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped within ``BytesError/ContiguousBytesError``, ``BytesError/UUIDDecodingError``, ``BytesError/RawRepresentableError``, and ``BytesError/IterationError`` respectively.
                    public typealias BufferSizeError = ContiguousBytesError<BytesError.BufferSizeError>
                }
            }
        }
        
        /// A ``BytesError/SequenceCheckError`` error thrown when the checked byte was not found as the next consumable element, wrapped in a ``BytesError/IterationError``.
        public typealias SequenceCheckError = IterationError<BytesError.SequenceCheckError, IterationFailure>
        
        /// A ``BytesError/UUIDDecodingError`` error thrown when a UUID could not be constructed from the byte sequence, wrapped in a ``BytesError/IterationError``.
        public typealias UUIDDecodingError<CastingFailure: ByteCastingError> = IterationError<BytesError.UUIDDecodingError<CastingFailure>, IterationFailure>
        
        /// A namespace for errors wrapped within ``BytesError/UUIDDecodingError`` and ``BytesError/IterationError`` respectively.
        public enum UUIDDecoding {
            /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped within ``BytesError/UUIDDecodingError`` and ``BytesError/IterationError`` respectively.
            public typealias BufferSizeError = UUIDDecodingError<BytesError.BufferSizeError>
            
            /// A ``BytesError/ContiguousBytesError`` error thrown when the receiving buffer cannot efficiently be made contiguous for casting, wrapped within ``BytesError/UUIDDecodingError`` and ``BytesError/IterationError``.
            public typealias ContiguousBytesError<CastingFailure: ByteCastingError> = UUIDDecodingError<BytesError.ContiguousBytesError<CastingFailure>>
            
            /// A namespace for errors wrapped within ``BytesError/ContiguousBytesError``, ``BytesError/UUIDDecodingError``, and ``BytesError/IterationError`` respectively.
            public enum ContiguousBytes {
                /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped within ``BytesError/ContiguousBytesError``, ``BytesError/UUIDDecodingError``, and ``BytesError/IterationError`` respectively.
                public typealias BufferSizeError = ContiguousBytesError<BytesError.BufferSizeError>
            }
        }
    }
    
    /// A namespace for errors wrapped within a ``TransformationError``.
    public enum Transformation<TransformationFailure: Error> {
        /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped in a ``BytesError/TransformationError``.
        public typealias BufferSizeError = TransformationError<BytesError.BufferSizeError, TransformationFailure>
        
        /// A ``BytesError/CharacterDecodingError`` error thrown when a character could not be constructed from the byte sequence, wrapped in a ``BytesError/TransformationError``.
        public typealias CharacterDecodingError = TransformationError<BytesError.CharacterDecodingError, TransformationFailure>
        
        /// A ``BytesError/ContiguousBytesError`` error thrown when the receiving buffer cannot efficiently be made contiguous for casting, wrapped in a ``BytesError/TransformationError``.
        public typealias ContiguousBytesError<CastingFailure: ByteCastingError> = TransformationError<BytesError.ContiguousBytesError<CastingFailure>, TransformationFailure>
        
        /// A namespace for errors wrapped within ``BytesError/ContiguousBytesError`` and ``BytesError/TransformationError`` respectively.
        public enum ContiguousBytes {
            /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped within ``BytesError/ContiguousBytesError`` and ``BytesError/TransformationError`` respectively.
            public typealias BufferSizeError = ContiguousBytesError<BytesError.BufferSizeError>
        }
        
        /// A ``BytesError/RawRepresentableError`` error thrown while initializing a `RawRepresentable` type with raw bytes, wrapped in a ``BytesError/TransformationError``.
        public typealias RawRepresentableError<CastingFailure: ByteCastingError> = TransformationError<BytesError.RawRepresentableError<CastingFailure>, TransformationFailure>
        
        /// A namespace for errors wrapped within ``BytesError/RawRepresentableError`` and ``BytesError/TransformationError`` respectively.
        public enum RawRepresentable {
            /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, within ``BytesError/RawRepresentableError`` and ``BytesError/TransformationError`` respectively.
            public typealias BufferSizeError = RawRepresentableError<BytesError.BufferSizeError>
            
            /// A ``BytesError/CharacterDecodingError`` error thrown when the a character could not be constructed from the byte sequence, within ``BytesError/RawRepresentableError`` and ``BytesError/TransformationError`` respectively.
            public typealias CharacterDecodingError = RawRepresentableError<BytesError.CharacterDecodingError>
            
            /// A ``BytesError/ContiguousBytesError`` error thrown when the receiving buffer cannot efficiently be made contiguous for casting, within ``BytesError/RawRepresentableError`` and ``BytesError/TransformationError`` respectively.
            public typealias ContiguousBytesError<CastingFailure: ByteCastingError> = RawRepresentableError<BytesError.ContiguousBytesError<CastingFailure>>
            
            /// A namespace for errors wrapped within ``BytesError/ContiguousBytesError`` and ``BytesError/RawRepresentableError`` respectively.
            public enum ContiguousBytes {
                /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped within ``BytesError/ContiguousBytesError``, ``BytesError/RawRepresentableError``, and ``BytesError/TransformationError`` respectively.
                public typealias BufferSizeError = ContiguousBytesError<BytesError.BufferSizeError>
            }
            
            /// A ``BytesError/SequenceCheckError`` error thrown when the checked byte was not found as the next consumable element, wrapped within ``BytesError/RawRepresentableError`` and ``BytesError/TransformationError`` respectively.
            public typealias SequenceCheckError = RawRepresentableError<BytesError.SequenceCheckError>
            
            /// A ``BytesError/UUIDDecodingError`` error thrown when a UUID could not be constructed from the byte sequence, wrapped within ``BytesError/RawRepresentableError`` and ``BytesError/TransformationError`` respectively.
            public typealias UUIDDecodingError<CastingFailure: ByteCastingError> = RawRepresentableError<BytesError.UUIDDecodingError<CastingFailure>>
            
            /// A namespace for errors wrapped within ``BytesError/UUIDDecodingError``, ``BytesError/RawRepresentableError``, and ``BytesError/TransformationError`` respectively.
            public enum UUIDDecoding {
                /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped within ``BytesError/UUIDDecodingError``, ``BytesError/RawRepresentableError``, and ``BytesError/TransformationError`` respectively.
                public typealias BufferSizeError = UUIDDecodingError<BytesError.BufferSizeError>
                
                /// A ``BytesError/ContiguousBytesError`` error thrown when the receiving buffer cannot efficiently be made contiguous for casting, wrapped within ``BytesError/UUIDDecodingError``, ``BytesError/RawRepresentableError``, and ``BytesError/TransformationError``.
                public typealias ContiguousBytesError<CastingFailure: ByteCastingError> = UUIDDecodingError<BytesError.ContiguousBytesError<CastingFailure>>
                
                /// A namespace for errors wrapped within ``BytesError/ContiguousBytesError``, ``BytesError/UUIDDecodingError``, ``BytesError/RawRepresentableError``, and ``BytesError/TransformationError`` respectively.
                public enum ContiguousBytes {
                    /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped within ``BytesError/ContiguousBytesError``, ``BytesError/UUIDDecodingError``, ``BytesError/RawRepresentableError``, and ``BytesError/TransformationError`` respectively.
                    public typealias BufferSizeError = ContiguousBytesError<BytesError.BufferSizeError>
                }
            }
        }
        
        /// A ``BytesError/SequenceCheckError`` error thrown when the checked byte was not found as the next consumable element, wrapped in a ``BytesError/TransformationError``.
        public typealias SequenceCheckError = TransformationError<BytesError.SequenceCheckError, TransformationFailure>
        
        /// A ``BytesError/UUIDDecodingError`` error thrown when a UUID could not be constructed from the byte sequence, wrapped in a ``BytesError/TransformationError``.
        public typealias UUIDDecodingError<CastingFailure: ByteCastingError> = TransformationError<BytesError.UUIDDecodingError<CastingFailure>, TransformationFailure>
        
        /// A namespace for errors wrapped within ``BytesError/UUIDDecodingError`` and ``BytesError/TransformationError`` respectively.
        public enum UUIDDecoding {
            /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped within ``BytesError/UUIDDecodingError`` and ``BytesError/TransformationError`` respectively.
            public typealias BufferSizeError = UUIDDecodingError<BytesError.BufferSizeError>
            
            /// A ``BytesError/ContiguousBytesError`` error thrown when the receiving buffer cannot efficiently be made contiguous for casting, wrapped within ``BytesError/UUIDDecodingError`` and ``BytesError/TransformationError``.
            public typealias ContiguousBytesError<CastingFailure: ByteCastingError> = UUIDDecodingError<BytesError.ContiguousBytesError<CastingFailure>>
            
            /// A namespace for errors wrapped within ``BytesError/ContiguousBytesError``, ``BytesError/UUIDDecodingError``, and ``BytesError/TransformationError`` respectively.
            public enum ContiguousBytes {
                /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped within ``BytesError/ContiguousBytesError``, ``BytesError/UUIDDecodingError``, and ``BytesError/TransformationError`` respectively.
                public typealias BufferSizeError = ContiguousBytesError<BytesError.BufferSizeError>
            }
        }
    }
    
    /// A namespace for errors wrapped within a ``BytesError/UUIDDecodingError``.
    public enum UUIDDecoding {
        /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped in a ``BytesError/UUIDDecodingError`` respectively.
        public typealias BufferSizeError = UUIDDecodingError<BytesError.BufferSizeError>
        
        /// A ``BytesError/ContiguousBytesError`` error thrown when the receiving buffer cannot efficiently be made contiguous for casting, wrapped in a ``BytesError/UUIDDecodingError``.
        public typealias ContiguousBytesError<CastingFailure: ByteCastingError> = UUIDDecodingError<BytesError.ContiguousBytesError<CastingFailure>>
        
        /// A namespace for errors wrapped within ``BytesError/ContiguousBytesError`` and ``BytesError/UUIDDecodingError`` respectively.
        public enum ContiguousBytes {
            /// A ``BytesError/BufferSizeError`` error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped within ``BytesError/ContiguousBytesError`` and ``BytesError/UUIDDecodingError`` respectively.
            public typealias BufferSizeError = ContiguousBytesError<BytesError.BufferSizeError>
        }
    }
}
