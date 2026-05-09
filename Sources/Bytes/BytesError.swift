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
    /// An error thrown when the checked byte was not found as the next consumable element.
    public struct CheckedSequenceNotFound: ByteCastingError {
        /// An error thrown when the checked byte was not found as the next consumable element.
        @inlinable
        public init() {}
    }
    
    /// An error thrown when the checked byte was not found as the next consumable element, wrapped in a ``BytesError/Iteration`` error.
    public typealias IteratedCheckedSequenceNotFound<Failure: Error> = Iteration<CheckedSequenceNotFound, Failure>
}

extension ByteCastingError where Self == BytesError.CheckedSequenceNotFound {
    /// An error thrown when the checked byte was not found as the next consumable element.
    @inlinable
    public static var checkedSequenceNotFound: Self {
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
