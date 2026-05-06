// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

//
//  Package.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 2020-11-07.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

import PackageDescription

let package = Package(
    name: "Bytes",
    products: [
        .library(
            name: "Bytes",
            targets: ["Bytes"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Bytes",
            dependencies: []
        ),
        .testTarget(
            name: "BytesTests",
            dependencies: ["Bytes"]
        ),
    ]
)
