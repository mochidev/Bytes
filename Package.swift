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
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Bytes",
            targets: ["Bytes"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Bytes",
            dependencies: []),
        .testTarget(
            name: "BytesTests",
            dependencies: ["Bytes"]),
    ]
)
