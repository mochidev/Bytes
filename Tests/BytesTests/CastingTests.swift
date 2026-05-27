//
//  CastingTests.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 2026-05-23.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

import Bytes
import Testing

@Suite struct CastingTests {
    @Test func instanceFromNonContiguousCasting() async throws {
        let zeroWord: any BytesCollection = [0,0,0,0]
        
        #expect(try zeroWord.casting(to: UInt32.self) == UInt32(0))
        #expect(try zeroWord.casting() as UInt32 == UInt32(0))
        
        let tooBig: any BytesCollection = [0,0,0,0,0]
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 4, targetType: "UInt32", actualSize: 5))) {
            try tooBig.casting(to: UInt32.self)
        }
        
        let tooSmall: any BytesCollection = [0,0,0]
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 4, targetType: "UInt32", actualSize: 3))) {
            try tooSmall.casting(to: UInt32.self)
        }
        
        let array1: Bytes = [0,1]
        let array2: Bytes = [0,0]
        
        let joined = [array1, array2].joined()
        let lhs = try joined.casting(to: UInt32.self)
        let rhs = try [0,1,0,0].casting(to: UInt32.self)
        #expect(lhs == rhs)

        /// Make sure non-contiguous data large than 4096 is not castable (aka performance will likely suffer beyond this point.
        struct BigType: Equatable { /// This type is 4096+1 bytes
            var a: Byte4096
            var b: Byte1
        }
        
        let bigNonContiguousArray = [Bytes(repeating: 0, count: 4096), Bytes([0])].joined()
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.contiguousBytesUnavailable(type: "FlattenSequence<Array<Array<UInt8>>>")) {
            try bigNonContiguousArray.casting(to: BigType.self)
        }
        
        let bigContiguousArray: any BytesCollection = Bytes(repeating: 0, count: 4097)
        #expect(try bigContiguousArray.casting(to: BigType.self) == BigType(a: .zero, b: .zero))
    }
    
    @Test func instanceFromExplicitContiguousCasting() async throws {
        let zeroWord: any BytesCollection = [0,0,0,0]
        
        #expect(try zeroWord.contiguousCasting(to: UInt32.self) == UInt32(0))
        #expect(try zeroWord.contiguousCasting() as UInt32 == UInt32(0))
        
        let tooBig: any BytesCollection = [0,0,0,0,0]
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "UInt32", actualSize: 5)) {
            try tooBig.contiguousCasting(to: UInt32.self)
        }
        
        let tooSmall: any BytesCollection = [0,0,0]
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "UInt32", actualSize: 3)) {
            try tooSmall.contiguousCasting(to: UInt32.self)
        }
        
        let array1: Bytes = [0,1]
        let array2: Bytes = [0,0]
        
        let joined = [array1, array2].joined()
        let lhs = try joined.contiguousCasting(to: UInt32.self)
        let rhs = try [0,1,0,0].contiguousCasting(to: UInt32.self)
        #expect(lhs == rhs)

        /// Make sure non-contiguous data large than 4096 is not castable (aka performance will likely suffer beyond this point.
        struct BigType: Equatable { /// This type is 4096+1 bytes
            var a: Byte4096
            var b: Byte1
        }
        
        let bigNonContiguousArray = [Bytes(repeating: 0, count: 4096), Bytes([0])].joined()
        #expect(try bigNonContiguousArray.contiguousCasting(to: BigType.self) == BigType(a: .zero, b: .zero))
        
        let bigContiguousArray: any BytesCollection = Bytes(repeating: 0, count: 4097)
        #expect(try bigContiguousArray.contiguousCasting(to: BigType.self) == BigType(a: .zero, b: .zero))
    }
    
    @Test func instanceFromImplicitContiguousCasting() async throws {
        let zeroWord: Bytes = [0,0,0,0]
        
        #expect(try zeroWord.casting(to: UInt32.self) == UInt32(0))
        #expect(try zeroWord.casting() as UInt32 == UInt32(0))
        
        let tooBig: Bytes = [0,0,0,0,0]
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "UInt32", actualSize: 5)) {
            try tooBig.casting(to: UInt32.self)
        }
        
        let tooSmall: Bytes = [0,0,0]
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "UInt32", actualSize: 3)) {
            try tooSmall.casting(to: UInt32.self)
        }
        
        let array1: Bytes = [0,1]
        let array2: Bytes = [0,0]
        
        let joined = Bytes([array1, array2].joined())
        let lhs = try joined.casting(to: UInt32.self)
        let rhs = try [0,1,0,0].casting(to: UInt32.self)
        #expect(lhs == rhs)

        /// Make sure non-contiguous data large than 4096 is not castable (aka performance will likely suffer beyond this point.
        struct BigType: Equatable { /// This type is 4096+1 bytes
            var a: Byte4096
            var b: Byte1
        }
        
        let bigNonContiguousArray = Bytes([Bytes(repeating: 0, count: 4096), Bytes([0])].joined())
        #expect(try bigNonContiguousArray.casting(to: BigType.self) == BigType(a: .zero, b: .zero))

        let bigContiguousArray = Bytes(repeating: 0, count: 4097)
        #expect(try bigContiguousArray.casting(to: BigType.self) == BigType(a: .zero, b: .zero))
    }
    
    @Test func instanceFromSlices() async throws {
        let bytes: Bytes = [0,1,2,3,4,5]
        let slice = bytes[1..<5]
        
        let value = UInt32(1<<24) + UInt32(2<<16) + UInt32(3<<8) + UInt32(4)
        #expect(try slice.casting(to: UInt32.self).bigEndian == value)
        
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "UInt32", actualSize: 6)) {
            try bytes[...].casting(to: UInt32.self)
        }
        
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "UInt32", actualSize: 1)) {
            try bytes[0..<1].casting(to: UInt32.self)
        }
    }
    
    @Test func bytesFromInstance() async throws {
        let value = UInt32(1<<24) + UInt32(2<<16) + UInt32(3<<8) + UInt32(4)
        #expect(Bytes(casting: value.bigEndian) == [1,2,3,4])
    }
    
    @Test func instanceArrayFromMappedBytes() async throws {
        let array: [UInt16] = [0x0001, 0x0010, 0x0100, 0x1000]
        let bytesFromArray = array.bytes { Bytes(casting: $0.bigEndian) }
        
        #expect(bytesFromArray == [0x00,0x01,0x00,0x10,0x01,0x00,0x10,0x00])
        
        let backToArray = try [UInt16](bytes: bytesFromArray) { try $0.casting(to: UInt16.self).bigEndian }
        #expect(backToArray == array)
        
        let backToTransformedArray = try [UInt32](bytes: bytesFromArray, element: UInt16.self) { UInt32(try $0.casting(to: UInt16.self).bigEndian) }
        #expect(backToTransformedArray == [0x0001, 0x0010, 0x0100, 0x1000])
        
        let backToExplicitSizeArray = try [UInt16](bytes: bytesFromArray, elementSize: 2) { try $0.casting(to: UInt16.self).bigEndian }
        #expect(backToExplicitSizeArray == [0x0001, 0x0010, 0x0100, 0x1000])
        
        #expect(throws: BytesError.Transformation<any Error>.BufferSizeError.transformationFailure(LocalError())) {
            try [UInt16](bytes: bytesFromArray) { _ in throw LocalError() }
        }
        #expect(throws: BytesError.Transformation<any Error>.BufferSizeError.transformationFailure(LocalError())) {
            try [UInt16](bytes: bytesFromArray, element: UInt32.self) { _ in throw LocalError() }
        }
        #expect(throws: BytesError.Transformation<any Error>.BufferSizeError.transformationFailure(LocalError())) {
            try [UInt16](bytes: bytesFromArray, elementSize: 2) { _ in throw LocalError() }
        }
        
        let incompleteBytes: Bytes = [0x00,0x01,0x00,0x10,0x01,0x00,0x10]
        /// Explicit thyped throw.
        #expect(throws: BytesError.Transformation<BytesError.BufferSizeError>.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 8, targetType: "UInt16<4>", actualSize: 7))) {
            try [UInt16](bytes: incompleteBytes) { (bytes) throws(BytesError.BufferSizeError) -> UInt16 in try bytes.casting(to: UInt16.self).bigEndian }
        }
        
        /// Implicit any Error checks.
        #expect(throws: BytesError.Transformation<any Error>.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 8, targetType: "UInt16<4>", actualSize: 7))) {
            try [UInt16](bytes: incompleteBytes) { try $0.casting(to: UInt16.self).bigEndian }
        }
        #expect(throws: BytesError.Transformation<any Error>.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 8, targetType: "UInt32<2>", actualSize: 7))) {
            try [UInt16](bytes: incompleteBytes, element: UInt32.self) { try $0.casting(to: UInt16.self).bigEndian }
        }
        #expect(throws: BytesError.Transformation<any Error>.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 8, targetType: "Bytes<2>", actualSize: 7))) {
            try [UInt16](bytes: incompleteBytes, elementSize: 2) { try $0.casting(to: UInt16.self).bigEndian }
        }
        
        /// Make sure transformation is never called.
        #expect(throws: BytesError.Transformation<Never>.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 8, targetType: "UInt16<4>", actualSize: 7))) {
            try [UInt16](bytes: incompleteBytes) { _ in
                Issue.record("Should never be called.")
                fatalError()
            }
        }
    }
    
    @Test func instanceSetFromMappedBytes() async throws {
        let set: Set<UInt16> = [0x0001, 0x0010, 0x0100, 0x1000]
        let bytesFromSet = set.bytes { Bytes(casting: $0.bigEndian) }
        let bytesFromAllItems = Array(set).bytes { Bytes(casting: $0.bigEndian) }
        
        #expect(bytesFromSet == bytesFromAllItems)
        let completeBytes: Bytes = [0x00,0x01,0x00,0x10,0x01,0x00,0x10,0x00]
        
        let backToSet = try Set<UInt16>(bytes: bytesFromSet) { try $0.casting(to: UInt16.self).bigEndian }
        #expect(backToSet == set)
        
        let backToTransformedSet = try Set<UInt32>(bytes: completeBytes, element: UInt16.self) { UInt32(try $0.casting(to: UInt16.self).bigEndian) }
        #expect(backToTransformedSet == [0x0001, 0x0010, 0x0100, 0x1000])
        
        let backToExplicitSizeSet = try Set<UInt16>(bytes: completeBytes, elementSize: 2) { try $0.casting(to: UInt16.self).bigEndian }
        #expect(backToExplicitSizeSet == [0x0001, 0x0010, 0x0100, 0x1000])
        
        #expect(throws: BytesError.Transformation<any Error>.BufferSizeError.transformationFailure(LocalError())) {
            try Set<UInt16>(bytes: bytesFromSet) { _ in throw LocalError() }
        }
        #expect(throws: BytesError.Transformation<any Error>.BufferSizeError.transformationFailure(LocalError())) {
            try Set<UInt16>(bytes: bytesFromSet, element: UInt32.self) { _ in throw LocalError() }
        }
        #expect(throws: BytesError.Transformation<any Error>.BufferSizeError.transformationFailure(LocalError())) {
            try Set<UInt16>(bytes: bytesFromSet, elementSize: 2) { _ in throw LocalError() }
        }
        
        let incompleteBytes: Bytes = [0x00,0x01,0x00,0x10,0x01,0x00,0x10]
        /// Explicit thyped throw.
        #expect(throws: BytesError.Transformation<BytesError.BufferSizeError>.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 8, targetType: "UInt16<4>", actualSize: 7))) {
            try Set<UInt16>(bytes: incompleteBytes) { (bytes) throws(BytesError.BufferSizeError) -> UInt16 in try bytes.casting(to: UInt16.self).bigEndian }
        }
        
        /// Implicit any Error checks.
        #expect(throws: BytesError.Transformation<any Error>.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 8, targetType: "UInt16<4>", actualSize: 7))) {
            try Set<UInt16>(bytes: incompleteBytes) { try $0.casting(to: UInt16.self).bigEndian }
        }
        #expect(throws: BytesError.Transformation<any Error>.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 8, targetType: "UInt32<2>", actualSize: 7))) {
            try Set<UInt16>(bytes: incompleteBytes, element: UInt32.self) { try $0.casting(to: UInt16.self).bigEndian }
        }
        #expect(throws: BytesError.Transformation<any Error>.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 8, targetType: "Bytes<2>", actualSize: 7))) {
            try Set<UInt16>(bytes: incompleteBytes, elementSize: 2) { try $0.casting(to: UInt16.self).bigEndian }
        }
        
        /// Make sure transformation is never called.
        #expect(throws: BytesError.Transformation<Never>.BufferSizeError.castingFailure(.invalidBufferSize(targetSize: 8, targetType: "UInt16<4>", actualSize: 7))) {
            try Set<UInt16>(bytes: incompleteBytes) { _ in
                Issue.record("Should never be called.")
                fatalError()
            }
        }
    }
}
