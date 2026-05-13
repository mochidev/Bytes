//
//  BytesError.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 11/6/20.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

public enum BytesError: Error {
    case invalidMemorySize(targetSize: Int, targetType: String, actualSize: Int)
    case contiguousMemoryUnavailable(type: String)
    
    case invalidCharacterByteSequence
    case invalidRawRepresentableByteSequence
    case invalidUUIDByteSequence
    
    case checkedSequenceNotFound
}

public protocol ByteCastingError: Error, Equatable, Hashable {}


extension BytesError {
    /// An error thrown while casting values to a given target type.
    public enum Casting: ByteCastingError {
        /// Consuming the sequence failed because an insufficient or invalid number of bytes were available before the sequence ended.
        case invalidMemorySize(targetSize: Int, targetType: String, actualSize: Int)
        /// Consuming the sequence failed because the underlying buffer is not contiguous and is over 4KB in size.
        /// - Note: Copy the sequence first if you know the expected casting size is correct.
        case contiguousMemoryUnavailable(type: String)
        
        @inlinable
        public init(_ error: BytesError.InvalidMemorySize) {
            self = .invalidMemorySize(targetSize: error.targetSize, targetType: error.targetType, actualSize: error.actualSize)
        }
    }
    
    /// An error thrown while casting values to a given target type, wrapped in a ``BytesError/Iteration`` error.
    public typealias IteratedCasting<Failure: Error> = Iteration<Casting, Failure>
    /// An error thrown while casting values to a given target type, wrapped in a ``BytesError/Transformation`` error.
    public typealias TransformedCasting<Failure: Error> = Transformation<Casting, Failure>
}

extension ByteCastingError where Self == BytesError.Casting {
    /// Consuming the sequence failed because an insufficient or invalid number of bytes were available before the sequence ended.
    @inlinable
    @_disfavoredOverload
    public static func invalidMemorySize(targetSize: Int, targetType: String, actualSize: Int) -> Self {
        .invalidMemorySize(targetSize: targetSize, targetType: targetType, actualSize: actualSize)
    }
    
    /// Consuming the sequence failed because the underlying buffer is not contiguous and is over 4KB in size.
    /// - Note: Copy the sequence first if you know the expected casting size is correct.
    @inlinable
    @_disfavoredOverload
    public static func contiguousMemoryUnavailable(type: String) -> Self {
        .contiguousMemoryUnavailable(type: type)
    }
}


extension BytesError {
    /// An error thrown when the checked byte was not found as the next consumable element.
    public struct CheckedSequenceNotFound: ByteCastingError {
        /// An error thrown when the checked byte was not found as the next consumable element.
        @inlinable
        public init() {}
    }
    
    /// An error thrown when the checked byte was not found as the next consumable element, wrapped in a ``BytesError/Iteration`` error.
    public typealias IteratedCheckedSequenceNotFound<Failure: Error> = Iteration<CheckedSequenceNotFound, Failure>
    /// An error thrown when the checked byte was not found as the next consumable element, wrapped in a ``BytesError/Transformation`` error.
    public typealias TransformedCheckedSequenceNotFound<Failure: Error> = Transformation<CheckedSequenceNotFound, Failure>
}

extension ByteCastingError where Self == BytesError.CheckedSequenceNotFound {
    /// An error thrown when the checked byte was not found as the next consumable element.
    @inlinable
    public static var checkedSequenceNotFound: Self {
        Self()
    }
}


extension BytesError {
    /// An error thrown when the a character could not be constructed from the byte sequence.
    public struct Character: ByteCastingError {
        /// An error thrown when the a character could not be constructed from the byte sequence.
        @inlinable
        public init() {}
    }
}

extension ByteCastingError where Self == BytesError.Character {
    /// An error thrown when the a character could not be constructed from the byte sequence.
    @inlinable
    public static var invalidCharacterByteSequence: Self {
        Self()
    }
}


extension BytesError {
    /// An error thrown when an insufficient or invalid number of bytes were available before the sequence ended.
    public struct InvalidMemorySize: ByteCastingError {
        /// The required size of the buffer.
        public var targetSize: Int
        /// The type that was being casted.
        public var targetType: String
        /// The actual available size of the buffer.
        public var actualSize: Int
        
        @inlinable
        public init(targetSize: Int, targetType: String, actualSize: Int) {
            self.targetSize = targetSize
            self.targetType = targetType
            self.actualSize = actualSize
        }
    }
    
    /// An error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped in a ``BytesError/Iteration`` error.
    public typealias IteratedInvalidMemorySize<Failure: Error> = Iteration<InvalidMemorySize, Failure>
    /// An error thrown when an insufficient or invalid number of bytes were available before the sequence ended, wrapped in a ``BytesError/Transformation`` error.
    public typealias TransformedInvalidMemorySize<Failure: Error> = Transformation<InvalidMemorySize, Failure>
}

extension BytesError.TransformedInvalidMemorySize<BytesError.Casting> {
    @inlinable
    public var flattened: BytesError.Casting {
        switch self {
        case .consumptionFailure(let error):
            .init(error)
        case .transformationFailure(let error):
            error
        }
    }
}

extension ByteCastingError where Self == BytesError.InvalidMemorySize {
    /// An error thrown when an insufficient or invalid number of bytes were available before the sequence ended.
    @inlinable
    public static func invalidMemorySize(targetSize: Int, targetType: String, actualSize: Int) -> Self {
        Self(targetSize: targetSize, targetType: targetType, actualSize: actualSize)
    }
}


extension BytesError {
    /// An error thrown when consuming a sequence.
    public enum Iteration<
        ConsumptionFailure: ByteCastingError,
        IterationFailure: Error
    >: Error {
        /// An error was thrown consuming elements off the sequence.
        case consumptionFailure(ConsumptionFailure)
        /// An error was thrown by the underlying iterator.
        case iterationFailure(IterationFailure)
    }
}

extension BytesError.Iteration: Equatable where IterationFailure: Equatable {}
extension BytesError.Iteration: Hashable where IterationFailure: Hashable {}


extension BytesError {
    /// An error thrown when consuming a sequence.
    public enum Transformation<
        ConsumptionFailure: ByteCastingError,
        TransformationFailure: Error
    >: Error {
        /// An error was thrown consuming the sequence of bytes.
        case consumptionFailure(ConsumptionFailure)
        /// An error was thrown during transformation.
        case transformationFailure(TransformationFailure)
    }
}

extension BytesError.Transformation: Equatable where TransformationFailure: Equatable {}
extension BytesError.Transformation: Hashable where TransformationFailure: Hashable {}
