//
//  RawRepresentableTests.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 2020-11-08.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

import Bytes
import Testing

enum RawEnum: RawRepresentable {
    init?(rawValue: Byte4) {
        switch rawValue.a {
        case 0:     self = .a
        case 1:     self = .b
        case 2:     self = .c
        default:    return nil
        }
    }
    
    var rawValue: Byte4 {
        switch self {
        case .a: Byte4(a: 0, b: 0, c: 0, d: 0)
        case .b: Byte4(a: 1, b: 0, c: 0, d: 0)
        case .c: Byte4(a: 2, b: 0, c: 0, d: 0)
        }
    }
    
    typealias RawValue = Byte4
    
    case a, b, c
}

enum BigRawEnum: RawRepresentable {
    init?(rawValue: BigType) {
        switch rawValue.a {
        case 0:     self = .a
        case 1:     self = .b
        case 2:     self = .c
        default:    return nil
        }
    }
    
    var rawValue: BigType {
        switch self {
        case .a: BigType(a: 0, b: .zero)
        case .b: BigType(a: 1, b: .zero)
        case .c: BigType(a: 2, b: .zero)
        }
    }
    
    typealias RawValue = BigType
    
    struct BigType: Equatable { /// This type is 4096+1 bytes
        var a: Byte1
        var b: Byte4096
    }
    
    case a, b, c
}

enum IntEnum: UInt16 {
    case a, b, c
}

enum Int8Enum: UInt8 {
    case a, b, c
}

enum StringEnum: String {
    case a, b, c
}

enum CharacterEnum: Character {
    case a = "a", b = "b", c = "c"
}

@Suite struct RawRepresentableTests {
    @Test func rawBytesFromEnum() async throws {
        #expect(RawEnum.a.rawBytes == [0x00, 0x00, 0x00, 0x00])
        #expect(RawEnum.b.rawBytes == [0x01, 0x00, 0x00, 0x00])
        #expect(RawEnum.c.rawBytes == [0x02, 0x00, 0x00, 0x00])
    }
    
    @Test func enumFromNonContiguousRawBytes() async throws {
        #expect(try RawEnum(rawBytes: ([0x00, 0x00, 0x00, 0x00] as any BytesCollection)) == .a)
        #expect(try RawEnum(rawBytes: ([0x01, 0x00, 0x00, 0x00] as any BytesCollection)) == .b)
        #expect(try RawEnum(rawBytes: ([0x02, 0x00, 0x00, 0x00] as any BytesCollection)) == .c)
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "Byte4")) {
            try RawEnum(rawBytes: ([0x03, 0x00, 0x00, 0x00] as any BytesCollection))
        }
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "Byte4", actualSize: 2)) {
            try RawEnum(rawBytes: ([0x03, 0x00] as any BytesCollection))
        }
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "FlattenSequence<Array<Array<UInt8>>>")) {
            try BigRawEnum(rawBytes: [[0x01], Array(repeating: 0x00, count: 4096)].joined())
        }
    }
    
    @Test func enumFromContiguousRawBytes() async throws {
        #expect(try RawEnum(rawBytes: [0x00, 0x00, 0x00, 0x00]) == .a)
        #expect(try RawEnum(rawBytes: [0x01, 0x00, 0x00, 0x00]) == .b)
        #expect(try RawEnum(rawBytes: [0x02, 0x00, 0x00, 0x00]) == .c)
        
        #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "Byte4")) {
            try RawEnum(rawBytes: [0x03, 0x00, 0x00, 0x00])
        }
        
        #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "Byte4", actualSize: 2)) {
            try RawEnum(rawBytes: [0x03, 0x00])
        }
        
        #expect(try BigRawEnum(rawBytes: Array([[0x00], Array(repeating: 0x00, count: 4096)].joined())) == .a)
        #expect(try BigRawEnum(rawBytes: Array([[0x01], Array(repeating: 0x00, count: 4096)].joined())) == .b)
        #expect(try BigRawEnum(rawBytes: Array([[0x02], Array(repeating: 0x00, count: 4096)].joined())) == .c)
    }
    
    @Test func bigEndianBytesFromEnum() async throws {
        #expect(IntEnum.a.bigEndianBytes == [0x00, 0x00])
        #expect(IntEnum.b.bigEndianBytes == [0x00, 0x01])
        #expect(IntEnum.c.bigEndianBytes == [0x00, 0x02])
    }
    
    @Test func enumFromNonContiguousBigEndianBytes() async throws {
        #expect(try IntEnum(bigEndianBytes: ([0x00, 0x00] as any BytesCollection)) == .a)
        #expect(try IntEnum(bigEndianBytes: ([0x00, 0x01] as any BytesCollection)) == .b)
        #expect(try IntEnum(bigEndianBytes: ([0x00, 0x02] as any BytesCollection)) == .c)
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
            try IntEnum(bigEndianBytes: ([0x00, 0x03] as any BytesCollection))
        }
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "UInt16", actualSize: 1)) {
            try IntEnum(bigEndianBytes: ([0x03] as any BytesCollection))
        }
    }
    
    @Test func enumFromContiguousBigEndianBytes() async throws {
        #expect(try IntEnum(bigEndianBytes: [0x00, 0x00]) == .a)
        #expect(try IntEnum(bigEndianBytes: [0x00, 0x01]) == .b)
        #expect(try IntEnum(bigEndianBytes: [0x00, 0x02]) == .c)
        
        #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
            try IntEnum(bigEndianBytes: [0x00, 0x03])
        }
        
        #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "UInt16", actualSize: 1)) {
            try IntEnum(bigEndianBytes: [0x03])
        }
    }
    
    @Test func littleEndianBytesFromEnum() async throws {
        #expect(IntEnum.a.littleEndianBytes == [0x00, 0x00])
        #expect(IntEnum.b.littleEndianBytes == [0x01, 0x00])
        #expect(IntEnum.c.littleEndianBytes == [0x02, 0x00])
    }
    
    @Test func enumFromNonContiguousLittleEndianBytes() async throws {
        #expect(try IntEnum(littleEndianBytes: ([0x00, 0x00] as any BytesCollection)) == .a)
        #expect(try IntEnum(littleEndianBytes: ([0x01, 0x00] as any BytesCollection)) == .b)
        #expect(try IntEnum(littleEndianBytes: ([0x02, 0x00] as any BytesCollection)) == .c)
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
            try IntEnum(littleEndianBytes: ([0x03, 0x00] as any BytesCollection))
        }
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "UInt16", actualSize: 1)) {
            try IntEnum(littleEndianBytes: ([0x03] as any BytesCollection))
        }
    }
    
    @Test func enumFromContiguousLittleEndianBytes() async throws {
        #expect(try IntEnum(littleEndianBytes: [0x00, 0x00]) == .a)
        #expect(try IntEnum(littleEndianBytes: [0x01, 0x00]) == .b)
        #expect(try IntEnum(littleEndianBytes: [0x02, 0x00]) == .c)
        
        #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
            try IntEnum(littleEndianBytes: [0x03, 0x00])
        }
        
        #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "UInt16", actualSize: 1)) {
            try IntEnum(littleEndianBytes: [0x03])
        }
    }
    
    @Test func utf8BytesFromStringEnum() async throws {
        #expect(StringEnum.a.utf8Bytes == [0x61])
        #expect(StringEnum.b.utf8Bytes == [0x62])
        #expect(StringEnum.c.utf8Bytes == [0x63])
    }
    
    @Test func stringEnumFromUTF8Bytes() async throws {
        #expect(try StringEnum(utf8Bytes: [0x61]) == .a)
        #expect(try StringEnum(utf8Bytes: [0x62]) == .b)
        #expect(try StringEnum(utf8Bytes: [0x63]) == .c)
        
        #expect(throws: BytesError.RawRepresentableError<Never>.invalidRawRepresentableByteSequence(rawType: "String")) {
            try StringEnum(utf8Bytes: [0x64])
        }
    }
    
    @Test func utf8BytesFromCharacterEnum() async throws {
        #expect(CharacterEnum.a.utf8Bytes == [0x61])
        #expect(CharacterEnum.b.utf8Bytes == [0x62])
        #expect(CharacterEnum.c.utf8Bytes == [0x63])
    }
    
    @Test func characterEnumFromUTF8Bytes() async throws {
        #expect(try CharacterEnum(utf8Bytes: [0x61]) == .a)
        #expect(try CharacterEnum(utf8Bytes: [0x62]) == .b)
        #expect(try CharacterEnum(utf8Bytes: [0x63]) == .c)
        
        #expect(throws: BytesError.RawRepresentable.CharacterDecodingError.invalidRawRepresentableByteSequence(rawType: "Character")) {
            try CharacterEnum(utf8Bytes: [0x64])
        }
        
        #expect(throws: BytesError.RawRepresentable.CharacterDecodingError.invalidCharacterByteSequence) {
            try CharacterEnum(utf8Bytes: [])
        }
    }
    
    @Test func rawBytesFromEnumCollection() async throws {
        #expect([RawEnum.a, .b, .c].rawBytes == [0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00])
    }
    
    @Test func enumCollectionFromNonContiguousRawBytes() async throws {
        #expect(try Array<RawEnum>(rawBytes: [0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00]) == [.a, .b, .c])
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "Byte4")) {
            try Array<RawEnum>(rawBytes: [0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00])
        }
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "Byte4<2>", actualSize: 6)) {
            try Array<RawEnum>(rawBytes: [0x00, 0x00, 0x00, 0x00, 0x01, 0x00])
        }
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "Slice<FlattenSequence<Array<Array<UInt8>>>>")) {
            try Array<BigRawEnum>(rawBytes: [[0x00], Array(repeating: 0x00, count: 4096), [0x01], Array(repeating: 0x00, count: 4096)].joined())
        }
    }
    
    @Test func bigEndianBytesFromEnumCollection() async throws {
        #expect([IntEnum.a, .b, .c].bigEndianBytes == [0x00, 0x00, 0x00, 0x01, 0x00, 0x02])
    }
    
    @Test func enumCollectionFromNonContiguousBigEndianBytes() async throws {
        #expect(try Array<IntEnum>(bigEndianBytes: [0x00, 0x00, 0x00, 0x01, 0x00, 0x02]) == [.a, .b, .c])
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
            try Array<IntEnum>(bigEndianBytes: [0x00, 0x00, 0x00, 0x01, 0x00, 0x03])
        }
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "UInt16<2>", actualSize: 3)) {
            try Array<IntEnum>(bigEndianBytes: [0x00, 0x00, 0x00])
        }
    }
    
    @Test func littleEndianBytesFromEnumCollection() async throws {
        #expect([IntEnum.a, .b, .c].littleEndianBytes == [0x00, 0x00, 0x01, 0x00, 0x02, 0x00])
    }
    
    @Test func enumCollectionFromNonContiguousLittleEndianBytes() async throws {
        #expect(try Array<IntEnum>(littleEndianBytes: [0x00, 0x00, 0x01, 0x00, 0x02, 0x00]) == [.a, .b, .c])
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
            try Array<IntEnum>(littleEndianBytes: [0x00, 0x00, 0x01, 0x00, 0x03, 0x00])
        }
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "UInt16<2>", actualSize: 3)) {
            try Array<IntEnum>(littleEndianBytes: [0x00, 0x00, 0x00])
        }
    }
    
    @Test func enumSetFromNonContiguousRawBytes() async throws {
        #expect(try Set<RawEnum>(rawBytes: [0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00]) == [.a, .b, .c])
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "Byte4")) {
            try Set<RawEnum>(rawBytes: [0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00])
        }
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "Byte4<2>", actualSize: 6)) {
            try Set<RawEnum>(rawBytes: [0x00, 0x00, 0x00, 0x00, 0x01, 0x00])
        }
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "Slice<FlattenSequence<Array<Array<UInt8>>>>")) {
            try Set<BigRawEnum>(rawBytes: [[0x00], Array(repeating: 0x00, count: 4096), [0x01], Array(repeating: 0x00, count: 4096)].joined())
        }
    }
    
    @Test func enumSetFromNonContiguousBigEndianBytes() async throws {
        #expect(try Set<IntEnum>(bigEndianBytes: [0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x00, 0x00, 0x01, 0x00, 0x02]) == [.a, .b, .c])
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
            try Set<IntEnum>(bigEndianBytes: [0x00, 0x00, 0x00, 0x01, 0x00, 0x03])
        }
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "UInt16<2>", actualSize: 3)) {
            try Set<IntEnum>(bigEndianBytes: [0x00, 0x00, 0x00])
        }
    }
    
    @Test func enumSetFromNonContiguousLittleEndianBytes() async throws {
        #expect(try Set<IntEnum>(littleEndianBytes: [0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00]) == [.a, .b, .c])
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
            try Set<IntEnum>(littleEndianBytes: [0x00, 0x00, 0x01, 0x00, 0x03, 0x00])
        }
        
        #expect(throws: BytesError.RawRepresentable.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "UInt16<2>", actualSize: 3)) {
            try Set<IntEnum>(littleEndianBytes: [0x00, 0x00, 0x00])
        }
    }
    
    @Suite struct RawRepresentableByteIteratorTests {
        @Test func nextRaw() async throws {
            let bytes: Bytes = [0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00]
            var iterator = bytes.makeIterator()
            #expect(try iterator.next(raw: RawEnum.self) == .a)
            #expect(try iterator.next(raw: RawEnum.self) == .b)
            #expect(try iterator.next(raw: RawEnum.self) == .c)
            
            #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "Byte4")) {
                try iterator.next(raw: RawEnum.self)
            }
            
            #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "Bytes", actualSize: 2)) {
                try iterator.next(raw: RawEnum.self)
            }
            #expect(iterator.next() == nil)
        }
        
        @Test func nextIfPresentRaw() async throws {
            let bytes: Bytes = [0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00]
            var iterator = bytes.makeIterator()
            #expect(try iterator.nextIfPresent(raw: RawEnum.self) == .a)
            #expect(try iterator.nextIfPresent(raw: RawEnum.self) == .b)
            #expect(try iterator.nextIfPresent(raw: RawEnum.self) == .c)
            
            #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "Byte4")) {
                try iterator.nextIfPresent(raw: RawEnum.self)
            }
            
            #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "Bytes", actualSize: 2)) {
                try iterator.nextIfPresent(raw: RawEnum.self)
            }
            #expect(try iterator.nextIfPresent(raw: RawEnum.self) == nil)
        }
        
        @Test func checkRaw() async throws {
            let bytes: Bytes = [0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0x00]
            var iterator = bytes.makeIterator()
            try iterator.check(raw: RawEnum.a)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(raw: RawEnum.c)
            }
            
            try iterator.check(raw: RawEnum.c)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(raw: RawEnum.b)
            }
        }
        
        @Test func checkIfPresentRaw() async throws {
            let bytes: Bytes = [0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0x00]
            var iterator = bytes.makeIterator()
            #expect(try iterator.checkIfPresent(raw: RawEnum.a) == true)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.checkIfPresent(raw: RawEnum.c)
            }
            
            #expect(try iterator.checkIfPresent(raw: RawEnum.c) == true)
            #expect(try iterator.checkIfPresent(raw: RawEnum.b) == false)
        }
        
        @Test func nextLittleEndian() async throws {
            let bytes: Bytes = [0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x04]
            var iterator = bytes.makeIterator()
            #expect(try iterator.next(littleEndian: IntEnum.self) == .a)
            #expect(try iterator.next(littleEndian: IntEnum.self) == .b)
            #expect(try iterator.next(littleEndian: IntEnum.self) == .c)
            
            #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try iterator.next(littleEndian: IntEnum.self)
            }
            
            #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try iterator.next(littleEndian: IntEnum.self)
            }
        }
        
        @Test func nextBigEndian() async throws {
            let bytes: Bytes = [0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x04]
            var iterator = bytes.makeIterator()
            #expect(try iterator.next(bigEndian: IntEnum.self) == .a)
            #expect(try iterator.next(bigEndian: IntEnum.self) == .b)
            #expect(try iterator.next(bigEndian: IntEnum.self) == .c)
            
            #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try iterator.next(bigEndian: IntEnum.self)
            }
            
            #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try iterator.next(bigEndian: IntEnum.self)
            }
        }
        
        @Test func nextIfPresentLittleEndian() async throws {
            let bytes: Bytes = [0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x04]
            var iterator = bytes.makeIterator()
            #expect(try iterator.nextIfPresent(littleEndian: IntEnum.self) == .a)
            #expect(try iterator.nextIfPresent(littleEndian: IntEnum.self) == .b)
            #expect(try iterator.nextIfPresent(littleEndian: IntEnum.self) == .c)
            
            #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try iterator.nextIfPresent(littleEndian: IntEnum.self)
            }
            
            #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try iterator.nextIfPresent(littleEndian: IntEnum.self)
            }
            
            #expect(try iterator.nextIfPresent(littleEndian: UInt64.self) == nil)
        }
        
        @Test func nextIfPresentBigEndian() async throws {
            let bytes: Bytes = [0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x04]
            var iterator = bytes.makeIterator()
            #expect(try iterator.nextIfPresent(bigEndian: IntEnum.self) == .a)
            #expect(try iterator.nextIfPresent(bigEndian: IntEnum.self) == .b)
            #expect(try iterator.nextIfPresent(bigEndian: IntEnum.self) == .c)
            
            #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try iterator.nextIfPresent(bigEndian: IntEnum.self)
            }
            
            #expect(throws: BytesError.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try iterator.nextIfPresent(bigEndian: IntEnum.self)
            }
            
            #expect(try iterator.nextIfPresent(bigEndian: UInt64.self) == nil)
        }
        
        @Test func checkUInt8() async throws {
            let bytes: Bytes = [0x00, 0x01, 0x02, 0x03, 0x02]
            var iterator = bytes.makeIterator()
            try iterator.check(Int8Enum.a)
            try iterator.check(Int8Enum.b)
            try iterator.check(Int8Enum.c)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(Int8Enum.a)
            }
            
            try iterator.check(Int8Enum.c)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(Int8Enum.b)
            }
        }
        
        @Test func checkLittleEndian() async throws {
            let bytes: Bytes = [0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x02, 0x00]
            var iterator = bytes.makeIterator()
            try iterator.check(littleEndian: IntEnum.a)
            try iterator.check(littleEndian: IntEnum.b)
            try iterator.check(littleEndian: IntEnum.c)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(littleEndian: IntEnum.a)
            }
            
            try iterator.check(littleEndian: IntEnum.c)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(littleEndian: IntEnum.b)
            }
        }
        
        @Test func checkBigEndian() async throws {
            let bytes: Bytes = [0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x02]
            var iterator = bytes.makeIterator()
            try iterator.check(bigEndian: IntEnum.a)
            try iterator.check(bigEndian: IntEnum.b)
            try iterator.check(bigEndian: IntEnum.c)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(bigEndian: IntEnum.a)
            }
            
            try iterator.check(bigEndian: IntEnum.c)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(bigEndian: IntEnum.b)
            }
        }
        
        @Test func checkIfPresentUInt8() async throws {
            let bytes: Bytes = [0x00, 0x01, 0x02, 0x03, 0x02]
            var iterator = bytes.makeIterator()
            #expect(try iterator.checkIfPresent(Int8Enum.a) == true)
            #expect(try iterator.checkIfPresent(Int8Enum.b) == true)
            #expect(try iterator.checkIfPresent(Int8Enum.c) == true)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.checkIfPresent(Int8Enum.a)
            }
            
            #expect(try iterator.checkIfPresent(Int8Enum.c) == true)
            #expect(try iterator.checkIfPresent(Int8Enum.b) == false)
        }
        
        @Test func checkIfPresentLittleEndian() async throws {
            let bytes: Bytes = [0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x02, 0x00]
            var iterator = bytes.makeIterator()
            #expect(try iterator.checkIfPresent(littleEndian: IntEnum.a) == true)
            #expect(try iterator.checkIfPresent(littleEndian: IntEnum.b) == true)
            #expect(try iterator.checkIfPresent(littleEndian: IntEnum.c) == true)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.checkIfPresent(littleEndian: IntEnum.a)
            }
            
            #expect(try iterator.checkIfPresent(littleEndian: IntEnum.c) == true)
            #expect(try iterator.checkIfPresent(littleEndian: IntEnum.b) == false)
        }
        
        @Test func checkIfPresentBigEndian() async throws {
            let bytes: Bytes = [0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x02]
            var iterator = bytes.makeIterator()
            #expect(try iterator.checkIfPresent(bigEndian: IntEnum.a) == true)
            #expect(try iterator.checkIfPresent(bigEndian: IntEnum.b) == true)
            #expect(try iterator.checkIfPresent(bigEndian: IntEnum.c) == true)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.checkIfPresent(bigEndian: IntEnum.a)
            }
            
            #expect(try iterator.checkIfPresent(bigEndian: IntEnum.c) == true)
            #expect(try iterator.checkIfPresent(bigEndian: IntEnum.b) == false)
        }
        
        @Test func checkUTF8Character() async throws {
            let bytes: Bytes = [0x61, 0x62, 0x63, 0x64, 0x63]
            var iterator = bytes.makeIterator()
            try iterator.check(utf8: CharacterEnum.a)
            try iterator.check(utf8: CharacterEnum.b)
            try iterator.check(utf8: CharacterEnum.c)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(utf8: CharacterEnum.a)
            }
            
            try iterator.check(utf8: CharacterEnum.c)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(utf8: CharacterEnum.b)
            }
        }
        
        @Test func checkUTF8String() async throws {
            let bytes: Bytes = [0x61, 0x62, 0x63, 0x64, 0x63]
            var iterator = bytes.makeIterator()
            try iterator.check(utf8: StringEnum.a)
            try iterator.check(utf8: StringEnum.b)
            try iterator.check(utf8: StringEnum.c)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(utf8: StringEnum.a)
            }
            
            try iterator.check(utf8: StringEnum.c)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(utf8: StringEnum.b)
            }
        }
        
        @Test func checkIfPresentUTF8Character() async throws {
            let bytes: Bytes = [0x61, 0x62, 0x63, 0x64, 0x63]
            var iterator = bytes.makeIterator()
            #expect(try iterator.checkIfPresent(utf8: CharacterEnum.a) == true)
            #expect(try iterator.checkIfPresent(utf8: CharacterEnum.b) == true)
            #expect(try iterator.checkIfPresent(utf8: CharacterEnum.c) == true)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.checkIfPresent(utf8: CharacterEnum.a)
            }
            
            #expect(try iterator.checkIfPresent(utf8: CharacterEnum.c) == true)
            #expect(try iterator.checkIfPresent(utf8: CharacterEnum.b) == false)
        }
        
        @Test func checkIfPresentUTF8String() async throws {
            let bytes: Bytes = [0x61, 0x62, 0x63, 0x64, 0x63]
            var iterator = bytes.makeIterator()
            #expect(try iterator.checkIfPresent(utf8: StringEnum.a) == true)
            #expect(try iterator.checkIfPresent(utf8: StringEnum.b) == true)
            #expect(try iterator.checkIfPresent(utf8: StringEnum.c) == true)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.checkIfPresent(utf8: StringEnum.a)
            }
            
            #expect(try iterator.checkIfPresent(utf8: StringEnum.c) == true)
            #expect(try iterator.checkIfPresent(utf8: StringEnum.b) == false)
        }
    }
    
    #if canImport(Darwin)
    @Suite struct RawRepresentableLegacyAsyncByteIteratorTests {
        @Test func nextRaw() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00])
            #expect(try await iterator.next(raw: RawEnum.self) == .a)
            #expect(try await iterator.next(raw: RawEnum.self) == .b)
            #expect(try await iterator.next(raw: RawEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "Byte4")) {
                try await iterator.next(raw: RawEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "Bytes", actualSize: 2)) {
                try await iterator.next(raw: RawEnum.self)
            }
            
            #expect(await iterator.next() == nil)
        }
        
        @Test func nextRawThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00])
            #expect(try await iterator.next(raw: RawEnum.self) == .a)
            #expect(try await iterator.next(raw: RawEnum.self) == .b)
            #expect(try await iterator.next(raw: RawEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "Byte4")) {
                try await iterator.next(raw: RawEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(raw: RawEnum.self)
            }
        }
        
        @Test func nextIfPresentRaw() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00])
            #expect(try await iterator.nextIfPresent(raw: RawEnum.self) == .a)
            #expect(try await iterator.nextIfPresent(raw: RawEnum.self) == .b)
            #expect(try await iterator.nextIfPresent(raw: RawEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "Byte4")) {
                try await iterator.nextIfPresent(raw: RawEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "Bytes", actualSize: 2)) {
                try await iterator.nextIfPresent(raw: RawEnum.self)
            }
            
            #expect(try await iterator.nextIfPresent(raw: RawEnum.self) == nil)
        }
        
        @Test func nextIfPresentRawThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00])
            #expect(try await iterator.nextIfPresent(raw: RawEnum.self) == .a)
            #expect(try await iterator.nextIfPresent(raw: RawEnum.self) == .b)
            #expect(try await iterator.nextIfPresent(raw: RawEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "Byte4")) {
                try await iterator.nextIfPresent(raw: RawEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(raw: RawEnum.self)
            }
            
            #expect(try await iterator.nextIfPresent(raw: RawEnum.self) == nil)
        }
        
        @Test func checkRaw() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0x00])
            try await iterator.check(raw: RawEnum.a)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(raw: RawEnum.c)
            }
            
            try await iterator.check(raw: RawEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(raw: RawEnum.b)
            }
        }
        
        @Test func checkRawThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0x00])
            try await iterator.check(raw: RawEnum.a)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(raw: RawEnum.c)
            }
            
            try await iterator.check(raw: RawEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(raw: RawEnum.b)
            }
        }
        
        @Test func checkIfPresentRaw() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0x00])
            #expect(try await iterator.checkIfPresent(raw: RawEnum.a) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(raw: RawEnum.c)
            }
            
            #expect(try await iterator.checkIfPresent(raw: RawEnum.c) == true)
            #expect(try await iterator.checkIfPresent(raw: RawEnum.b) == false)
        }
        
        @Test func checkIfPresentRawThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0x00])
            #expect(try await iterator.checkIfPresent(raw: RawEnum.a) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(raw: RawEnum.c)
            }
            
            #expect(try await iterator.checkIfPresent(raw: RawEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(raw: RawEnum.b)
            }
            
            #expect(try await iterator.checkIfPresent(raw: RawEnum.b) == false)
        }
        
        @Test func nextLittleEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x04])
            #expect(try await iterator.next(littleEndian: IntEnum.self) == .a)
            #expect(try await iterator.next(littleEndian: IntEnum.self) == .b)
            #expect(try await iterator.next(littleEndian: IntEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try await iterator.next(littleEndian: IntEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try await iterator.next(littleEndian: IntEnum.self)
            }
        }
        
        @Test func nextLittleEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x04])
            #expect(try await iterator.next(littleEndian: IntEnum.self) == .a)
            #expect(try await iterator.next(littleEndian: IntEnum.self) == .b)
            #expect(try await iterator.next(littleEndian: IntEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try await iterator.next(littleEndian: IntEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(littleEndian: IntEnum.self)
            }
        }
        
        @Test func nextBigEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x04])
            #expect(try await iterator.next(bigEndian: IntEnum.self) == .a)
            #expect(try await iterator.next(bigEndian: IntEnum.self) == .b)
            #expect(try await iterator.next(bigEndian: IntEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try await iterator.next(bigEndian: IntEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try await iterator.next(bigEndian: IntEnum.self)
            }
        }
        
        @Test func nextBigEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x04])
            #expect(try await iterator.next(bigEndian: IntEnum.self) == .a)
            #expect(try await iterator.next(bigEndian: IntEnum.self) == .b)
            #expect(try await iterator.next(bigEndian: IntEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try await iterator.next(bigEndian: IntEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(bigEndian: IntEnum.self)
            }
        }
        
        @Test func nextIfPresentLittleEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x04])
            #expect(try await iterator.nextIfPresent(littleEndian: IntEnum.self) == .a)
            #expect(try await iterator.nextIfPresent(littleEndian: IntEnum.self) == .b)
            #expect(try await iterator.nextIfPresent(littleEndian: IntEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try await iterator.nextIfPresent(littleEndian: IntEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try await iterator.nextIfPresent(littleEndian: IntEnum.self)
            }
            
            #expect(try await iterator.nextIfPresent(littleEndian: UInt64.self) == nil)
        }
        
        @Test func nextIfPresentLittleEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x04])
            #expect(try await iterator.nextIfPresent(littleEndian: IntEnum.self) == .a)
            #expect(try await iterator.nextIfPresent(littleEndian: IntEnum.self) == .b)
            #expect(try await iterator.nextIfPresent(littleEndian: IntEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try await iterator.nextIfPresent(littleEndian: IntEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(littleEndian: IntEnum.self)
            }
            
            #expect(try await iterator.nextIfPresent(littleEndian: UInt64.self) == nil)
        }
        
        @Test func nextIfPresentBigEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x04])
            #expect(try await iterator.nextIfPresent(bigEndian: IntEnum.self) == .a)
            #expect(try await iterator.nextIfPresent(bigEndian: IntEnum.self) == .b)
            #expect(try await iterator.nextIfPresent(bigEndian: IntEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try await iterator.nextIfPresent(bigEndian: IntEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try await iterator.nextIfPresent(bigEndian: IntEnum.self)
            }
            
            #expect(try await iterator.nextIfPresent(bigEndian: UInt64.self) == nil)
        }
        
        @Test func nextIfPresentBigEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x04])
            #expect(try await iterator.nextIfPresent(bigEndian: IntEnum.self) == .a)
            #expect(try await iterator.nextIfPresent(bigEndian: IntEnum.self) == .b)
            #expect(try await iterator.nextIfPresent(bigEndian: IntEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try await iterator.nextIfPresent(bigEndian: IntEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<any Error>.RawRepresentable.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(bigEndian: IntEnum.self)
            }
            
            #expect(try await iterator.nextIfPresent(bigEndian: UInt64.self) == nil)
        }
        
        @Test func checkUInt8() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x02])
            try await iterator.check(Int8Enum.a)
            try await iterator.check(Int8Enum.b)
            try await iterator.check(Int8Enum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(Int8Enum.a)
            }
            
            try await iterator.check(Int8Enum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(Int8Enum.b)
            }
        }
        
        @Test func checkUInt8Throws() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x02])
            try await iterator.check(Int8Enum.a)
            try await iterator.check(Int8Enum.b)
            try await iterator.check(Int8Enum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(Int8Enum.a)
            }
            
            try await iterator.check(Int8Enum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(Int8Enum.b)
            }
        }
        
        @Test func checkLittleEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x02, 0x00])
            try await iterator.check(littleEndian: IntEnum.a)
            try await iterator.check(littleEndian: IntEnum.b)
            try await iterator.check(littleEndian: IntEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(littleEndian: IntEnum.a)
            }
            
            try await iterator.check(littleEndian: IntEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(littleEndian: IntEnum.b)
            }
        }
        
        @Test func checkLittleEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x02, 0x00])
            try await iterator.check(littleEndian: IntEnum.a)
            try await iterator.check(littleEndian: IntEnum.b)
            try await iterator.check(littleEndian: IntEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(littleEndian: IntEnum.a)
            }
            
            try await iterator.check(littleEndian: IntEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(littleEndian: IntEnum.b)
            }
        }
        
        @Test func checkBigEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x02])
            try await iterator.check(bigEndian: IntEnum.a)
            try await iterator.check(bigEndian: IntEnum.b)
            try await iterator.check(bigEndian: IntEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(bigEndian: IntEnum.a)
            }
            
            try await iterator.check(bigEndian: IntEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(bigEndian: IntEnum.b)
            }
        }
        
        @Test func checkBigEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x02])
            try await iterator.check(bigEndian: IntEnum.a)
            try await iterator.check(bigEndian: IntEnum.b)
            try await iterator.check(bigEndian: IntEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(bigEndian: IntEnum.a)
            }
            
            try await iterator.check(bigEndian: IntEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(bigEndian: IntEnum.b)
            }
        }
        
        @Test func checkIfPresentUInt8() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x02])
            #expect(try await iterator.checkIfPresent(Int8Enum.a) == true)
            #expect(try await iterator.checkIfPresent(Int8Enum.b) == true)
            #expect(try await iterator.checkIfPresent(Int8Enum.c) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(Int8Enum.a)
            }
            
            #expect(try await iterator.checkIfPresent(Int8Enum.c) == true)
            #expect(try await iterator.checkIfPresent(Int8Enum.b) == false)
        }
        
        @Test func checkIfPresentUInt8Throws() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x02])
            #expect(try await iterator.checkIfPresent(Int8Enum.a) == true)
            #expect(try await iterator.checkIfPresent(Int8Enum.b) == true)
            #expect(try await iterator.checkIfPresent(Int8Enum.c) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(Int8Enum.a)
            }
            
            #expect(try await iterator.checkIfPresent(Int8Enum.c) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(Int8Enum.b)
            }
            
            #expect(try await iterator.checkIfPresent(Int8Enum.b) == false)
        }
        
        @Test func checkIfPresentLittleEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x02, 0x00])
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.a) == true)
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.b) == true)
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(littleEndian: IntEnum.a)
            }
            
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.c) == true)
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.b) == false)
        }
        
        @Test func checkIfPresentLittleEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x02, 0x00])
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.a) == true)
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.b) == true)
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(littleEndian: IntEnum.a)
            }
            
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(littleEndian: IntEnum.b)
            }
            
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.b) == false)
        }
        
        @Test func checkIfPresentBigEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x02])
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.a) == true)
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.b) == true)
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(bigEndian: IntEnum.a)
            }
            
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.c) == true)
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.b) == false)
        }
        
        @Test func checkIfPresentBigEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x02])
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.a) == true)
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.b) == true)
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(bigEndian: IntEnum.a)
            }
            
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(bigEndian: IntEnum.b)
            }
            
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.b) == false)
        }
        
        @Test func checkUTF8Character() async throws {
            var iterator = AsyncTestIterator([0x61, 0x62, 0x63, 0x64, 0x63])
            try await iterator.check(utf8: CharacterEnum.a)
            try await iterator.check(utf8: CharacterEnum.b)
            try await iterator.check(utf8: CharacterEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: CharacterEnum.a)
            }
            
            try await iterator.check(utf8: CharacterEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: CharacterEnum.b)
            }
        }
        
        @Test func checkUTF8CharacterThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x61, 0x62, 0x63, 0x64, 0x63])
            try await iterator.check(utf8: CharacterEnum.a)
            try await iterator.check(utf8: CharacterEnum.b)
            try await iterator.check(utf8: CharacterEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: CharacterEnum.a)
            }
            
            try await iterator.check(utf8: CharacterEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(utf8: CharacterEnum.b)
            }
        }
        
        @Test func checkUTF8String() async throws {
            var iterator = AsyncTestIterator([0x61, 0x62, 0x63, 0x64, 0x63])
            try await iterator.check(utf8: StringEnum.a)
            try await iterator.check(utf8: StringEnum.b)
            try await iterator.check(utf8: StringEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: StringEnum.a)
            }
            
            try await iterator.check(utf8: StringEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: StringEnum.b)
            }
        }
        
        @Test func checkUTF8StringThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x61, 0x62, 0x63, 0x64, 0x63])
            try await iterator.check(utf8: StringEnum.a)
            try await iterator.check(utf8: StringEnum.b)
            try await iterator.check(utf8: StringEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: StringEnum.a)
            }
            
            try await iterator.check(utf8: StringEnum.c)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(utf8: StringEnum.b)
            }
        }
        
        @Test func checkIfPresentUTF8Character() async throws {
            var iterator = AsyncTestIterator([0x61, 0x62, 0x63, 0x64, 0x63])
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.a) == true)
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.b) == true)
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: CharacterEnum.a)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.c) == true)
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.b) == false)
        }
        
        @Test func checkIfPresentUTF8CharacterThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x61, 0x62, 0x63, 0x64, 0x63])
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.a) == true)
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.b) == true)
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: CharacterEnum.a)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(utf8: CharacterEnum.b)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.b) == false)
        }
        
        @Test func checkIfPresentUTF8String() async throws {
            var iterator = AsyncTestIterator([0x61, 0x62, 0x63, 0x64, 0x63])
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.a) == true)
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.b) == true)
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: StringEnum.a)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.c) == true)
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.b) == false)
        }
        
        @Test func checkIfPresentUTF8StringThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x61, 0x62, 0x63, 0x64, 0x63])
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.a) == true)
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.b) == true)
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: StringEnum.a)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(utf8: StringEnum.b)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.b) == false)
        }
    }
    #endif
    
    @Suite struct RawRepresentableAsyncByteIteratorTests {
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextRaw() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00])
            #expect(try await iterator.next(raw: RawEnum.self) == .a)
            #expect(try await iterator.next(raw: RawEnum.self) == .b)
            #expect(try await iterator.next(raw: RawEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<Never>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "Byte4")) {
                try await iterator.next(raw: RawEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<Never>.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "Bytes", actualSize: 2)) {
                try await iterator.next(raw: RawEnum.self)
            }
            
            #expect(await iterator.next() == nil)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextRawThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00])
            #expect(try await iterator.next(raw: RawEnum.self) == .a)
            #expect(try await iterator.next(raw: RawEnum.self) == .b)
            #expect(try await iterator.next(raw: RawEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "Byte4")) {
                try await iterator.next(raw: RawEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<LocalError>.RawRepresentable.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(raw: RawEnum.self)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentRaw() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00])
            #expect(try await iterator.nextIfPresent(raw: RawEnum.self) == .a)
            #expect(try await iterator.nextIfPresent(raw: RawEnum.self) == .b)
            #expect(try await iterator.nextIfPresent(raw: RawEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<Never>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "Byte4")) {
                try await iterator.nextIfPresent(raw: RawEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<Never>.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "Bytes", actualSize: 2)) {
                try await iterator.nextIfPresent(raw: RawEnum.self)
            }
            
            #expect(try await iterator.nextIfPresent(raw: RawEnum.self) == nil)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentRawThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00])
            #expect(try await iterator.nextIfPresent(raw: RawEnum.self) == .a)
            #expect(try await iterator.nextIfPresent(raw: RawEnum.self) == .b)
            #expect(try await iterator.nextIfPresent(raw: RawEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "Byte4")) {
                try await iterator.nextIfPresent(raw: RawEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<LocalError>.RawRepresentable.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(raw: RawEnum.self)
            }
            
            #expect(try await iterator.nextIfPresent(raw: RawEnum.self) == nil)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkRaw() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0x00])
            try await iterator.check(raw: RawEnum.a)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(raw: RawEnum.c)
            }
            
            try await iterator.check(raw: RawEnum.c)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(raw: RawEnum.b)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkRawThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0x00])
            try await iterator.check(raw: RawEnum.a)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(raw: RawEnum.c)
            }
            
            try await iterator.check(raw: RawEnum.c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(raw: RawEnum.b)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentRaw() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0x00])
            #expect(try await iterator.checkIfPresent(raw: RawEnum.a) == true)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(raw: RawEnum.c)
            }
            
            #expect(try await iterator.checkIfPresent(raw: RawEnum.c) == true)
            #expect(try await iterator.checkIfPresent(raw: RawEnum.b) == false)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentRawThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x00, 0x00, 0x00])
            #expect(try await iterator.checkIfPresent(raw: RawEnum.a) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(raw: RawEnum.c)
            }
            
            #expect(try await iterator.checkIfPresent(raw: RawEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(raw: RawEnum.b)
            }
            
            #expect(try await iterator.checkIfPresent(raw: RawEnum.b) == false)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextLittleEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x04])
            #expect(try await iterator.next(littleEndian: IntEnum.self) == .a)
            #expect(try await iterator.next(littleEndian: IntEnum.self) == .b)
            #expect(try await iterator.next(littleEndian: IntEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<Never>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try await iterator.next(littleEndian: IntEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<Never>.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try await iterator.next(littleEndian: IntEnum.self)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextLittleEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x04])
            #expect(try await iterator.next(littleEndian: IntEnum.self) == .a)
            #expect(try await iterator.next(littleEndian: IntEnum.self) == .b)
            #expect(try await iterator.next(littleEndian: IntEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try await iterator.next(littleEndian: IntEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<LocalError>.RawRepresentable.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(littleEndian: IntEnum.self)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextBigEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x04])
            #expect(try await iterator.next(bigEndian: IntEnum.self) == .a)
            #expect(try await iterator.next(bigEndian: IntEnum.self) == .b)
            #expect(try await iterator.next(bigEndian: IntEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<Never>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try await iterator.next(bigEndian: IntEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<Never>.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try await iterator.next(bigEndian: IntEnum.self)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextBigEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x04])
            #expect(try await iterator.next(bigEndian: IntEnum.self) == .a)
            #expect(try await iterator.next(bigEndian: IntEnum.self) == .b)
            #expect(try await iterator.next(bigEndian: IntEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try await iterator.next(bigEndian: IntEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<LocalError>.RawRepresentable.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(bigEndian: IntEnum.self)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentLittleEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x04])
            #expect(try await iterator.nextIfPresent(littleEndian: IntEnum.self) == .a)
            #expect(try await iterator.nextIfPresent(littleEndian: IntEnum.self) == .b)
            #expect(try await iterator.nextIfPresent(littleEndian: IntEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<Never>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try await iterator.nextIfPresent(littleEndian: IntEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<Never>.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try await iterator.nextIfPresent(littleEndian: IntEnum.self)
            }
            
            #expect(try await iterator.nextIfPresent(littleEndian: UInt64.self) == nil)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentLittleEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x04])
            #expect(try await iterator.nextIfPresent(littleEndian: IntEnum.self) == .a)
            #expect(try await iterator.nextIfPresent(littleEndian: IntEnum.self) == .b)
            #expect(try await iterator.nextIfPresent(littleEndian: IntEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try await iterator.nextIfPresent(littleEndian: IntEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<LocalError>.RawRepresentable.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(littleEndian: IntEnum.self)
            }
            
            #expect(try await iterator.nextIfPresent(littleEndian: UInt64.self) == nil)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentBigEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x04])
            #expect(try await iterator.nextIfPresent(bigEndian: IntEnum.self) == .a)
            #expect(try await iterator.nextIfPresent(bigEndian: IntEnum.self) == .b)
            #expect(try await iterator.nextIfPresent(bigEndian: IntEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<Never>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try await iterator.nextIfPresent(bigEndian: IntEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<Never>.RawRepresentable.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Bytes", actualSize: 1)) {
                try await iterator.nextIfPresent(bigEndian: IntEnum.self)
            }
            
            #expect(try await iterator.nextIfPresent(bigEndian: UInt64.self) == nil)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentBigEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x04])
            #expect(try await iterator.nextIfPresent(bigEndian: IntEnum.self) == .a)
            #expect(try await iterator.nextIfPresent(bigEndian: IntEnum.self) == .b)
            #expect(try await iterator.nextIfPresent(bigEndian: IntEnum.self) == .c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.RawRepresentable.BufferSizeError.invalidRawRepresentableByteSequence(rawType: "UInt16")) {
                try await iterator.nextIfPresent(bigEndian: IntEnum.self)
            }
            
            await #expect(throws: BytesError.Iteration<LocalError>.RawRepresentable.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(bigEndian: IntEnum.self)
            }
            
            #expect(try await iterator.nextIfPresent(bigEndian: UInt64.self) == nil)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkUInt8() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x02])
            try await iterator.check(Int8Enum.a)
            try await iterator.check(Int8Enum.b)
            try await iterator.check(Int8Enum.c)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(Int8Enum.a)
            }
            
            try await iterator.check(Int8Enum.c)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(Int8Enum.b)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkUInt8Throws() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x02])
            try await iterator.check(Int8Enum.a)
            try await iterator.check(Int8Enum.b)
            try await iterator.check(Int8Enum.c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(Int8Enum.a)
            }
            
            try await iterator.check(Int8Enum.c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(Int8Enum.b)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkLittleEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x02, 0x00])
            try await iterator.check(littleEndian: IntEnum.a)
            try await iterator.check(littleEndian: IntEnum.b)
            try await iterator.check(littleEndian: IntEnum.c)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(littleEndian: IntEnum.a)
            }
            
            try await iterator.check(littleEndian: IntEnum.c)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(littleEndian: IntEnum.b)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkLittleEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x02, 0x00])
            try await iterator.check(littleEndian: IntEnum.a)
            try await iterator.check(littleEndian: IntEnum.b)
            try await iterator.check(littleEndian: IntEnum.c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(littleEndian: IntEnum.a)
            }
            
            try await iterator.check(littleEndian: IntEnum.c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(littleEndian: IntEnum.b)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkBigEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x02])
            try await iterator.check(bigEndian: IntEnum.a)
            try await iterator.check(bigEndian: IntEnum.b)
            try await iterator.check(bigEndian: IntEnum.c)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(bigEndian: IntEnum.a)
            }
            
            try await iterator.check(bigEndian: IntEnum.c)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(bigEndian: IntEnum.b)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkBigEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x02])
            try await iterator.check(bigEndian: IntEnum.a)
            try await iterator.check(bigEndian: IntEnum.b)
            try await iterator.check(bigEndian: IntEnum.c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(bigEndian: IntEnum.a)
            }
            
            try await iterator.check(bigEndian: IntEnum.c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(bigEndian: IntEnum.b)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentUInt8() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x02])
            #expect(try await iterator.checkIfPresent(Int8Enum.a) == true)
            #expect(try await iterator.checkIfPresent(Int8Enum.b) == true)
            #expect(try await iterator.checkIfPresent(Int8Enum.c) == true)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(Int8Enum.a)
            }
            
            #expect(try await iterator.checkIfPresent(Int8Enum.c) == true)
            #expect(try await iterator.checkIfPresent(Int8Enum.b) == false)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentUInt8Throws() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x02])
            #expect(try await iterator.checkIfPresent(Int8Enum.a) == true)
            #expect(try await iterator.checkIfPresent(Int8Enum.b) == true)
            #expect(try await iterator.checkIfPresent(Int8Enum.c) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(Int8Enum.a)
            }
            
            #expect(try await iterator.checkIfPresent(Int8Enum.c) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(Int8Enum.b)
            }
            
            #expect(try await iterator.checkIfPresent(Int8Enum.b) == false)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentLittleEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x02, 0x00])
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.a) == true)
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.b) == true)
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(littleEndian: IntEnum.a)
            }
            
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.c) == true)
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.b) == false)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentLittleEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x02, 0x00])
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.a) == true)
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.b) == true)
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(littleEndian: IntEnum.a)
            }
            
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(littleEndian: IntEnum.b)
            }
            
            #expect(try await iterator.checkIfPresent(littleEndian: IntEnum.b) == false)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentBigEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x02])
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.a) == true)
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.b) == true)
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(bigEndian: IntEnum.a)
            }
            
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.c) == true)
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.b) == false)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentBigEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x02])
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.a) == true)
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.b) == true)
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(bigEndian: IntEnum.a)
            }
            
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(bigEndian: IntEnum.b)
            }
            
            #expect(try await iterator.checkIfPresent(bigEndian: IntEnum.b) == false)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkUTF8Character() async throws {
            var iterator = AsyncTestIterator([0x61, 0x62, 0x63, 0x64, 0x63])
            try await iterator.check(utf8: CharacterEnum.a)
            try await iterator.check(utf8: CharacterEnum.b)
            try await iterator.check(utf8: CharacterEnum.c)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: CharacterEnum.a)
            }
            
            try await iterator.check(utf8: CharacterEnum.c)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: CharacterEnum.b)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkUTF8CharacterThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x61, 0x62, 0x63, 0x64, 0x63])
            try await iterator.check(utf8: CharacterEnum.a)
            try await iterator.check(utf8: CharacterEnum.b)
            try await iterator.check(utf8: CharacterEnum.c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: CharacterEnum.a)
            }
            
            try await iterator.check(utf8: CharacterEnum.c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(utf8: CharacterEnum.b)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkUTF8String() async throws {
            var iterator = AsyncTestIterator([0x61, 0x62, 0x63, 0x64, 0x63])
            try await iterator.check(utf8: StringEnum.a)
            try await iterator.check(utf8: StringEnum.b)
            try await iterator.check(utf8: StringEnum.c)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: StringEnum.a)
            }
            
            try await iterator.check(utf8: StringEnum.c)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: StringEnum.b)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkUTF8StringThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x61, 0x62, 0x63, 0x64, 0x63])
            try await iterator.check(utf8: StringEnum.a)
            try await iterator.check(utf8: StringEnum.b)
            try await iterator.check(utf8: StringEnum.c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(utf8: StringEnum.a)
            }
            
            try await iterator.check(utf8: StringEnum.c)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(utf8: StringEnum.b)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentUTF8Character() async throws {
            var iterator = AsyncTestIterator([0x61, 0x62, 0x63, 0x64, 0x63])
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.a) == true)
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.b) == true)
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: CharacterEnum.a)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.c) == true)
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.b) == false)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentUTF8CharacterThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x61, 0x62, 0x63, 0x64, 0x63])
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.a) == true)
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.b) == true)
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: CharacterEnum.a)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(utf8: CharacterEnum.b)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: CharacterEnum.b) == false)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentUTF8String() async throws {
            var iterator = AsyncTestIterator([0x61, 0x62, 0x63, 0x64, 0x63])
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.a) == true)
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.b) == true)
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: StringEnum.a)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.c) == true)
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.b) == false)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentUTF8StringThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x61, 0x62, 0x63, 0x64, 0x63])
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.a) == true)
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.b) == true)
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(utf8: StringEnum.a)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.c) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(utf8: StringEnum.b)
            }
            
            #expect(try await iterator.checkIfPresent(utf8: StringEnum.b) == false)
        }
    }
}
