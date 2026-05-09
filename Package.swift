// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

//
//  Package.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 2026-05-06.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

import PackageDescription

let swiftSettings: [PackageDescription.SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("ImmutableWeakCaptures"),
]

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
            dependencies: [],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "BytesTests",
            dependencies: ["Bytes"],
            swiftSettings: swiftSettings
        ),
    ]
)
