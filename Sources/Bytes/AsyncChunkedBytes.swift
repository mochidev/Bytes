//
//  AsyncChunkedBytes.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 2021-11-18.
//  Copyright © 2020-2021 Mochi Development, Inc. All rights reserved.
//

#if compiler(>=5.5) && canImport(_Concurrency)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncSequence where Element == Byte {
    /// Creates an asynchronous sequence that splits the receiving sequence into chunks of uniform size.
    ///
    /// In this example, an asynchronous sequence of Strings encodes sentences by prefixing each word sequence with a number.
    /// The number indicates how many words will be read and concatenated into a complete sentence.
    ///
    /// The closure provided to the `iteratorMap(_:)` first reads the first available string, interpreting it as a number.
    /// Then, it will loop the specified number of times, accumulating those words into an array, that is finally assembled into a sentence.
    ///
    ///     // url.resourceBytes is 3542 bytes
    ///     let chunkedSequence = url.resourceBytes.chuncked(1024)
    ///
    ///     for await chunk in chunkedSequence {
    ///         print("Chunk: \(chunk.count) bytes")
    ///     }
    ///     // Prints: "Chunk: 1024 bytes", "Chunk: 1024 bytes", "Chunk: 1024 bytes", "Chunk: 470 bytes"
    ///
    /// - Parameter capacity: The capacity of a single chunk.
    /// - Returns: An asynchronous sequence that contains, in order, `[UInt8]` arrays of size `capacity`. The last entry will contain the remaining bytes.
    @inlinable
    public func chuncked(_ capacity: Int) -> AsyncChunkedBytes<Self> {
        AsyncChunkedBytes(self, capacity: capacity)
    }
}

/// An asynchronous sequence that splits the base sequence into chunks of uniform size.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public struct AsyncChunkedBytes<Base: AsyncSequence> where Base.Element == Byte {
    @usableFromInline
    let base: Base
    
    @usableFromInline
    let capacity: Int
    
    @usableFromInline
    init(
        _ base: Base,
        capacity: Int
    ) {
        precondition(capacity >= 0, "capacity must be larger than 0")
        self.base = base
        self.capacity = capacity
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension AsyncChunkedBytes: AsyncSequence {
    /// The type of element produced by this asynchronous sequence.
    ///
    /// AsyncChunkedBytes produces arrays of bytes, or `[UInt8]`.
    public typealias Element = Bytes
    
    /// The iterator that produces elements of the chunked sequence.
    public struct AsyncIterator: AsyncIteratorProtocol {
        @usableFromInline
        var baseIterator: Base.AsyncIterator
        @usableFromInline
        let capacity: Int
        
        @usableFromInline
        init(
            _ baseIterator: Base.AsyncIterator,
            capacity: Int
        ) {
            self.baseIterator = baseIterator
            self.capacity = capacity
        }
        
        /// Produces the next element in the chunked sequence.
        ///
        /// This iterator buffers bytes up to `capacity`, then returnes then as a single chunk.
        @inlinable
        public mutating func next() async rethrows -> Bytes? {
            try await baseIterator.nextIfPresent(Bytes.self, max: capacity)
        }
    }
    
    @inlinable
    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(base.makeAsyncIterator(), capacity: capacity)
    }
}

#endif
