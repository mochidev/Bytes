//
//  BytesErrorTests.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 2026-06-14.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

import Bytes
import Testing

@Suite struct BytesErrorTests {
    struct EquatableError: Error, Equatable {
        var a: Int
    }
    struct OtherEquatableError: Error, Equatable {}
    class NonEquatableError: Error, @unchecked Sendable {}
    
    @Test func bufferSizeError() {
        #expect(BytesError.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))
        #expect(BytesError.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 2))
    }
    
    @Test func characterDecodingError() {
        #expect(BytesError.CharacterDecodingError.invalidCharacterByteSequence == .invalidCharacterByteSequence)
    }
    
    @Test func contiguousBytesError() {
        #expect(BytesError.ContiguousBytesError<BytesError.BufferSizeError>.contiguousBytesUnavailable(type: "A") == .contiguousBytesUnavailable(type: "A"))
        #expect(BytesError.ContiguousBytesError<BytesError.BufferSizeError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.ContiguousBytesError<BytesError.CharacterDecodingError>.castingFailure(.invalidCharacterByteSequence) == .castingFailure(.invalidCharacterByteSequence))
        
        #expect(BytesError.ContiguousBytesError<BytesError.BufferSizeError>.contiguousBytesUnavailable(type: "A") != .contiguousBytesUnavailable(type: "B"))
        #expect(BytesError.ContiguousBytesError<BytesError.BufferSizeError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .contiguousBytesUnavailable(type: "A"))
        #expect(BytesError.ContiguousBytesError<BytesError.BufferSizeError>.contiguousBytesUnavailable(type: "A") != .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.ContiguousBytesError<BytesError.BufferSizeError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 2)))
    }
    
    @Test func contiguousBytesBufferSizeError() {
        #expect(BytesError.ContiguousBytesError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.ContiguousBytesError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.ContiguousBytesError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != BytesError.ContiguousBytesError<BytesError.BufferSizeError>.contiguousBytesUnavailable(type: "A"))
        
        #expect(BytesError.ContiguousBytes.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .contiguousBytesUnavailable(type: "A"))
    }
    
    @Test func iterationError() {
        #expect(BytesError.IterationError<BytesError.BufferSizeError, EquatableError>.iterationFailure(EquatableError(a: 0)) == .iterationFailure(EquatableError(a: 0)))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, EquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, NonEquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, Never>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        
        #expect(BytesError.IterationError<BytesError.BufferSizeError, any Error>.iterationFailure(EquatableError(a: 0)) == .iterationFailure(EquatableError(a: 0)))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, any Error>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, any Error>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, any Error>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        
        #expect(BytesError.IterationError<BytesError.BufferSizeError, EquatableError>.iterationFailure(EquatableError(a: 0)) != .iterationFailure(EquatableError(a: 1)))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, NonEquatableError>.iterationFailure(NonEquatableError()) != .iterationFailure(NonEquatableError()))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, any Error>.iterationFailure(OtherEquatableError()) == .iterationFailure(OtherEquatableError()))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, EquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .iterationFailure(EquatableError(a: 0)))
        #expect((BytesError.IterationError<BytesError.BufferSizeError, EquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .iterationFailure(EquatableError(a: 0))) == false)
        #expect(BytesError.IterationError<BytesError.BufferSizeError, NonEquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A)", actualSize: 1)) != .iterationFailure(NonEquatableError()))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, EquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 2)))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, NonEquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 2)))
        
        #expect(BytesError.IterationError<BytesError.BufferSizeError, any Error>.iterationFailure(EquatableError(a: 0)) != .iterationFailure(EquatableError(a: 1)))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, any Error>.iterationFailure(EquatableError(a: 0)) != .iterationFailure(NonEquatableError()))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, any Error>.iterationFailure(EquatableError(a: 0)) != .iterationFailure(OtherEquatableError()))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, any Error>.iterationFailure(NonEquatableError()) != .iterationFailure(NonEquatableError()))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, any Error>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .iterationFailure(EquatableError(a: 0)))
        #expect((BytesError.IterationError<BytesError.BufferSizeError, any Error>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .iterationFailure(EquatableError(a: 0))) == false)
        #expect(BytesError.IterationError<BytesError.BufferSizeError, any Error>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .iterationFailure(NonEquatableError()))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, any Error>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 2)))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, any Error>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 2)))
        
        
        #expect(BytesError.IterationError<BytesError.BufferSizeError, EquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)).mapCastingFailure({ _ in BytesError.CharacterDecodingError.invalidCharacterByteSequence }) == .castingFailure(.invalidCharacterByteSequence))
        #expect(BytesError.IterationError<BytesError.BufferSizeError, EquatableError>.iterationFailure(EquatableError(a: 0)).mapCastingFailure({ _ in BytesError.CharacterDecodingError.invalidCharacterByteSequence }) == .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationBufferSizeError() {
        #expect(BytesError.IterationError<_, EquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.IterationError<_, EquatableError>.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.IterationError<_, EquatableError>.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.Iteration<EquatableError>.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.Iteration<EquatableError>.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationCharacterDecodingError() {
        #expect(BytesError.IterationError<_, EquatableError>.castingFailure(.invalidCharacterByteSequence) == .castingFailure(.invalidCharacterByteSequence))
        #expect(BytesError.IterationError<_, EquatableError>.invalidCharacterByteSequence == .castingFailure(.invalidCharacterByteSequence))
        #expect(BytesError.IterationError<_, EquatableError>.invalidCharacterByteSequence != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.CharacterDecodingError.castingFailure(.invalidCharacterByteSequence) == .castingFailure(.invalidCharacterByteSequence))
        #expect(BytesError.Iteration<EquatableError>.CharacterDecodingError.invalidCharacterByteSequence == .castingFailure(.invalidCharacterByteSequence))
        #expect(BytesError.Iteration<EquatableError>.CharacterDecodingError.invalidCharacterByteSequence != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationContiguousBytesError() {
        #expect(BytesError.IterationError<_, EquatableError>.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.IterationError<_, EquatableError>.contiguousBytesUnavailable(type: "A") == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.IterationError<_, EquatableError>.contiguousBytesUnavailable(type: "A") != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.ContiguousBytesError<Never>.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.Iteration<EquatableError>.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.Iteration<EquatableError>.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationContiguousBytesBufferSizeError() {
        #expect(BytesError.Iteration<EquatableError>.ContiguousBytes.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.Iteration<EquatableError>.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.Iteration<EquatableError>.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.ContiguousBytes.BufferSizeError.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.Iteration<EquatableError>.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.Iteration<EquatableError>.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationRawRepresentableError() {
        #expect(BytesError.IterationError<_, EquatableError>.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.IterationError<_, EquatableError>.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.IterationError<_, EquatableError>.invalidRawRepresentableByteSequence(rawType: "A") != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.RawRepresentableError<Never>.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentableError<Never>.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentableError<Never>.invalidRawRepresentableByteSequence(rawType: "A") != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationRawRepresentableBufferSizeError() {
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.BufferSizeError.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "A") != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationRawRepresentableCharacterDecodingError() {
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.CharacterDecodingError.castingFailure(.invalidCharacterByteSequence) == .castingFailure(.castingFailure(.invalidCharacterByteSequence)))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.CharacterDecodingError.invalidCharacterByteSequence == .castingFailure(.castingFailure(.invalidCharacterByteSequence)))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.CharacterDecodingError.invalidCharacterByteSequence != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.CharacterDecodingError.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.CharacterDecodingError.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.CharacterDecodingError.invalidRawRepresentableByteSequence(rawType: "A") != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationRawRepresentableContiguousBytesError() {
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.ContiguousBytesError<Never>.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.ContiguousBytesError<Never>.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.ContiguousBytesError<Never>.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.ContiguousBytesError<Never>.invalidRawRepresentableByteSequence(rawType: "A") != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationRawRepresentableContiguousBytesBufferSizeError() {
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "A") != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationRawRepresentableSequenceCheckError() {
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.SequenceCheckError.castingFailure(.checkedSequenceNotFound) == .castingFailure(.castingFailure(.checkedSequenceNotFound)))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.SequenceCheckError.checkedSequenceNotFound == .castingFailure(.castingFailure(.checkedSequenceNotFound)))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.SequenceCheckError.checkedSequenceNotFound != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.SequenceCheckError.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.SequenceCheckError.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.SequenceCheckError.invalidRawRepresentableByteSequence(rawType: "A") != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationRawRepresentableUUIDDecodingError() {
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecodingError<Never>.castingFailure(.invalidUUIDByteSequence()) == .castingFailure(.castingFailure(.invalidUUIDByteSequence)))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecodingError<Never>.invalidUUIDByteSequence() == .castingFailure(.castingFailure(.invalidUUIDByteSequence)))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecodingError<Never>.invalidUUIDByteSequence() != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecodingError<Never>.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecodingError<Never>.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecodingError<Never>.invalidRawRepresentableByteSequence(rawType: "A") != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationRawRepresentableUUIDDecodingBufferSizeError() {
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.castingFailure(.invalidUUIDByteSequence()) == .castingFailure(.castingFailure(.invalidUUIDByteSequence)))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence() == .castingFailure(.castingFailure(.invalidUUIDByteSequence)))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence() != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "A") != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationRawRepresentableUUIDDecodingContiguousBytesError() {
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))) == .castingFailure(.castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A")))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A")))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") == .castingFailure(.castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A")))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.castingFailure(.invalidUUIDByteSequence()) == .castingFailure(.castingFailure(.invalidUUIDByteSequence)))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.invalidUUIDByteSequence() == .castingFailure(.castingFailure(.invalidUUIDByteSequence)))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.invalidUUIDByteSequence() != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.invalidRawRepresentableByteSequence(rawType: "A") != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationRawRepresentableUUIDDecodingContiguousBytesBufferSizeError() {
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))) == .castingFailure(.castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))) == .castingFailure(.castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))) == .castingFailure(.castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A")))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A")))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") == .castingFailure(.castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A")))))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.invalidUUIDByteSequence()) == .castingFailure(.castingFailure(.invalidUUIDByteSequence)))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidUUIDByteSequence() == .castingFailure(.castingFailure(.invalidUUIDByteSequence)))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidUUIDByteSequence() != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Iteration<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "A") != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationSequenceCheckError() {
        #expect(BytesError.IterationError<_, EquatableError>.castingFailure(.checkedSequenceNotFound) == .castingFailure(.checkedSequenceNotFound))
        #expect(BytesError.IterationError<_, EquatableError>.checkedSequenceNotFound == .castingFailure(.checkedSequenceNotFound))
        #expect(BytesError.IterationError<_, EquatableError>.checkedSequenceNotFound != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.SequenceCheckError.castingFailure(.checkedSequenceNotFound) == .castingFailure(.checkedSequenceNotFound))
        #expect(BytesError.Iteration<EquatableError>.SequenceCheckError.checkedSequenceNotFound == .castingFailure(.checkedSequenceNotFound))
        #expect(BytesError.Iteration<EquatableError>.SequenceCheckError.checkedSequenceNotFound != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationUUIDDecodingError() {
        #expect(BytesError.IterationError<_, EquatableError>.castingFailure(.invalidUUIDByteSequence) == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.IterationError<_, EquatableError>.invalidUUIDByteSequence() == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.IterationError<_, EquatableError>.invalidUUIDByteSequence() != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.UUIDDecodingError<Never>.castingFailure(.invalidUUIDByteSequence) == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecodingError<Never>.invalidUUIDByteSequence() == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecodingError<Never>.invalidUUIDByteSequence() != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationUUIDDecodingBufferSizeError() {
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.BufferSizeError.castingFailure(.invalidUUIDByteSequence) == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence() == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence() != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationUUIDDecodingContiguousBytesError() {
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.ContiguousBytesError<Never>.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.ContiguousBytesError<Never>.castingFailure(.invalidUUIDByteSequence) == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.ContiguousBytesError<Never>.invalidUUIDByteSequence() == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.ContiguousBytesError<Never>.invalidUUIDByteSequence() != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func iterationUUIDDecodingContiguousBytesBufferSizeError() {
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") != .iterationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.invalidUUIDByteSequence) == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidUUIDByteSequence() == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.Iteration<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidUUIDByteSequence() != .iterationFailure(EquatableError(a: 0)))
    }
    
    @Test func rawRepresentableError() {
        #expect(BytesError.RawRepresentableError<BytesError.BufferSizeError>.invalidRawRepresentableByteSequence(rawType: "A") == .invalidRawRepresentableByteSequence(rawType: "A"))
        #expect(BytesError.RawRepresentableError<BytesError.BufferSizeError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.RawRepresentableError<BytesError.CharacterDecodingError>.castingFailure(.invalidCharacterByteSequence) == .castingFailure(.invalidCharacterByteSequence))
        
        #expect(BytesError.RawRepresentableError<BytesError.BufferSizeError>.invalidRawRepresentableByteSequence(rawType: "A") != .invalidRawRepresentableByteSequence(rawType: "B"))
        #expect(BytesError.RawRepresentableError<BytesError.BufferSizeError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .invalidRawRepresentableByteSequence(rawType: "A"))
        #expect(BytesError.RawRepresentableError<BytesError.BufferSizeError>.invalidRawRepresentableByteSequence(rawType: "A") != .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.RawRepresentableError<BytesError.BufferSizeError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 2)))
    }
    
    @Test func rawRepresentableBufferSizeError() {
        #expect(BytesError.RawRepresentableError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.RawRepresentableError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.RawRepresentableError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .invalidRawRepresentableByteSequence(rawType: "A"))
        
        #expect(BytesError.RawRepresentable.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .invalidRawRepresentableByteSequence(rawType: "A"))
    }
    
    @Test func rawRepresentableCharacterDecodingError() {
        #expect(BytesError.RawRepresentableError.castingFailure(.invalidCharacterByteSequence) == .castingFailure(.invalidCharacterByteSequence))
        #expect(BytesError.RawRepresentableError.invalidCharacterByteSequence == .castingFailure(.invalidCharacterByteSequence))
        #expect(BytesError.RawRepresentableError.invalidCharacterByteSequence != .invalidRawRepresentableByteSequence(rawType: "A"))
        
        #expect(BytesError.RawRepresentable.CharacterDecodingError.castingFailure(.invalidCharacterByteSequence) == .castingFailure(.invalidCharacterByteSequence))
        #expect(BytesError.RawRepresentable.CharacterDecodingError.invalidCharacterByteSequence == .castingFailure(.invalidCharacterByteSequence))
        #expect(BytesError.RawRepresentable.CharacterDecodingError.invalidCharacterByteSequence != .invalidRawRepresentableByteSequence(rawType: "A"))
    }
    
    @Test func rawRepresentableContiguousBytesError() {
        #expect(BytesError.RawRepresentableError.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.RawRepresentableError.contiguousBytesUnavailable(type: "A") == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.RawRepresentableError.contiguousBytesUnavailable(type: "A") != .invalidRawRepresentableByteSequence(rawType: "A"))
        
        #expect(BytesError.RawRepresentable.ContiguousBytesError<Never>.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.RawRepresentable.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.RawRepresentable.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") != .invalidRawRepresentableByteSequence(rawType: "A"))
    }
    
    @Test func rawRepresentableContiguousBytesBufferSizeError() {
        #expect(BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .invalidRawRepresentableByteSequence(rawType: "A"))
        
        #expect(BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") != .invalidRawRepresentableByteSequence(rawType: "A"))
    }
    
    @Test func rawRepresentableSequenceCheckError() {
        #expect(BytesError.RawRepresentableError.castingFailure(.checkedSequenceNotFound) == .castingFailure(.checkedSequenceNotFound))
        #expect(BytesError.RawRepresentableError.checkedSequenceNotFound == .castingFailure(.checkedSequenceNotFound))
        #expect(BytesError.RawRepresentableError.checkedSequenceNotFound != .invalidRawRepresentableByteSequence(rawType: "A"))
        
        #expect(BytesError.RawRepresentable.SequenceCheckError.castingFailure(.checkedSequenceNotFound) == .castingFailure(.checkedSequenceNotFound))
        #expect(BytesError.RawRepresentable.SequenceCheckError.checkedSequenceNotFound == .castingFailure(.checkedSequenceNotFound))
        #expect(BytesError.RawRepresentable.SequenceCheckError.checkedSequenceNotFound != .invalidRawRepresentableByteSequence(rawType: "A"))
    }
    
    @Test func rawRepresentableUUIDDecodingError() {
        #expect(BytesError.RawRepresentableError.castingFailure(.invalidUUIDByteSequence) == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.RawRepresentableError.invalidUUIDByteSequence() == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.RawRepresentableError.invalidUUIDByteSequence() != .invalidRawRepresentableByteSequence(rawType: "A"))
        
        #expect(BytesError.RawRepresentable.UUIDDecodingError<Never>.castingFailure(.invalidUUIDByteSequence) == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.RawRepresentable.UUIDDecodingError<Never>.invalidUUIDByteSequence() == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.RawRepresentable.UUIDDecodingError<Never>.invalidUUIDByteSequence() != .invalidRawRepresentableByteSequence(rawType: "A"))
    }
    
    @Test func rawRepresentableUUIDDecodingBufferSizeError() {
        #expect(BytesError.RawRepresentable.UUIDDecoding.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.RawRepresentable.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.RawRepresentable.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .invalidRawRepresentableByteSequence(rawType: "A"))
        
        #expect(BytesError.RawRepresentable.UUIDDecoding.BufferSizeError.castingFailure(.invalidUUIDByteSequence) == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.RawRepresentable.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence() == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.RawRepresentable.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence() != .invalidRawRepresentableByteSequence(rawType: "A"))
    }
    
    @Test func rawRepresentableUUIDDecodingContiguousBytesError() {
        #expect(BytesError.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") != .invalidRawRepresentableByteSequence(rawType: "A"))
        
        #expect(BytesError.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.castingFailure(.invalidUUIDByteSequence) == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.invalidUUIDByteSequence() == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.invalidUUIDByteSequence() != .invalidRawRepresentableByteSequence(rawType: "A"))
    }
    
    @Test func rawRepresentableUUIDDecodingContiguousBytesBufferSizeError() {
        #expect(BytesError.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .invalidRawRepresentableByteSequence(rawType: "A"))
        
        #expect(BytesError.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") != .invalidRawRepresentableByteSequence(rawType: "A"))
        
        #expect(BytesError.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.invalidUUIDByteSequence) == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidUUIDByteSequence() == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidUUIDByteSequence() != .invalidRawRepresentableByteSequence(rawType: "A"))
    }
    
    @Test func sequenceCheckError() {
        #expect(BytesError.SequenceCheckError.checkedSequenceNotFound == .checkedSequenceNotFound)
    }
    
    @Test func transformationError() {
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, EquatableError>.transformationFailure(EquatableError(a: 0)) == .transformationFailure(EquatableError(a: 0)))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, EquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, NonEquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, Never>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, any Error>.transformationFailure(EquatableError(a: 0)) == .transformationFailure(EquatableError(a: 0)))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, any Error>.transformationFailure(OtherEquatableError()) == .transformationFailure(OtherEquatableError()))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, any Error>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, any Error>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, any Error>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, EquatableError>.transformationFailure(EquatableError(a: 0)) != .transformationFailure(EquatableError(a: 1)))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, NonEquatableError>.transformationFailure(NonEquatableError()) != .transformationFailure(NonEquatableError()))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, EquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .transformationFailure(EquatableError(a: 0)))
        #expect((BytesError.TransformationError<BytesError.BufferSizeError, EquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .transformationFailure(EquatableError(a: 0))) == false)
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, NonEquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .transformationFailure(NonEquatableError()))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, EquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 2)))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, NonEquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 2)))
        
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, any Error>.transformationFailure(EquatableError(a: 0)) != .transformationFailure(EquatableError(a: 1)))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, any Error>.transformationFailure(EquatableError(a: 0)) != .transformationFailure(NonEquatableError()))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, any Error>.transformationFailure(EquatableError(a: 0)) != .transformationFailure(OtherEquatableError()))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, any Error>.transformationFailure(NonEquatableError()) != .transformationFailure(NonEquatableError()))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, any Error>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .transformationFailure(EquatableError(a: 0)))
        #expect((BytesError.TransformationError<BytesError.BufferSizeError, any Error>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .transformationFailure(EquatableError(a: 0))) == false)
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, any Error>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .transformationFailure(NonEquatableError()))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, any Error>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 2)))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, any Error>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 2)))
        
        
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, EquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)).mapCastingFailure({ _ in BytesError.CharacterDecodingError.invalidCharacterByteSequence }) == .castingFailure(.invalidCharacterByteSequence))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, EquatableError>.transformationFailure(EquatableError(a: 0)).mapCastingFailure({ _ in BytesError.CharacterDecodingError.invalidCharacterByteSequence }) == .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, BytesError.BufferSizeError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)).flattened == .invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))
        #expect(BytesError.TransformationError<BytesError.BufferSizeError, BytesError.BufferSizeError>.transformationFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)).flattened == .invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))
    }
    
    @Test func transformationBufferSizeError() {
        #expect(BytesError.TransformationError<_, EquatableError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.TransformationError<_, EquatableError>.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.TransformationError<_, EquatableError>.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.Transformation<EquatableError>.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.Transformation<EquatableError>.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationCharacterDecodingError() {
        #expect(BytesError.TransformationError<_, EquatableError>.castingFailure(.invalidCharacterByteSequence) == .castingFailure(.invalidCharacterByteSequence))
        #expect(BytesError.TransformationError<_, EquatableError>.invalidCharacterByteSequence == .castingFailure(.invalidCharacterByteSequence))
        #expect(BytesError.TransformationError<_, EquatableError>.invalidCharacterByteSequence != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.CharacterDecodingError.castingFailure(.invalidCharacterByteSequence) == .castingFailure(.invalidCharacterByteSequence))
        #expect(BytesError.Transformation<EquatableError>.CharacterDecodingError.invalidCharacterByteSequence == .castingFailure(.invalidCharacterByteSequence))
        #expect(BytesError.Transformation<EquatableError>.CharacterDecodingError.invalidCharacterByteSequence != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationContiguousBytesError() {
        #expect(BytesError.TransformationError<_, EquatableError>.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.TransformationError<_, EquatableError>.contiguousBytesUnavailable(type: "A") == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.TransformationError<_, EquatableError>.contiguousBytesUnavailable(type: "A") != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.ContiguousBytesError<Never>.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.Transformation<EquatableError>.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.Transformation<EquatableError>.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationContiguousBytesBufferSizeError() {
        #expect(BytesError.Transformation<EquatableError>.ContiguousBytes.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.Transformation<EquatableError>.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.Transformation<EquatableError>.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.ContiguousBytes.BufferSizeError.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.Transformation<EquatableError>.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.Transformation<EquatableError>.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationRawRepresentableError() {
        #expect(BytesError.TransformationError<_, EquatableError>.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.TransformationError<_, EquatableError>.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.TransformationError<_, EquatableError>.invalidRawRepresentableByteSequence(rawType: "A") != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.RawRepresentableError<Never>.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentableError<Never>.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentableError<Never>.invalidRawRepresentableByteSequence(rawType: "A") != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationRawRepresentableBufferSizeError() {
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.BufferSizeError.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "A") != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationRawRepresentableCharacterDecodingError() {
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.CharacterDecodingError.castingFailure(.invalidCharacterByteSequence) == .castingFailure(.castingFailure(.invalidCharacterByteSequence)))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.CharacterDecodingError.invalidCharacterByteSequence == .castingFailure(.castingFailure(.invalidCharacterByteSequence)))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.CharacterDecodingError.invalidCharacterByteSequence != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.CharacterDecodingError.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.CharacterDecodingError.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.CharacterDecodingError.invalidRawRepresentableByteSequence(rawType: "A") != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationRawRepresentableContiguousBytesError() {
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.ContiguousBytesError<Never>.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.ContiguousBytesError<Never>.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.ContiguousBytesError<Never>.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.ContiguousBytesError<Never>.invalidRawRepresentableByteSequence(rawType: "A") != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationRawRepresentableContiguousBytesBufferSizeError() {
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "A") != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationRawRepresentableSequenceCheckError() {
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.SequenceCheckError.castingFailure(.checkedSequenceNotFound) == .castingFailure(.castingFailure(.checkedSequenceNotFound)))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.SequenceCheckError.checkedSequenceNotFound == .castingFailure(.castingFailure(.checkedSequenceNotFound)))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.SequenceCheckError.checkedSequenceNotFound != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.SequenceCheckError.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.SequenceCheckError.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.SequenceCheckError.invalidRawRepresentableByteSequence(rawType: "A") != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationRawRepresentableUUIDDecodingError() {
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecodingError<Never>.castingFailure(.invalidUUIDByteSequence()) == .castingFailure(.castingFailure(.invalidUUIDByteSequence)))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecodingError<Never>.invalidUUIDByteSequence() == .castingFailure(.castingFailure(.invalidUUIDByteSequence)))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecodingError<Never>.invalidUUIDByteSequence() != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecodingError<Never>.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecodingError<Never>.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecodingError<Never>.invalidRawRepresentableByteSequence(rawType: "A") != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationRawRepresentableUUIDDecodingBufferSizeError() {
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.castingFailure(.invalidUUIDByteSequence()) == .castingFailure(.castingFailure(.invalidUUIDByteSequence)))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence() == .castingFailure(.castingFailure(.invalidUUIDByteSequence)))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence() != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "A") != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationRawRepresentableUUIDDecodingContiguousBytesError() {
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))) == .castingFailure(.castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A")))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A")))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") == .castingFailure(.castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A")))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.castingFailure(.invalidUUIDByteSequence()) == .castingFailure(.castingFailure(.invalidUUIDByteSequence)))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.invalidUUIDByteSequence() == .castingFailure(.castingFailure(.invalidUUIDByteSequence)))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.invalidUUIDByteSequence() != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytesError<Never>.invalidRawRepresentableByteSequence(rawType: "A") != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationRawRepresentableUUIDDecodingContiguousBytesBufferSizeError() {
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))) == .castingFailure(.castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))) == .castingFailure(.castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))) == .castingFailure(.castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A")))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A")))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") == .castingFailure(.castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A")))))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.invalidUUIDByteSequence()) == .castingFailure(.castingFailure(.invalidUUIDByteSequence)))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidUUIDByteSequence() == .castingFailure(.castingFailure(.invalidUUIDByteSequence)))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidUUIDByteSequence() != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")) == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "A") == .castingFailure(.invalidRawRepresentableByteSequence(rawType: "A")))
        #expect(BytesError.Transformation<EquatableError>.RawRepresentable.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "A") != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationSequenceCheckError() {
        #expect(BytesError.TransformationError<_, EquatableError>.castingFailure(.checkedSequenceNotFound) == .castingFailure(.checkedSequenceNotFound))
        #expect(BytesError.TransformationError<_, EquatableError>.checkedSequenceNotFound == .castingFailure(.checkedSequenceNotFound))
        #expect(BytesError.TransformationError<_, EquatableError>.checkedSequenceNotFound != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.SequenceCheckError.castingFailure(.checkedSequenceNotFound) == .castingFailure(.checkedSequenceNotFound))
        #expect(BytesError.Transformation<EquatableError>.SequenceCheckError.checkedSequenceNotFound == .castingFailure(.checkedSequenceNotFound))
        #expect(BytesError.Transformation<EquatableError>.SequenceCheckError.checkedSequenceNotFound != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationUUIDDecodingError() {
        #expect(BytesError.TransformationError<_, EquatableError>.castingFailure(.invalidUUIDByteSequence) == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.TransformationError<_, EquatableError>.invalidUUIDByteSequence() == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.TransformationError<_, EquatableError>.invalidUUIDByteSequence() != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.UUIDDecodingError<Never>.castingFailure(.invalidUUIDByteSequence) == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecodingError<Never>.invalidUUIDByteSequence() == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecodingError<Never>.invalidUUIDByteSequence() != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationUUIDDecodingBufferSizeError() {
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.BufferSizeError.castingFailure(.invalidUUIDByteSequence) == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence() == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.BufferSizeError.invalidUUIDByteSequence() != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationUUIDDecodingContiguousBytesError() {
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.ContiguousBytesError<Never>.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.ContiguousBytesError<Never>.castingFailure(.invalidUUIDByteSequence) == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.ContiguousBytesError<Never>.invalidUUIDByteSequence() == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.ContiguousBytesError<Never>.invalidUUIDByteSequence() != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func transformationUUIDDecodingContiguousBytesBufferSizeError() {
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") == .castingFailure(.castingFailure(.contiguousBytesUnavailable(type: "A"))))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") != .transformationFailure(EquatableError(a: 0)))
        
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.invalidUUIDByteSequence) == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidUUIDByteSequence() == .castingFailure(.invalidUUIDByteSequence))
        #expect(BytesError.Transformation<EquatableError>.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidUUIDByteSequence() != .transformationFailure(EquatableError(a: 0)))
    }
    
    @Test func uuidDecodingError() {
        #expect(BytesError.UUIDDecodingError<BytesError.BufferSizeError>.invalidUUIDByteSequence == .invalidUUIDByteSequence)
        #expect(BytesError.UUIDDecodingError<BytesError.BufferSizeError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.UUIDDecodingError<BytesError.CharacterDecodingError>.castingFailure(.invalidCharacterByteSequence) == .castingFailure(.invalidCharacterByteSequence))
        
        #expect(BytesError.UUIDDecodingError<BytesError.BufferSizeError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .invalidUUIDByteSequence)
        #expect(BytesError.UUIDDecodingError<BytesError.BufferSizeError>.invalidUUIDByteSequence != .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.UUIDDecodingError<BytesError.BufferSizeError>.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) != .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 2)))
    }
    
    @Test func uuidDecodingBufferSizeError() {
        #expect(BytesError.UUIDDecodingError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.UUIDDecodingError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.UUIDDecodingError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != BytesError.UUIDDecodingError<BytesError.BufferSizeError>.invalidUUIDByteSequence)
        
        #expect(BytesError.UUIDDecoding.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)))
        #expect(BytesError.UUIDDecoding.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .invalidUUIDByteSequence)
    }
    
    @Test func uuidDecodingContiguousBytesError() {
        #expect(BytesError.UUIDDecodingError.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.UUIDDecodingError.contiguousBytesUnavailable(type: "A") == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.UUIDDecodingError.contiguousBytesUnavailable(type: "A") != .invalidUUIDByteSequence)
        
        #expect(BytesError.UUIDDecoding.ContiguousBytesError<Never>.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.UUIDDecoding.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.UUIDDecoding.ContiguousBytesError<Never>.contiguousBytesUnavailable(type: "A") != .invalidUUIDByteSequence)
    }
    
    @Test func uuidDecodingContiguousBytesBufferSizeError() {
        #expect(BytesError.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1)) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) == .castingFailure(.castingFailure(.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1))))
        #expect(BytesError.UUIDDecoding.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 0, targetType: "A", actualSize: 1) != .invalidUUIDByteSequence)
        
        #expect(BytesError.UUIDDecoding.ContiguousBytes.BufferSizeError.castingFailure(.contiguousBytesUnavailable(type: "A")) == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.UUIDDecoding.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") == .castingFailure(.contiguousBytesUnavailable(type: "A")))
        #expect(BytesError.UUIDDecoding.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "A") != .invalidUUIDByteSequence)
    }
}
