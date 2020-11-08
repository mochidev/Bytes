//
//  StringTests.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 11/7/20.
//  Copyright © 2020 Mochi Development, Inc. All rights reserved.
//

import XCTest
import Bytes

final class StringTests: XCTestCase {
    func testBytesToString() throws {
        let simpleStringBytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
        let simpleString = "Hello, World!"
        XCTAssertEqual(String(utf8Bytes: simpleStringBytes), simpleString)
        
        let complexStringBytes: Bytes = [240, 159, 145, 139, 240, 159, 145, 139, 240, 159, 143, 187, 240, 159, 145, 139, 240, 159, 143, 188, 240, 159, 145, 139, 240, 159, 143, 189, 240, 159, 145, 139, 240, 159, 143, 190, 240, 159, 145, 139, 240, 159, 143, 191, 44, 32, 240, 159, 140, 141, 240, 159, 140, 143, 240, 159, 140, 142]
        let complexString = "👋👋🏻👋🏼👋🏽👋🏾👋🏿, 🌍🌏🌎"
        XCTAssertEqual(String(utf8Bytes: complexStringBytes), complexString)
        
        let emptyStringBytes: Bytes = []
        let emptyString = ""
        XCTAssertEqual(String(utf8Bytes: emptyStringBytes), emptyString)
        
        let weirdStringBytes: Bytes = [0, 0, 0]
        let weirdString = "\0\0\0"
        XCTAssertEqual(String(utf8Bytes: weirdStringBytes), weirdString)
        
        let sliceBytes = simpleStringBytes[..<5]
        let sliceString = "Hello"
        XCTAssertEqual(String(utf8Bytes: sliceBytes), sliceString)
    }
    
    func testStringToBytes() throws {
        let simpleString = "Hello, World!"
        let simpleStringBytes: Bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
        XCTAssertEqual(simpleString.utf8Bytes, simpleStringBytes)
        
        let complexString = "👋👋🏻👋🏼👋🏽👋🏾👋🏿, 🌍🌏🌎"
        let complexStringBytes: Bytes = [240, 159, 145, 139, 240, 159, 145, 139, 240, 159, 143, 187, 240, 159, 145, 139, 240, 159, 143, 188, 240, 159, 145, 139, 240, 159, 143, 189, 240, 159, 145, 139, 240, 159, 143, 190, 240, 159, 145, 139, 240, 159, 143, 191, 44, 32, 240, 159, 140, 141, 240, 159, 140, 143, 240, 159, 140, 142]
        XCTAssertEqual(complexString.utf8Bytes, complexStringBytes)
        
        let emptyString = ""
        let emptyStringBytes: Bytes = []
        XCTAssertEqual(emptyString.utf8Bytes, emptyStringBytes)
        
        let weirdString = "\0\0\0"
        let weirdStringBytes: Bytes = [0, 0, 0]
        XCTAssertEqual(weirdString.utf8Bytes, weirdStringBytes)
        
        let subString = simpleString.prefix(5)
        let subStringBytes: Bytes = [72, 101, 108, 108, 111]
        XCTAssertEqual(subString.utf8Bytes, subStringBytes)
    }
    
    static var allTests = [
        ("testBytesToString", testBytesToString),
        ("testStringToBytes", testStringToBytes),
    ]
}
