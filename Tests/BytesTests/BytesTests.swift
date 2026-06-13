//
//  BytesTests.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 11/6/20.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

import Bytes
import Testing

@Suite struct IdentityTests {
    @Test func typeIdentity() async throws {
        #expect(Byte.self == UInt8.self)
        #expect(Bytes.self == Array<UInt8>.self)
        #expect(BytesSlice.self == ArraySlice<UInt8>.self)
        
        #expect(Byte.self != Int8.self)
        #expect(Bytes.self != Array<Int8>.self)
    }
    
    @Test func byteBufferSlicesAreContiguous() async throws {
        let buffer: Bytes = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
        
        let result: UInt16 = try buffer.withUnsafeBufferPointer { bufferPointer in
            try bufferPointer[2..<4].casting(to: UInt16.self).bigEndian
        }
        #expect(result == 0x0203)
    }
}
