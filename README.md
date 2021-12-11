# Bytes

<p align="center">
    <a href="https://swiftpackageindex.com/mochidev/Bytes">
        <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmochidev%2FBytes%2Fbadge%3Ftype%3Dswift-versions" />
    </a>
    <a href="https://swiftpackageindex.com/mochidev/Bytes">
        <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmochidev%2FBytes%2Fbadge%3Ftype%3Dplatforms" />
    </a>
    <a href="https://github.com/mochidev/Bytes/actions?query=workflow%3A%22Test+Bytes%22">
        <img src="https://github.com/mochidev/Bytes/workflows/Test%20Bytes/badge.svg" alt="Test Status" />
    </a>
</p>

`Bytes` aims to be your go-to Swift library for transforming basic types to and from buffers of bytes that can be serialized and written to the network, a file, or a database.

## Installation

Add `Bytes` as a dependency in your `Package.swift` file to start using it. Then, add `import Bytes` to any file you wish to use the library in.

Please check the [releases](https://github.com/mochidev/Bytes/releases) for recommended versions.

```swift
dependencies: [
    .package(url: "https://github.com/mochidev/Bytes.git", .upToNextMinor(from: "0.2.0")),
],
...
targets: [
    .target(
        name: "MyPackage",
        dependencies: [
            "Bytes",
        ]
    )
]
```

## What is `Bytes`?

`Bytes` is a type alias for `[UInt8]`, which means you can use them anywhere a buffer of bytes would be expected. Although extensions on `Int`, `String`, `UUID`, and even enumerations are provided, this library ultimately lets you transform any fixed-size structure to and from `Bytes`:

```swift
struct Example {
    let a: UInt8
    let b: UInt8
}

func methodThatTakesExample(_ example: Example) { ... }

let example = Example(a: 1, b: 2)

// Turn a Swift type into Bytes:
let bytes = Bytes(casting: example) // [0x01, 0x02]

// Turn Bytes into a Swift type:
let backToExample = try bytes.casting(to: Example.self) // Type is explicit
methodThatTakesExample(try bytes.casting()) // Type is inferred from context
```

### Integers

When working with integers, it is preferable to use the `bigEndianBytes`/ `littleEndianBytes` and  `init(bigEndianBytes: Bytes)`/`init(littleEndianBytes: Bytes)` integer-specific properties and initializers when possible, as they will be guaranteed to be cross platform (casting will always use the byte-order native to system memory). Integer overrides are available for all integer types: `Int8`, `UInt8`, `Int16`, `UInt16`, `Int32`, `UInt32`, `Int64`, and `UInt64`. Using `Int` and `UInt` for serialization is not recommended, as they are different sizes on different platforms. 

### Strings

To make working with Strings and Characters easy and unambiguous, `utf8Bytes` and `init(utf8Bytes: Bytes)` are available. These are _not_ `null`-terminated, though you can achieve that quite easily: `"Hello".utf8Bytes + [0]`.

### UUIDs

UUIDs support serialization in both compact byte form (`bytes` and `init(bytes: Bytes)`), and human-readable string form (`stringBytes` and `init(stringBytes: Bytes)`)

### Enums, OptionSets, and `RawRepresentable`

Enums and other types that conform to `RawRepresentable` are also supported out of the box via `rawBytes` and `init(rawBytes: Bytes)`. Types who's `RawType` is an Integer or String/Character can also use the above getters and initializers.

### Collections of Integers, UUIDs, Enums, and other Fixed-Size Types

An array or set of Integers can be serialized using `bigEndianBytes`/ `littleEndianBytes`, and initialized using `init(bigEndianBytes: Bytes)`/`init(littleEndianBytes: Bytes)`. The same can be done with collections of UUIDs and `RawRepresentable` enums by using the APIs specific to their types.

### Complex Example

Since `Bytes` is just an array, all the methods you are used to are available, including working with slices. If you are working with more complex serialization, consider the example below:

```swift
struct Versionstamp {
    let transactionCommitVersion: UInt64
    let batchNumber: UInt16
    var userData: UInt16?
    
    public init(transactionCommitVersion: UInt64, batchNumber: UInt16, userData: UInt16? = nil) {
        self.transactionCommitVersion = transactionCommitVersion
        self.batchNumber = batchNumber
        self.userData = userData
    }

    var bytes: Bytes {
        var result = Bytes()
        result.reserveCapacity(userData == nil ? 10 : 12)
        
        result.append(contentsOf: transactionCommitVersion.bigEndianBytes)
        result.append(contentsOf: batchNumber.bigEndianBytes)
        
        if let userData = userData {
            result.append(contentsOf: userData.bigEndianBytes)
        }
        
        return result
    }
    
    init<Bytes: BytesCollection>(_ bytes: Bytes?) throws {
        guard let bytes = bytes, bytes.count == 10 || bytes.count == 12 else {
            throw Error.invalidVersionstamp
        }
        
        let transactionCommitVersion = try! UInt64(bigEndianBytes: bytes[0..<8])
        let batchNumber = try! UInt16(bigEndianBytes: bytes[8..<10])
        var userData: UInt16?
        
        if bytes.count == 12 {
            userData = try! UInt16(bigEndianBytes: bytes[10..<12])
        }
        
        self.init(transactionCommitVersion: transactionCommitVersion, batchNumber: batchNumber, userData: userData)
    }
    
    /// Alternatively using the ByteIterator-class of methods, which don't require keeping track of indices since they decode objects in order.
    init<Bytes: BytesCollection>(sequence: Bytes?) throws {
        var iterator = sequence.makeIterator()
                        
        self.init(
            transactionCommitVersion: try iterator.next(bigEndian: UInt64.self),
            batchNumber: try iterator.next(bigEndian: UInt16.self),
            userData: try iterator.nextIfPresent(bigEndian: UInt16.self)
        )
        
        /// Verify we are at the end of the stream of bytes.
        guard iterator.next() == nil else {
            throw Error.invalidVersionstamp
        }
    }
}
```

### AsyncSequence

Bytes can also be used to pull data from `AsyncSequence` iterators. To learn more, please see [Integration with AsyncSequenceReader](https://github.com/mochidev/AsyncSequenceReader#integration-with-bytes).

## Contributing

Contribution is welcome! Please take a look at the issues already available, or start a new issue to discuss a new feature. Although guarantees can't be made regarding feature requests, PRs that fit within the goals of the project and that have been discussed beforehand are more than welcome!

Please make sure that all submissions have clean commit histories, are well documented, and thoroughly tested. **Please rebase your PR** before submission rather than merge in `main`. Linear histories are required, so merge commits will not be merge-able.
