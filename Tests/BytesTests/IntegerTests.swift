//
//  IntegerTests.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 2020-11-08.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

import Bytes
import Testing

@Suite struct IntegerTests {
    @Test func bigEndianBytesFromInteger() async throws {
        #expect(UInt8(0x00).bigEndianBytes == [0x00])
        #expect(UInt8(0x01).bigEndianBytes == [0x01])
        #expect(UInt8(0xff).bigEndianBytes == [0xff])
        
        #expect(Int8(0x00).bigEndianBytes == [0x00])
        #expect(Int8(0x01).bigEndianBytes == [0x01])
        #expect(Int8(-0x01).bigEndianBytes == [0xff])
        
        
        #expect(UInt16(0x0000).bigEndianBytes == [0x00, 0x00])
        #expect(UInt16(0x0123).bigEndianBytes == [0x01, 0x23])
        #expect(UInt16(0xffff).bigEndianBytes == [0xff, 0xff])

        #expect(Int16(0x0000).bigEndianBytes == [0x00, 0x00])
        #expect(Int16(0x0123).bigEndianBytes == [0x01, 0x23])
        #expect(Int16(-0x0123).bigEndianBytes == [0xfe, 0xdd])
        
        
        #expect(UInt32(0x0000_0000).bigEndianBytes == [0x00, 0x00, 0x00, 0x00])
        #expect(UInt32(0x0123_4567).bigEndianBytes == [0x01, 0x23, 0x45, 0x67])
        #expect(UInt32(0xffff_ffff).bigEndianBytes == [0xff, 0xff, 0xff, 0xff])

        #expect(Int32(0x0000_0000).bigEndianBytes == [0x00, 0x00, 0x00, 0x00])
        #expect(Int32(0x0123_4567).bigEndianBytes == [0x01, 0x23, 0x45, 0x67])
        #expect(Int32(-0x0123_4567).bigEndianBytes == [0xfe, 0xdc, 0xba, 0x99])
        
        
        #expect(UInt64(0x0000_0000_0000_0000).bigEndianBytes == [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        #expect(UInt64(0x0123_4567_89ab_cdef).bigEndianBytes == [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef])
        #expect(UInt64(0xffff_ffff_ffff_ffff).bigEndianBytes == [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])

        #expect(Int64(0x0000_0000_0000_0000).bigEndianBytes == [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        #expect(Int64(0x0123_4567_89ab_cdef).bigEndianBytes == [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef])
        #expect(Int64(-0x0123_4567_89ab_cdef).bigEndianBytes == [0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x11])
        
        
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(UInt128(0x0000_0000_0000_0000_0000_0000_0000_0000).bigEndianBytes == [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
            #expect(UInt128(0x0123_4567_89ab_cdef_fedc_ba98_7654_3210).bigEndianBytes == [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10])
            #expect(UInt128(0xffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff).bigEndianBytes == [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
            
            #expect(Int128(0x0000_0000_0000_0000_0000_0000_0000_0000).bigEndianBytes == [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
            #expect(Int128(0x0123_4567_89ab_cdef_fedc_ba98_7654_3210).bigEndianBytes == [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10])
            #expect(Int128(-0x0123_4567_89ab_cdef_fedc_ba98_7654_3210).bigEndianBytes == [0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10, 0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xf0])
        }
    }
    
    @Test func integerFromNonContiguousBigEndianBytes() async throws {
        #expect(try UInt8(bigEndianBytes: ([0x00] as any BytesCollection)) == 0x00)
        #expect(try UInt8(bigEndianBytes: ([0x01] as any BytesCollection)) == 0x01)
        #expect(try UInt8(bigEndianBytes: ([0xff] as any BytesCollection)) == 0xff)
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "UInt8", actualSize: 0)) {
            _ = try UInt8(bigEndianBytes: ([] as any BytesCollection))
        }
        
        #expect(try Int8(bigEndianBytes: ([0x00] as any BytesCollection)) == 0x00)
        #expect(try Int8(bigEndianBytes: ([0x01] as any BytesCollection)) == 0x01)
        #expect(try Int8(bigEndianBytes: ([0xff] as any BytesCollection)) == -0x01)
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "Int8", actualSize: 0)) {
            _ = try Int8(bigEndianBytes: ([] as any BytesCollection))
        }
        
        
        #expect(try UInt16(bigEndianBytes: ([0x00, 0x00] as any BytesCollection)) == 0x0000)
        #expect(try UInt16(bigEndianBytes: ([0x01, 0x23] as any BytesCollection)) == 0x0123)
        #expect(try UInt16(bigEndianBytes: ([0xff, 0xff] as any BytesCollection)) == 0xffff)
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "UInt16", actualSize: 0)) {
            _ = try UInt16(bigEndianBytes: ([] as any BytesCollection))
        }
        
        #expect(try Int16(bigEndianBytes: ([0x00, 0x00] as any BytesCollection)) == 0x0000)
        #expect(try Int16(bigEndianBytes: ([0x01, 0x23] as any BytesCollection)) == 0x0123)
        #expect(try Int16(bigEndianBytes: ([0xfe, 0xdd] as any BytesCollection)) == -0x0123)
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Int16", actualSize: 0)) {
            _ = try Int16(bigEndianBytes: ([] as any BytesCollection))
        }
        
        
        #expect(try UInt32(bigEndianBytes: ([0x00, 0x00, 0x00, 0x00] as any BytesCollection)) == 0x0000_0000)
        #expect(try UInt32(bigEndianBytes: ([0x01, 0x23, 0x45, 0x67] as any BytesCollection)) == 0x0123_4567)
        #expect(try UInt32(bigEndianBytes: ([0xff, 0xff, 0xff, 0xff] as any BytesCollection)) == 0xffff_ffff)
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "UInt32", actualSize: 0)) {
            _ = try UInt32(bigEndianBytes: ([] as any BytesCollection))
        }
        
        #expect(try Int32(bigEndianBytes: ([0x00, 0x00, 0x00, 0x00] as any BytesCollection)) == 0x0000_0000)
        #expect(try Int32(bigEndianBytes: ([0x01, 0x23, 0x45, 0x67] as any BytesCollection)) == 0x0123_4567)
        #expect(try Int32(bigEndianBytes: ([0xfe, 0xdc, 0xba, 0x99] as any BytesCollection)) == -0x0123_4567)
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "Int32", actualSize: 0)) {
            _ = try Int32(bigEndianBytes: ([] as any BytesCollection))
        }
        
        
        #expect(try UInt64(bigEndianBytes: ([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00] as any BytesCollection)) == 0x0000_0000_0000_0000)
        #expect(try UInt64(bigEndianBytes: ([0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef] as any BytesCollection)) == 0x0123_4567_89ab_cdef)
        #expect(try UInt64(bigEndianBytes: ([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff] as any BytesCollection)) == 0xffff_ffff_ffff_ffff)
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64", actualSize: 0)) {
            _ = try UInt64(bigEndianBytes: ([] as any BytesCollection))
        }

        #expect(try Int64(bigEndianBytes: ([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00] as any BytesCollection)) == 0x0000_0000_0000_0000)
        #expect(try Int64(bigEndianBytes: ([0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef] as any BytesCollection)) == 0x0123_4567_89ab_cdef)
        #expect(try Int64(bigEndianBytes: ([0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x11] as any BytesCollection)) == -0x0123_4567_89ab_cdef)
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "Int64", actualSize: 0)) {
            _ = try Int64(bigEndianBytes: ([] as any BytesCollection))
        }
        
        
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try UInt128(bigEndianBytes: ([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00] as any BytesCollection)) == 0x0000_0000_0000_0000_0000_0000_0000_0000)
            #expect(try UInt128(bigEndianBytes: ([0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10] as any BytesCollection)) == 0x0123_4567_89ab_cdef_fedc_ba98_7654_3210)
            #expect(try UInt128(bigEndianBytes: ([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff] as any BytesCollection)) == 0xffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff)
            #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UInt128", actualSize: 0)) {
                _ = try UInt128(bigEndianBytes: ([] as any BytesCollection))
            }
            
            #expect(try Int128(bigEndianBytes: ([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00] as any BytesCollection)) == 0x0000_0000_0000_0000_0000_0000_0000_0000)
            #expect(try Int128(bigEndianBytes: ([0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10] as any BytesCollection)) == 0x0123_4567_89ab_cdef_fedc_ba98_7654_3210)
            #expect(try Int128(bigEndianBytes: ([0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10, 0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xf0] as any BytesCollection)) == -0x0123_4567_89ab_cdef_fedc_ba98_7654_3210)
            #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "Int128", actualSize: 0)) {
                _ = try Int128(bigEndianBytes: ([] as any BytesCollection))
            }
        }
    }
    
    @Test func integerFromContiguousBigEndianBytes() async throws {
        #expect(try UInt8(bigEndianBytes: [0x00]) == 0x00)
        #expect(try UInt8(bigEndianBytes: [0x01]) == 0x01)
        #expect(try UInt8(bigEndianBytes: [0xff]) == 0xff)
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "UInt8", actualSize: 0)) {
            _ = try UInt8(bigEndianBytes: [])
        }
        
        #expect(try Int8(bigEndianBytes: [0x00]) == 0x00)
        #expect(try Int8(bigEndianBytes: [0x01]) == 0x01)
        #expect(try Int8(bigEndianBytes: [0xff]) == -0x01)
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "Int8", actualSize: 0)) {
            _ = try Int8(bigEndianBytes: [])
        }
        
        
        #expect(try UInt16(bigEndianBytes: [0x00, 0x00]) == 0x0000)
        #expect(try UInt16(bigEndianBytes: [0x01, 0x23]) == 0x0123)
        #expect(try UInt16(bigEndianBytes: [0xff, 0xff]) == 0xffff)
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "UInt16", actualSize: 0)) {
            _ = try UInt16(bigEndianBytes: [])
        }
        
        #expect(try Int16(bigEndianBytes: [0x00, 0x00]) == 0x0000)
        #expect(try Int16(bigEndianBytes: [0x01, 0x23]) == 0x0123)
        #expect(try Int16(bigEndianBytes: [0xfe, 0xdd]) == -0x0123)
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Int16", actualSize: 0)) {
            _ = try Int16(bigEndianBytes: [])
        }
        
        
        #expect(try UInt32(bigEndianBytes: [0x00, 0x00, 0x00, 0x00]) == 0x0000_0000)
        #expect(try UInt32(bigEndianBytes: [0x01, 0x23, 0x45, 0x67]) == 0x0123_4567)
        #expect(try UInt32(bigEndianBytes: [0xff, 0xff, 0xff, 0xff]) == 0xffff_ffff)
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "UInt32", actualSize: 0)) {
            _ = try UInt32(bigEndianBytes: [])
        }
        
        #expect(try Int32(bigEndianBytes: [0x00, 0x00, 0x00, 0x00]) == 0x0000_0000)
        #expect(try Int32(bigEndianBytes: [0x01, 0x23, 0x45, 0x67]) == 0x0123_4567)
        #expect(try Int32(bigEndianBytes: [0xfe, 0xdc, 0xba, 0x99]) == -0x0123_4567)
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "Int32", actualSize: 0)) {
            _ = try Int32(bigEndianBytes: [])
        }
        
        
        #expect(try UInt64(bigEndianBytes: [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]) == 0x0000_0000_0000_0000)
        #expect(try UInt64(bigEndianBytes: [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef]) == 0x0123_4567_89ab_cdef)
        #expect(try UInt64(bigEndianBytes: [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]) == 0xffff_ffff_ffff_ffff)
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64", actualSize: 0)) {
            _ = try UInt64(bigEndianBytes: [])
        }

        #expect(try Int64(bigEndianBytes: [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]) == 0x0000_0000_0000_0000)
        #expect(try Int64(bigEndianBytes: [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef]) == 0x0123_4567_89ab_cdef)
        #expect(try Int64(bigEndianBytes: [0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x11]) == -0x0123_4567_89ab_cdef)
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "Int64", actualSize: 0)) {
            _ = try Int64(bigEndianBytes: [])
        }
        
        
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try UInt128(bigEndianBytes: [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]) == 0x0000_0000_0000_0000_0000_0000_0000_0000)
            #expect(try UInt128(bigEndianBytes: [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10]) == 0x0123_4567_89ab_cdef_fedc_ba98_7654_3210)
            #expect(try UInt128(bigEndianBytes: [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]) == 0xffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff)
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UInt128", actualSize: 0)) {
                _ = try UInt128(bigEndianBytes: [])
            }
            
            #expect(try Int128(bigEndianBytes: [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]) == 0x0000_0000_0000_0000_0000_0000_0000_0000)
            #expect(try Int128(bigEndianBytes: [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10]) == 0x0123_4567_89ab_cdef_fedc_ba98_7654_3210)
            #expect(try Int128(bigEndianBytes: [0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10, 0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xf0]) == -0x0123_4567_89ab_cdef_fedc_ba98_7654_3210)
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "Int128", actualSize: 0)) {
                _ = try Int128(bigEndianBytes: [])
            }
        }
    }
    
    @Test func littleEndianBytesFromInteger() async throws {
        #expect(UInt8(0x00).littleEndianBytes == [0x00])
        #expect(UInt8(0x01).littleEndianBytes == [0x01])
        #expect(UInt8(0xff).littleEndianBytes == [0xff])
        
        #expect(Int8(0x00).littleEndianBytes == [0x00])
        #expect(Int8(0x01).littleEndianBytes == [0x01])
        #expect(Int8(-0x01).littleEndianBytes == [0xff])
        
        
        #expect(UInt16(0x0000).littleEndianBytes == [0x00, 0x00])
        #expect(UInt16(0x0123).littleEndianBytes == [0x23, 0x01])
        #expect(UInt16(0xffff).littleEndianBytes == [0xff, 0xff])

        #expect(Int16(0x0000).littleEndianBytes == [0x00, 0x00])
        #expect(Int16(0x0123).littleEndianBytes == [0x23, 0x01])
        #expect(Int16(-0x0123).littleEndianBytes == [0xdd, 0xfe])
        
        
        #expect(UInt32(0x0000_0000).littleEndianBytes == [0x00, 0x00, 0x00, 0x00])
        #expect(UInt32(0x0123_4567).littleEndianBytes == [0x67, 0x45, 0x23, 0x01])
        #expect(UInt32(0xffff_ffff).littleEndianBytes == [0xff, 0xff, 0xff, 0xff])

        #expect(Int32(0x0000_0000).littleEndianBytes == [0x00, 0x00, 0x00, 0x00])
        #expect(Int32(0x0123_4567).littleEndianBytes == [0x67, 0x45, 0x23, 0x01])
        #expect(Int32(-0x0123_4567).littleEndianBytes == [0x99, 0xba, 0xdc, 0xfe])
        
        
        #expect(UInt64(0x0000_0000_0000_0000).littleEndianBytes == [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        #expect(UInt64(0x0123_4567_89ab_cdef).littleEndianBytes == [0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01])
        #expect(UInt64(0xffff_ffff_ffff_ffff).littleEndianBytes == [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])

        #expect(Int64(0x0000_0000_0000_0000).littleEndianBytes == [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        #expect(Int64(0x0123_4567_89ab_cdef).littleEndianBytes == [0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01])
        #expect(Int64(-0x0123_4567_89ab_cdef).littleEndianBytes == [0x11, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe])
        
        
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(UInt128(0x0000_0000_0000_0000_0000_0000_0000_0000).littleEndianBytes == [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
            #expect(UInt128(0x0123_4567_89ab_cdef_fedc_ba98_7654_3210).littleEndianBytes == [0x10, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe, 0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01])
            #expect(UInt128(0xffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff).littleEndianBytes == [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
            
            #expect(Int128(0x0000_0000_0000_0000_0000_0000_0000_0000).littleEndianBytes ==  [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
            #expect(Int128(0x0123_4567_89ab_cdef_fedc_ba98_7654_3210).littleEndianBytes ==  [0x10, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe, 0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01])
            #expect(Int128(-0x0123_4567_89ab_cdef_fedc_ba98_7654_3210).littleEndianBytes == [0xf0, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01, 0x10, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe])
        }
    }
    
    @Test func integerFromNonContiguousLittleEndianBytes() async throws {
        #expect(try UInt8(littleEndianBytes: ([0x00] as any BytesCollection)) == 0x00)
        #expect(try UInt8(littleEndianBytes: ([0x01] as any BytesCollection)) == 0x01)
        #expect(try UInt8(littleEndianBytes: ([0xff] as any BytesCollection)) == 0xff)
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "UInt8", actualSize: 0)) {
            _ = try UInt8(littleEndianBytes: ([] as any BytesCollection))
        }
        
        #expect(try Int8(littleEndianBytes: ([0x00] as any BytesCollection)) == 0x00)
        #expect(try Int8(littleEndianBytes: ([0x01] as any BytesCollection)) == 0x01)
        #expect(try Int8(littleEndianBytes: ([0xff] as any BytesCollection)) == -0x01)
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "Int8", actualSize: 0)) {
            _ = try Int8(littleEndianBytes: ([] as any BytesCollection))
        }
        
        
        #expect(try UInt16(littleEndianBytes: ([0x00, 0x00] as any BytesCollection)) == 0x0000)
        #expect(try UInt16(littleEndianBytes: ([0x23, 0x01] as any BytesCollection)) == 0x0123)
        #expect(try UInt16(littleEndianBytes: ([0xff, 0xff] as any BytesCollection)) == 0xffff)
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "UInt16", actualSize: 0)) {
            _ = try UInt16(littleEndianBytes: ([] as any BytesCollection))
        }
        
        #expect(try Int16(littleEndianBytes: ([0x00, 0x00] as any BytesCollection)) == 0x0000)
        #expect(try Int16(littleEndianBytes: ([0x23, 0x01] as any BytesCollection)) == 0x0123)
        #expect(try Int16(littleEndianBytes: ([0xdd, 0xfe] as any BytesCollection)) == -0x0123)
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Int16", actualSize: 0)) {
            _ = try Int16(littleEndianBytes: ([] as any BytesCollection))
        }
        
        
        #expect(try UInt32(littleEndianBytes: ([0x00, 0x00, 0x00, 0x00] as any BytesCollection)) == 0x0000_0000)
        #expect(try UInt32(littleEndianBytes: ([0x67, 0x45, 0x23, 0x01] as any BytesCollection)) == 0x0123_4567)
        #expect(try UInt32(littleEndianBytes: ([0xff, 0xff, 0xff, 0xff] as any BytesCollection)) == 0xffff_ffff)
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "UInt32", actualSize: 0)) {
            _ = try UInt32(littleEndianBytes: ([] as any BytesCollection))
        }
        
        #expect(try Int32(littleEndianBytes: ([0x00, 0x00, 0x00, 0x00] as any BytesCollection)) == 0x0000_0000)
        #expect(try Int32(littleEndianBytes: ([0x67, 0x45, 0x23, 0x01] as any BytesCollection)) == 0x0123_4567)
        #expect(try Int32(littleEndianBytes: ([0x99, 0xba, 0xdc, 0xfe] as any BytesCollection)) == -0x0123_4567)
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "Int32", actualSize: 0)) {
            _ = try Int32(littleEndianBytes: ([] as any BytesCollection))
        }
        
        
        #expect(try UInt64(littleEndianBytes: ([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00] as any BytesCollection)) == 0x0000_0000_0000_0000)
        #expect(try UInt64(littleEndianBytes: ([0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01] as any BytesCollection)) == 0x0123_4567_89ab_cdef)
        #expect(try UInt64(littleEndianBytes: ([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff] as any BytesCollection)) == 0xffff_ffff_ffff_ffff)
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64", actualSize: 0)) {
            _ = try UInt64(littleEndianBytes: ([] as any BytesCollection))
        }

        #expect(try Int64(littleEndianBytes: ([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00] as any BytesCollection)) == 0x0000_0000_0000_0000)
        #expect(try Int64(littleEndianBytes: ([0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01] as any BytesCollection)) == 0x0123_4567_89ab_cdef)
        #expect(try Int64(littleEndianBytes: ([0x11, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe] as any BytesCollection)) == -0x0123_4567_89ab_cdef)
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "Int64", actualSize: 0)) {
            _ = try Int64(littleEndianBytes: ([] as any BytesCollection))
        }
        
        
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try UInt128(littleEndianBytes: ([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00] as any BytesCollection)) == 0x0000_0000_0000_0000_0000_0000_0000_0000)
            #expect(try UInt128(littleEndianBytes: ([0x10, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe, 0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01] as any BytesCollection)) == 0x0123_4567_89ab_cdef_fedc_ba98_7654_3210)
            #expect(try UInt128(littleEndianBytes: ([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff] as any BytesCollection)) == 0xffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff)
            #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UInt128", actualSize: 0)) {
                _ = try UInt128(littleEndianBytes: ([] as any BytesCollection))
            }
            
            #expect(try Int128(littleEndianBytes: ([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00] as any BytesCollection)) == 0x0000_0000_0000_0000_0000_0000_0000_0000)
            #expect(try Int128(littleEndianBytes: ([0x10, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe, 0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01] as any BytesCollection)) == 0x0123_4567_89ab_cdef_fedc_ba98_7654_3210)
            #expect(try Int128(littleEndianBytes: ([0xf0, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01, 0x10, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe] as any BytesCollection)) == -0x0123_4567_89ab_cdef_fedc_ba98_7654_3210)
            #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "Int128", actualSize: 0)) {
                _ = try Int128(littleEndianBytes: ([] as any BytesCollection))
            }
        }
    }
    
    @Test func integerFromContiguousLittleEndianBytes() async throws {
        #expect(try UInt8(littleEndianBytes: [0x00]) == 0x00)
        #expect(try UInt8(littleEndianBytes: [0x01]) == 0x01)
        #expect(try UInt8(littleEndianBytes: [0xff]) == 0xff)
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "UInt8", actualSize: 0)) {
            _ = try UInt8(littleEndianBytes: [])
        }
        
        #expect(try Int8(littleEndianBytes: [0x00]) == 0x00)
        #expect(try Int8(littleEndianBytes: [0x01]) == 0x01)
        #expect(try Int8(littleEndianBytes: [0xff]) == -0x01)
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 1, targetType: "Int8", actualSize: 0)) {
            _ = try Int8(littleEndianBytes: [])
        }
        
        
        #expect(try UInt16(littleEndianBytes: [0x00, 0x00]) == 0x0000)
        #expect(try UInt16(littleEndianBytes: [0x23, 0x01]) == 0x0123)
        #expect(try UInt16(littleEndianBytes: [0xff, 0xff]) == 0xffff)
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "UInt16", actualSize: 0)) {
            _ = try UInt16(littleEndianBytes: [])
        }
        
        #expect(try Int16(littleEndianBytes: [0x00, 0x00]) == 0x0000)
        #expect(try Int16(littleEndianBytes: [0x23, 0x01]) == 0x0123)
        #expect(try Int16(littleEndianBytes: [0xdd, 0xfe]) == -0x0123)
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 2, targetType: "Int16", actualSize: 0)) {
            _ = try Int16(littleEndianBytes: [])
        }
        
        
        #expect(try UInt32(littleEndianBytes: [0x00, 0x00, 0x00, 0x00]) == 0x0000_0000)
        #expect(try UInt32(littleEndianBytes: [0x67, 0x45, 0x23, 0x01]) == 0x0123_4567)
        #expect(try UInt32(littleEndianBytes: [0xff, 0xff, 0xff, 0xff]) == 0xffff_ffff)
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "UInt32", actualSize: 0)) {
            _ = try UInt32(littleEndianBytes: [])
        }
        
        #expect(try Int32(littleEndianBytes: [0x00, 0x00, 0x00, 0x00]) == 0x0000_0000)
        #expect(try Int32(littleEndianBytes: [0x67, 0x45, 0x23, 0x01]) == 0x0123_4567)
        #expect(try Int32(littleEndianBytes: [0x99, 0xba, 0xdc, 0xfe]) == -0x0123_4567)
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 4, targetType: "Int32", actualSize: 0)) {
            _ = try Int32(littleEndianBytes: [])
        }
        
        
        #expect(try UInt64(littleEndianBytes: [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]) == 0x0000_0000_0000_0000)
        #expect(try UInt64(littleEndianBytes: [0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01]) == 0x0123_4567_89ab_cdef)
        #expect(try UInt64(littleEndianBytes: [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]) == 0xffff_ffff_ffff_ffff)
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64", actualSize: 0)) {
            _ = try UInt64(littleEndianBytes: [])
        }

        #expect(try Int64(littleEndianBytes: [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]) == 0x0000_0000_0000_0000)
        #expect(try Int64(littleEndianBytes: [0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01]) == 0x0123_4567_89ab_cdef)
        #expect(try Int64(littleEndianBytes: [0x11, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe]) == -0x0123_4567_89ab_cdef)
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "Int64", actualSize: 0)) {
            _ = try Int64(littleEndianBytes: [])
        }
        
        
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try UInt128(littleEndianBytes: [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]) == 0x0000_0000_0000_0000_0000_0000_0000_0000)
            #expect(try UInt128(littleEndianBytes: [0x10, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe, 0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01]) == 0x0123_4567_89ab_cdef_fedc_ba98_7654_3210)
            #expect(try UInt128(littleEndianBytes: [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]) == 0xffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff)
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UInt128", actualSize: 0)) {
                _ = try UInt128(littleEndianBytes: [])
            }
            
            #expect(try Int128(littleEndianBytes: [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]) == 0x0000_0000_0000_0000_0000_0000_0000_0000)
            #expect(try Int128(littleEndianBytes: [0x10, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe, 0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01]) == 0x0123_4567_89ab_cdef_fedc_ba98_7654_3210)
            #expect(try Int128(littleEndianBytes: [0xf0, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01, 0x10, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe]) == -0x0123_4567_89ab_cdef_fedc_ba98_7654_3210)
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "Int128", actualSize: 0)) {
                _ = try Int128(littleEndianBytes: [])
            }
        }
    }
    
    @Test func bytesFromIntegerCollection() async throws {
        let integers: [UInt16] = [0x0001, 0x0010, 0x0100, 0x1000]
        #expect(integers.bigEndianBytes == [0x00,0x01,0x00,0x10,0x01,0x00,0x10,0x00])
        #expect(integers.littleEndianBytes == [0x01,0x00,0x10,0x00,0x00,0x01,0x00,0x10])
    }
    
    @Test func integerCollectionFromNonContiguousBigEndianBytes() async throws {
        let bytes: any BytesCollection = [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10, 0x00, 0x11, 0x10, 0x11, 0x01, 0x10, 0x11, 0x01, 0x11]
        #expect(try [UInt8](bigEndianBytes: bytes) == [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10, 0x00, 0x11, 0x10, 0x11, 0x01, 0x10, 0x11, 0x01, 0x11])
        #expect(try [UInt16](bigEndianBytes: bytes) == [0x0001, 0x0010, 0x0100, 0x1000, 0x1110, 0x1101, 0x1011, 0x0111])
        #expect(try [UInt32](bigEndianBytes: bytes) == [0x0001_0010, 0x0100_1000, 0x1110_1101, 0x1011_0111])
        #expect(try [UInt64](bigEndianBytes: bytes) == [0x0001_0010_0100_1000, 0x1110_1101_1011_0111])
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try [UInt128](bigEndianBytes: bytes) == [0x0001_0010_0100_1000_1110_1101_1011_0111])
        }
        
        let emptyBytes: any BytesCollection = []
        #expect(try [UInt8](bigEndianBytes: emptyBytes) == [])
        #expect(try [UInt16](bigEndianBytes: emptyBytes) == [])
        #expect(try [UInt32](bigEndianBytes: emptyBytes) == [])
        #expect(try [UInt64](bigEndianBytes: emptyBytes) == [])
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try [UInt128](bigEndianBytes: emptyBytes) == [])
        }
        
        let invalidBytes: any BytesCollection = [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10]
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt16<4>", actualSize: 7)) {
            try [UInt16](bigEndianBytes: invalidBytes)
        }
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt32<2>", actualSize: 7)) {
            try [UInt32](bigEndianBytes: invalidBytes)
        }
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64<1>", actualSize: 7)) {
            try [UInt64](bigEndianBytes: invalidBytes)
        }
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UInt128<1>", actualSize: 7)) {
                try [UInt128](bigEndianBytes: invalidBytes)
            }
        }
    }
    
    @Test func integerCollectionFromContiguousBigEndianBytes() async throws {
        let bytes: Bytes = [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10, 0x00, 0x11, 0x10, 0x11, 0x01, 0x10, 0x11, 0x01, 0x11]
        #expect(try [UInt8](bigEndianBytes: bytes) == [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10, 0x00, 0x11, 0x10, 0x11, 0x01, 0x10, 0x11, 0x01, 0x11])
        #expect(try [UInt16](bigEndianBytes: bytes) == [0x0001, 0x0010, 0x0100, 0x1000, 0x1110, 0x1101, 0x1011, 0x0111])
        #expect(try [UInt32](bigEndianBytes: bytes) == [0x0001_0010, 0x0100_1000, 0x1110_1101, 0x1011_0111])
        #expect(try [UInt64](bigEndianBytes: bytes) == [0x0001_0010_0100_1000, 0x1110_1101_1011_0111])
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try [UInt128](bigEndianBytes: bytes) == [0x0001_0010_0100_1000_1110_1101_1011_0111])
        }
        
        let emptyBytes: Bytes = []
        #expect(try [UInt8](bigEndianBytes: emptyBytes) == [])
        #expect(try [UInt16](bigEndianBytes: emptyBytes) == [])
        #expect(try [UInt32](bigEndianBytes: emptyBytes) == [])
        #expect(try [UInt64](bigEndianBytes: emptyBytes) == [])
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try [UInt128](bigEndianBytes: emptyBytes) == [])
        }
        
        let invalidBytes: Bytes = [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10]
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt16<4>", actualSize: 7)) {
            try [UInt16](bigEndianBytes: invalidBytes)
        }
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt32<2>", actualSize: 7)) {
            try [UInt32](bigEndianBytes: invalidBytes)
        }
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64<1>", actualSize: 7)) {
            try [UInt64](bigEndianBytes: invalidBytes)
        }
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UInt128<1>", actualSize: 7)) {
                try [UInt128](bigEndianBytes: invalidBytes)
            }
        }
    }
    
    @Test func integerSetFromNonContiguousBigEndianBytes() async throws {
        let bytes: any BytesCollection = [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10, 0x00, 0x11, 0x10, 0x11, 0x01, 0x10, 0x11, 0x01, 0x11]
        #expect(try Set<UInt8>(bigEndianBytes: bytes) == [0x00, 0x01, 0x10, 0x11])
        #expect(try Set<UInt16>(bigEndianBytes: bytes) == [0x0001, 0x0010, 0x0100, 0x1000, 0x1110, 0x1101, 0x1011, 0x0111])
        #expect(try Set<UInt32>(bigEndianBytes: bytes) == [0x0001_0010, 0x0100_1000, 0x1110_1101, 0x1011_0111])
        #expect(try Set<UInt64>(bigEndianBytes: bytes) == [0x0001_0010_0100_1000, 0x1110_1101_1011_0111])
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try Set<UInt128>(bigEndianBytes: bytes) == [0x0001_0010_0100_1000_1110_1101_1011_0111])
        }
        
        let emptyBytes: any BytesCollection = []
        #expect(try Set<UInt8>(bigEndianBytes: emptyBytes) == [])
        #expect(try Set<UInt16>(bigEndianBytes: emptyBytes) == [])
        #expect(try Set<UInt32>(bigEndianBytes: emptyBytes) == [])
        #expect(try Set<UInt64>(bigEndianBytes: emptyBytes) == [])
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try Set<UInt128>(bigEndianBytes: emptyBytes) == [])
        }
        
        let invalidBytes: any BytesCollection = [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10]
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt16<4>", actualSize: 7)) {
            try Set<UInt16>(bigEndianBytes: invalidBytes)
        }
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt32<2>", actualSize: 7)) {
            try Set<UInt32>(bigEndianBytes: invalidBytes)
        }
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64<1>", actualSize: 7)) {
            try Set<UInt64>(bigEndianBytes: invalidBytes)
        }
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UInt128<1>", actualSize: 7)) {
                try Set<UInt128>(bigEndianBytes: invalidBytes)
            }
        }
    }
    
    @Test func integerSetFromContiguousBigEndianBytes() async throws {
        let bytes: Bytes = [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10, 0x00, 0x11, 0x10, 0x11, 0x01, 0x10, 0x11, 0x01, 0x11]
        #expect(try Set<UInt8>(bigEndianBytes: bytes) == [0x00, 0x01, 0x10, 0x11])
        #expect(try Set<UInt16>(bigEndianBytes: bytes) == [0x0001, 0x0010, 0x0100, 0x1000, 0x1110, 0x1101, 0x1011, 0x0111])
        #expect(try Set<UInt32>(bigEndianBytes: bytes) == [0x0001_0010, 0x0100_1000, 0x1110_1101, 0x1011_0111])
        #expect(try Set<UInt64>(bigEndianBytes: bytes) == [0x0001_0010_0100_1000, 0x1110_1101_1011_0111])
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try Set<UInt128>(bigEndianBytes: bytes) == [0x0001_0010_0100_1000_1110_1101_1011_0111])
        }
        
        let emptyBytes: Bytes = []
        #expect(try Set<UInt8>(bigEndianBytes: emptyBytes) == [])
        #expect(try Set<UInt16>(bigEndianBytes: emptyBytes) == [])
        #expect(try Set<UInt32>(bigEndianBytes: emptyBytes) == [])
        #expect(try Set<UInt64>(bigEndianBytes: emptyBytes) == [])
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try Set<UInt128>(bigEndianBytes: emptyBytes) == [])
        }
        
        let invalidBytes: Bytes = [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10]
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt16<4>", actualSize: 7)) {
            try Set<UInt16>(bigEndianBytes: invalidBytes)
        }
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt32<2>", actualSize: 7)) {
            try Set<UInt32>(bigEndianBytes: invalidBytes)
        }
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64<1>", actualSize: 7)) {
            try Set<UInt64>(bigEndianBytes: invalidBytes)
        }
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UInt128<1>", actualSize: 7)) {
                try Set<UInt128>(bigEndianBytes: invalidBytes)
            }
        }
    }
    
    @Test func integerCollectionFromNonContiguousLittleEndianBytes() async throws {
        let bytes: any BytesCollection = [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10, 0x00, 0x11, 0x10, 0x11, 0x01, 0x10, 0x11, 0x01, 0x11]
        #expect(try [UInt8](littleEndianBytes: bytes) == [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10, 0x00, 0x11, 0x10, 0x11, 0x01, 0x10, 0x11, 0x01, 0x11])
        #expect(try [UInt16](littleEndianBytes: bytes) == [0x0100, 0x1000, 0x0001, 0x0010, 0x1011, 0x0111, 0x1110, 0x1101])
        #expect(try [UInt32](littleEndianBytes: bytes) == [0x1000_0100, 0x0010_0001, 0x0111_1011, 0x1101_1110])
        #expect(try [UInt64](littleEndianBytes: bytes) == [0x0010_0001_1000_0100, 0x1101_1110_0111_1011])
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try [UInt128](littleEndianBytes: bytes) == [0x1101_1110_0111_1011_0010_0001_1000_0100])
        }
        
        let emptyBytes: any BytesCollection = []
        #expect(try [UInt8](littleEndianBytes: emptyBytes) == [])
        #expect(try [UInt16](littleEndianBytes: emptyBytes) == [])
        #expect(try [UInt32](littleEndianBytes: emptyBytes) == [])
        #expect(try [UInt64](littleEndianBytes: emptyBytes) == [])
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try [UInt128](littleEndianBytes: emptyBytes) == [])
        }
        
        let invalidBytes: any BytesCollection = [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10]
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt16<4>", actualSize: 7)) {
            try [UInt16](littleEndianBytes: invalidBytes)
        }
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt32<2>", actualSize: 7)) {
            try [UInt32](littleEndianBytes: invalidBytes)
        }
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64<1>", actualSize: 7)) {
            try [UInt64](littleEndianBytes: invalidBytes)
        }
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UInt128<1>", actualSize: 7)) {
                try [UInt128](littleEndianBytes: invalidBytes)
            }
        }
    }
    
    @Test func integerCollectionFromContiguousLittleEndianBytes() async throws {
        let bytes: Bytes = [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10, 0x00, 0x11, 0x10, 0x11, 0x01, 0x10, 0x11, 0x01, 0x11]
        #expect(try [UInt8](littleEndianBytes: bytes) == [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10, 0x00, 0x11, 0x10, 0x11, 0x01, 0x10, 0x11, 0x01, 0x11])
        #expect(try [UInt16](littleEndianBytes: bytes) == [0x0100, 0x1000, 0x0001, 0x0010, 0x1011, 0x0111, 0x1110, 0x1101])
        #expect(try [UInt32](littleEndianBytes: bytes) == [0x1000_0100, 0x0010_0001, 0x0111_1011, 0x1101_1110])
        #expect(try [UInt64](littleEndianBytes: bytes) == [0x0010_0001_1000_0100, 0x1101_1110_0111_1011])
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try [UInt128](littleEndianBytes: bytes) == [0x1101_1110_0111_1011_0010_0001_1000_0100])
        }
        
        let emptyBytes: Bytes = []
        #expect(try [UInt8](littleEndianBytes: emptyBytes) == [])
        #expect(try [UInt16](littleEndianBytes: emptyBytes) == [])
        #expect(try [UInt32](littleEndianBytes: emptyBytes) == [])
        #expect(try [UInt64](littleEndianBytes: emptyBytes) == [])
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try [UInt128](littleEndianBytes: emptyBytes) == [])
        }
        
        let invalidBytes: Bytes = [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10]
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt16<4>", actualSize: 7)) {
            try [UInt16](littleEndianBytes: invalidBytes)
        }
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt32<2>", actualSize: 7)) {
            try [UInt32](littleEndianBytes: invalidBytes)
        }
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64<1>", actualSize: 7)) {
            try [UInt64](littleEndianBytes: invalidBytes)
        }
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UInt128<1>", actualSize: 7)) {
                try [UInt128](littleEndianBytes: invalidBytes)
            }
        }
    }
    
    @Test func integerSetFromNonContiguousLittleEndianBytes() async throws {
        let bytes: any BytesCollection = [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10, 0x00, 0x11, 0x10, 0x11, 0x01, 0x10, 0x11, 0x01, 0x11]
        #expect(try Set<UInt8>(littleEndianBytes: bytes) == [0x00, 0x01, 0x10, 0x11])
        #expect(try Set<UInt16>(littleEndianBytes: bytes) == [0x0001, 0x0010, 0x0100, 0x1000, 0x1110, 0x1101, 0x1011, 0x0111])
        #expect(try Set<UInt32>(littleEndianBytes: bytes) == [0x1000_0100, 0x0010_0001, 0x0111_1011, 0x1101_1110])
        #expect(try Set<UInt64>(littleEndianBytes: bytes) == [0x0010_0001_1000_0100, 0x1101_1110_0111_1011])
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try Set<UInt128>(littleEndianBytes: bytes) == [0x1101_1110_0111_1011_0010_0001_1000_0100])
        }
        
        let emptyBytes: any BytesCollection = []
        #expect(try Set<UInt8>(littleEndianBytes: emptyBytes) == [])
        #expect(try Set<UInt16>(littleEndianBytes: emptyBytes) == [])
        #expect(try Set<UInt32>(littleEndianBytes: emptyBytes) == [])
        #expect(try Set<UInt64>(littleEndianBytes: emptyBytes) == [])
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try Set<UInt128>(littleEndianBytes: emptyBytes) == [])
        }
        
        let invalidBytes: any BytesCollection = [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10]
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt16<4>", actualSize: 7)) {
            try Set<UInt16>(littleEndianBytes: invalidBytes)
        }
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt32<2>", actualSize: 7)) {
            try Set<UInt32>(littleEndianBytes: invalidBytes)
        }
        #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64<1>", actualSize: 7)) {
            try Set<UInt64>(littleEndianBytes: invalidBytes)
        }
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(throws: BytesError.ContiguousBytes.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UInt128<1>", actualSize: 7)) {
                try Set<UInt128>(littleEndianBytes: invalidBytes)
            }
        }
    }
    
    @Test func integerSetFromContiguousLittleEndianBytes() async throws {
        let bytes: Bytes = [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10, 0x00, 0x11, 0x10, 0x11, 0x01, 0x10, 0x11, 0x01, 0x11]
        #expect(try Set<UInt8>(littleEndianBytes: bytes) == [0x00, 0x01, 0x10, 0x11])
        #expect(try Set<UInt16>(littleEndianBytes: bytes) == [0x0001, 0x0010, 0x0100, 0x1000, 0x1110, 0x1101, 0x1011, 0x0111])
        #expect(try Set<UInt32>(littleEndianBytes: bytes) == [0x1000_0100, 0x0010_0001, 0x0111_1011, 0x1101_1110])
        #expect(try Set<UInt64>(littleEndianBytes: bytes) == [0x0010_0001_1000_0100, 0x1101_1110_0111_1011])
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try Set<UInt128>(littleEndianBytes: bytes) == [0x1101_1110_0111_1011_0010_0001_1000_0100])
        }
        
        let emptyBytes: Bytes = []
        #expect(try Set<UInt8>(littleEndianBytes: emptyBytes) == [])
        #expect(try Set<UInt16>(littleEndianBytes: emptyBytes) == [])
        #expect(try Set<UInt32>(littleEndianBytes: emptyBytes) == [])
        #expect(try Set<UInt64>(littleEndianBytes: emptyBytes) == [])
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(try Set<UInt128>(littleEndianBytes: emptyBytes) == [])
        }
        
        let invalidBytes: Bytes = [0x00, 0x01, 0x00, 0x10, 0x01, 0x00, 0x10]
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt16<4>", actualSize: 7)) {
            try Set<UInt16>(littleEndianBytes: invalidBytes)
        }
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt32<2>", actualSize: 7)) {
            try Set<UInt32>(littleEndianBytes: invalidBytes)
        }
        #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64<1>", actualSize: 7)) {
            try Set<UInt64>(littleEndianBytes: invalidBytes)
        }
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 16, targetType: "UInt128<1>", actualSize: 7)) {
                try Set<UInt128>(littleEndianBytes: invalidBytes)
            }
        }
    }
    
    @Suite struct IntegerByteIteratorTests {
        let bytes: Bytes = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
        
        @Test func nextLittleEndian() async throws {
            var iterator = bytes.makeIterator()
            #expect(try iterator.next(littleEndian: UInt8.self) == 0x00)
            #expect(try iterator.next(littleEndian: UInt16.self) == 0x0201)
            #expect(try iterator.next(littleEndian: UInt32.self) == 0x0605_0403)
            
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64", actualSize: 1)) {
                try iterator.next(littleEndian: UInt64.self)
            }
        }
        
        @Test func nextBigEndian() async throws {
            var iterator = bytes.makeIterator()
            #expect(try iterator.next(bigEndian: UInt8.self) == 0x00)
            #expect(try iterator.next(bigEndian: UInt16.self) == 0x0102)
            #expect(try iterator.next(bigEndian: UInt32.self) == 0x0304_0506)
            
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64", actualSize: 1)) {
                try iterator.next(bigEndian: UInt64.self)
            }
        }
        
        @Test func nextIfPresentLittleEndian() async throws {
            var iterator = bytes.makeIterator()
            #expect(try iterator.nextIfPresent(littleEndian: UInt8.self) == 0x00)
            #expect(try iterator.nextIfPresent(littleEndian: UInt16.self) == 0x0201)
            #expect(try iterator.nextIfPresent(littleEndian: UInt32.self) == 0x0605_0403)
            
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64", actualSize: 1)) {
                try iterator.nextIfPresent(littleEndian: UInt64.self)
            }
            
            #expect(try iterator.nextIfPresent(littleEndian: UInt64.self) == nil)
        }
        
        @Test func nextIfPresentBigEndian() async throws {
            var iterator = bytes.makeIterator()
            #expect(try iterator.nextIfPresent(bigEndian: UInt8.self) == 0x00)
            #expect(try iterator.nextIfPresent(bigEndian: UInt16.self) == 0x0102)
            #expect(try iterator.nextIfPresent(bigEndian: UInt32.self) == 0x0304_0506)
            
            #expect(throws: BytesError.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64", actualSize: 1)) {
                try iterator.nextIfPresent(bigEndian: UInt64.self)
            }
            
            #expect(try iterator.nextIfPresent(bigEndian: UInt64.self) == nil)
        }
        
        @Test func checkLittleEndian() async throws {
            var iterator = bytes.makeIterator()
            try iterator.check(littleEndian: UInt8(0x00))
            try iterator.check(littleEndian: UInt16(0x0201))
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(littleEndian: UInt16(0xff03))
            }
            
            try iterator.check(littleEndian: UInt16(0x0605))
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(littleEndian: UInt16(0x0807))
            }
        }
        
        @Test func checkBigEndian() async throws {
            var iterator = bytes.makeIterator()
            try iterator.check(bigEndian: UInt8(0x00))
            try iterator.check(bigEndian: UInt16(0x0102))
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(bigEndian: UInt16(0x03ff))
            }
            
            try iterator.check(bigEndian: UInt16(0x0506))
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.check(bigEndian: UInt16(0x0708))
            }
        }
        
        @Test func checkIfPresentLittleEndian() async throws {
            var iterator = bytes.makeIterator()
            #expect(try iterator.checkIfPresent(littleEndian: UInt8(0x00)) == true)
            #expect(try iterator.checkIfPresent(littleEndian: UInt16(0x0201)) == true)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.checkIfPresent(littleEndian: UInt32(0xffff0403))
            }
            
            #expect(try iterator.checkIfPresent(littleEndian: UInt16(0x0706)) == true)
            #expect(try iterator.checkIfPresent(littleEndian: UInt16(0xffff)) == false)
        }
        
        @Test func checkIfPresentBigEndian() async throws {
            var iterator = bytes.makeIterator()
            #expect(try iterator.checkIfPresent(bigEndian: UInt8(0x00)) == true)
            #expect(try iterator.checkIfPresent(bigEndian: UInt16(0x0102)) == true)
            
            #expect(throws: BytesError.SequenceCheckError.checkedSequenceNotFound) {
                try iterator.checkIfPresent(bigEndian: UInt32(0x0304ffff))
            }
            
            #expect(try iterator.checkIfPresent(bigEndian: UInt16(0x0607)) == true)
            #expect(try iterator.checkIfPresent(bigEndian: UInt16(0xffff)) == false)
        }
    }
    
    #if canImport(Darwin)
    @Suite struct IntegerLegacyAsyncByteIteratorTests {
        @Test func nextLittleEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.next(littleEndian: UInt8.self) == 0x00)
            #expect(try await iterator.next(littleEndian: UInt16.self) == 0x0201)
            #expect(try await iterator.next(littleEndian: UInt32.self) == 0x0605_0403)
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64", actualSize: 1)) {
                try await iterator.next(littleEndian: UInt64.self)
            }
        }
        
        @Test func nextLittleEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.next(littleEndian: UInt8.self) == 0x00)
            #expect(try await iterator.next(littleEndian: UInt16.self) == 0x0201)
            #expect(try await iterator.next(littleEndian: UInt32.self) == 0x0605_0403)
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(littleEndian: UInt64.self)
            }
        }
        
        @Test func nextBigEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.next(bigEndian: UInt8.self) == 0x00)
            #expect(try await iterator.next(bigEndian: UInt16.self) == 0x0102)
            #expect(try await iterator.next(bigEndian: UInt32.self) == 0x0304_0506)
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64", actualSize: 1)) {
                try await iterator.next(bigEndian: UInt64.self)
            }
        }
        
        @Test func nextBigEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.next(bigEndian: UInt8.self) == 0x00)
            #expect(try await iterator.next(bigEndian: UInt16.self) == 0x0102)
            #expect(try await iterator.next(bigEndian: UInt32.self) == 0x0304_0506)
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(bigEndian: UInt64.self)
            }
        }
        
        @Test func nextIfPresentLittleEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.nextIfPresent(littleEndian: UInt8.self) == 0x00)
            #expect(try await iterator.nextIfPresent(littleEndian: UInt16.self) == 0x0201)
            #expect(try await iterator.nextIfPresent(littleEndian: UInt32.self) == 0x0605_0403)
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64", actualSize: 1)) {
                try await iterator.nextIfPresent(littleEndian: UInt64.self)
            }
            
            #expect(try await iterator.nextIfPresent(littleEndian: UInt64.self) == nil)
        }
        
        @Test func nextIfPresentLittleEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.nextIfPresent(littleEndian: UInt8.self) == 0x00)
            #expect(try await iterator.nextIfPresent(littleEndian: UInt16.self) == 0x0201)
            #expect(try await iterator.nextIfPresent(littleEndian: UInt32.self) == 0x0605_0403)
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(littleEndian: UInt64.self)
            }
            
            #expect(try await iterator.nextIfPresent(littleEndian: UInt64.self) == nil)
        }
        
        @Test func nextIfPresentBigEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.nextIfPresent(bigEndian: UInt8.self) == 0x00)
            #expect(try await iterator.nextIfPresent(bigEndian: UInt16.self) == 0x0102)
            #expect(try await iterator.nextIfPresent(bigEndian: UInt32.self) == 0x0304_0506)
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64", actualSize: 1)) {
                try await iterator.nextIfPresent(bigEndian: UInt64.self)
            }
            
            #expect(try await iterator.nextIfPresent(bigEndian: UInt64.self) == nil)
        }
        
        @Test func nextIfPresentBigEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.nextIfPresent(bigEndian: UInt8.self) == 0x00)
            #expect(try await iterator.nextIfPresent(bigEndian: UInt16.self) == 0x0102)
            #expect(try await iterator.nextIfPresent(bigEndian: UInt32.self) == 0x0304_0506)
            
            await #expect(throws: BytesError.Iteration<any Error>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(bigEndian: UInt64.self)
            }
            
            #expect(try await iterator.nextIfPresent(bigEndian: UInt64.self) == nil)
        }
        
        @Test func checkLittleEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            try await iterator.check(littleEndian: UInt8(0x00))
            try await iterator.check(littleEndian: UInt16(0x0201))
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(littleEndian: UInt16(0xff03))
            }
            
            try await iterator.check(littleEndian: UInt16(0x0605))
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(littleEndian: UInt16(0x0807))
            }
        }
        
        @Test func checkLittleEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            try await iterator.check(littleEndian: UInt8(0x00))
            try await iterator.check(littleEndian: UInt16(0x0201))
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(littleEndian: UInt16(0xff03))
            }
            
            try await iterator.check(littleEndian: UInt16(0x0605))
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(littleEndian: UInt16(0x0807))
            }
        }
        
        @Test func checkBigEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            try await iterator.check(bigEndian: UInt8(0x00))
            try await iterator.check(bigEndian: UInt16(0x0102))
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(bigEndian: UInt16(0x03ff))
            }
            
            try await iterator.check(bigEndian: UInt16(0x0506))
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(bigEndian: UInt16(0x0708))
            }
        }
        
        @Test func checkBigEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            try await iterator.check(bigEndian: UInt8(0x00))
            try await iterator.check(bigEndian: UInt16(0x0102))
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(bigEndian: UInt16(0x03ff))
            }
            
            try await iterator.check(bigEndian: UInt16(0x0506))
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(bigEndian: UInt16(0x0708))
            }
        }
        
        @Test func checkIfPresentLittleEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.checkIfPresent(littleEndian: UInt8(0x00)) == true)
            #expect(try await iterator.checkIfPresent(littleEndian: UInt16(0x0201)) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(littleEndian: UInt32(0xffff0403))
            }
            
            #expect(try await iterator.checkIfPresent(littleEndian: UInt16(0x0706)) == true)
            #expect(try await iterator.checkIfPresent(littleEndian: UInt16(0xffff)) == false)
        }
        
        @Test func checkIfPresentLittleEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.checkIfPresent(littleEndian: UInt8(0x00)) == true)
            #expect(try await iterator.checkIfPresent(littleEndian: UInt16(0x0201)) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(littleEndian: UInt32(0xffff0403))
            }
            
            #expect(try await iterator.checkIfPresent(littleEndian: UInt16(0x0706)) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(littleEndian: UInt16(0xffff))
            }
            
            #expect(try await iterator.checkIfPresent(littleEndian: UInt16(0xffff)) == false)
        }
        
        @Test func checkIfPresentBigEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.checkIfPresent(bigEndian: UInt8(0x00)) == true)
            #expect(try await iterator.checkIfPresent(bigEndian: UInt16(0x0102)) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(bigEndian: UInt32(0x0304ffff))
            }
            
            #expect(try await iterator.checkIfPresent(bigEndian: UInt16(0x0607)) == true)
            #expect(try await iterator.checkIfPresent(bigEndian: UInt16(0xffff)) == false)
        }
        
        @Test func checkIfPresentBigEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.checkIfPresent(bigEndian: UInt8(0x00)) == true)
            #expect(try await iterator.checkIfPresent(bigEndian: UInt16(0x0102)) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(bigEndian: UInt32(0x0304ffff))
            }
            
            #expect(try await iterator.checkIfPresent(bigEndian: UInt16(0x0607)) == true)
            
            await #expect(throws: BytesError.Iteration<any Error>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(bigEndian: UInt16(0xffff))
            }
            
            #expect(try await iterator.checkIfPresent(bigEndian: UInt16(0xffff)) == false)
        }
    }
    #endif
    
    @Suite struct IntegerAsyncByteIteratorTests {
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextLittleEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.next(littleEndian: UInt8.self) == 0x00)
            #expect(try await iterator.next(littleEndian: UInt16.self) == 0x0201)
            #expect(try await iterator.next(littleEndian: UInt32.self) == 0x0605_0403)
            
            await #expect(throws: BytesError.Iteration<Never>.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64", actualSize: 1)) {
                try await iterator.next(littleEndian: UInt64.self)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextLittleEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.next(littleEndian: UInt8.self) == 0x00)
            #expect(try await iterator.next(littleEndian: UInt16.self) == 0x0201)
            #expect(try await iterator.next(littleEndian: UInt32.self) == 0x0605_0403)
            
            await #expect(throws: BytesError.Iteration<LocalError>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(littleEndian: UInt64.self)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextBigEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.next(bigEndian: UInt8.self) == 0x00)
            #expect(try await iterator.next(bigEndian: UInt16.self) == 0x0102)
            #expect(try await iterator.next(bigEndian: UInt32.self) == 0x0304_0506)
            
            await #expect(throws: BytesError.Iteration<Never>.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64", actualSize: 1)) {
                try await iterator.next(bigEndian: UInt64.self)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextBigEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.next(bigEndian: UInt8.self) == 0x00)
            #expect(try await iterator.next(bigEndian: UInt16.self) == 0x0102)
            #expect(try await iterator.next(bigEndian: UInt32.self) == 0x0304_0506)
            
            await #expect(throws: BytesError.Iteration<LocalError>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.next(bigEndian: UInt64.self)
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentLittleEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.nextIfPresent(littleEndian: UInt8.self) == 0x00)
            #expect(try await iterator.nextIfPresent(littleEndian: UInt16.self) == 0x0201)
            #expect(try await iterator.nextIfPresent(littleEndian: UInt32.self) == 0x0605_0403)
            
            await #expect(throws: BytesError.Iteration<Never>.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64", actualSize: 1)) {
                try await iterator.nextIfPresent(littleEndian: UInt64.self)
            }
            
            #expect(try await iterator.nextIfPresent(littleEndian: UInt64.self) == nil)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentLittleEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.nextIfPresent(littleEndian: UInt8.self) == 0x00)
            #expect(try await iterator.nextIfPresent(littleEndian: UInt16.self) == 0x0201)
            #expect(try await iterator.nextIfPresent(littleEndian: UInt32.self) == 0x0605_0403)
            
            await #expect(throws: BytesError.Iteration<LocalError>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(littleEndian: UInt64.self)
            }
            
            #expect(try await iterator.nextIfPresent(littleEndian: UInt64.self) == nil)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentBigEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.nextIfPresent(bigEndian: UInt8.self) == 0x00)
            #expect(try await iterator.nextIfPresent(bigEndian: UInt16.self) == 0x0102)
            #expect(try await iterator.nextIfPresent(bigEndian: UInt32.self) == 0x0304_0506)
            
            await #expect(throws: BytesError.Iteration<Never>.BufferSizeError.invalidBufferSize(targetSize: 8, targetType: "UInt64", actualSize: 1)) {
                try await iterator.nextIfPresent(bigEndian: UInt64.self)
            }
            
            #expect(try await iterator.nextIfPresent(bigEndian: UInt64.self) == nil)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func nextIfPresentBigEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.nextIfPresent(bigEndian: UInt8.self) == 0x00)
            #expect(try await iterator.nextIfPresent(bigEndian: UInt16.self) == 0x0102)
            #expect(try await iterator.nextIfPresent(bigEndian: UInt32.self) == 0x0304_0506)
            
            await #expect(throws: BytesError.Iteration<LocalError>.BufferSizeError.iterationFailure(LocalError())) {
                try await iterator.nextIfPresent(bigEndian: UInt64.self)
            }
            
            #expect(try await iterator.nextIfPresent(bigEndian: UInt64.self) == nil)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkLittleEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            try await iterator.check(littleEndian: UInt8(0x00))
            try await iterator.check(littleEndian: UInt16(0x0201))
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(littleEndian: UInt16(0xff03))
            }
            
            try await iterator.check(littleEndian: UInt16(0x0605))
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(littleEndian: UInt16(0x0807))
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkLittleEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            try await iterator.check(littleEndian: UInt8(0x00))
            try await iterator.check(littleEndian: UInt16(0x0201))
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(littleEndian: UInt16(0xff03))
            }
            
            try await iterator.check(littleEndian: UInt16(0x0605))
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(littleEndian: UInt16(0x0807))
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkBigEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            try await iterator.check(bigEndian: UInt8(0x00))
            try await iterator.check(bigEndian: UInt16(0x0102))
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(bigEndian: UInt16(0x03ff))
            }
            
            try await iterator.check(bigEndian: UInt16(0x0506))
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(bigEndian: UInt16(0x0708))
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkBigEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            try await iterator.check(bigEndian: UInt8(0x00))
            try await iterator.check(bigEndian: UInt16(0x0102))
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.check(bigEndian: UInt16(0x03ff))
            }
            
            try await iterator.check(bigEndian: UInt16(0x0506))
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.check(bigEndian: UInt16(0x0708))
            }
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentLittleEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.checkIfPresent(littleEndian: UInt8(0x00)) == true)
            #expect(try await iterator.checkIfPresent(littleEndian: UInt16(0x0201)) == true)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(littleEndian: UInt32(0xffff0403))
            }
            
            #expect(try await iterator.checkIfPresent(littleEndian: UInt16(0x0706)) == true)
            #expect(try await iterator.checkIfPresent(littleEndian: UInt16(0xffff)) == false)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentLittleEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.checkIfPresent(littleEndian: UInt8(0x00)) == true)
            #expect(try await iterator.checkIfPresent(littleEndian: UInt16(0x0201)) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(littleEndian: UInt32(0xffff0403))
            }
            
            #expect(try await iterator.checkIfPresent(littleEndian: UInt16(0x0706)) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(littleEndian: UInt16(0xffff))
            }
            
            #expect(try await iterator.checkIfPresent(littleEndian: UInt16(0xffff)) == false)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentBigEndian() async throws {
            var iterator = AsyncTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.checkIfPresent(bigEndian: UInt8(0x00)) == true)
            #expect(try await iterator.checkIfPresent(bigEndian: UInt16(0x0102)) == true)
            
            await #expect(throws: BytesError.Iteration<Never>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(bigEndian: UInt32(0x0304ffff))
            }
            
            #expect(try await iterator.checkIfPresent(bigEndian: UInt16(0x0607)) == true)
            #expect(try await iterator.checkIfPresent(bigEndian: UInt16(0xffff)) == false)
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        @Test func checkIfPresentBigEndianThrows() async throws {
            var iterator = AsyncThrowingTestIterator([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
            #expect(try await iterator.checkIfPresent(bigEndian: UInt8(0x00)) == true)
            #expect(try await iterator.checkIfPresent(bigEndian: UInt16(0x0102)) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.checkedSequenceNotFound) {
                try await iterator.checkIfPresent(bigEndian: UInt32(0x0304ffff))
            }
            
            #expect(try await iterator.checkIfPresent(bigEndian: UInt16(0x0607)) == true)
            
            await #expect(throws: BytesError.Iteration<LocalError>.SequenceCheckError.iterationFailure(LocalError())) {
                try await iterator.checkIfPresent(bigEndian: UInt32(0x0304ffff))
            }
            
            #expect(try await iterator.checkIfPresent(bigEndian: UInt16(0xffff)) == false)
        }
    }
}
