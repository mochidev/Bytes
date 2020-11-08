//
//  LinuxMain.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 11/6/20.
//  Copyright © 2020 Mochi Development, Inc. All rights reserved.
//

import XCTest

import BytesTests

var tests = [XCTestCaseEntry]()
tests += BytesTests.allTests()
XCTMain(tests)
