//
//  Collection+Casting.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 11/6/20.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

extension Collection where Element == Byte {
    /// Check if a sequence of ``Bytes`` can be safely casted to an element.
    /// - Parameter target: The type of element to cast to.
    /// - Throws: ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the size of the bytes sequence is not equal to the element's size.
    @inlinable
    func canBeCasted<Element>(to target: Element.Type) throws(BytesError.BufferSizeError) {
        guard MemoryLayout<Element>.size == self.count else {
            throw .invalidBufferSize(targetSize: MemoryLayout<Element>.size, targetType: "\(Element.self)", actualSize: self.count)
        }
    }
    
    /// Cast an _entire_ ``Bytes`` sequence to the lhs's type.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the memory layout of the bytes sequence does not match the desired type.
    ///     - ``BytesError/ContiguousBytesError/contiguousBytesUnavailable(type:)-enum.case`` if contiguous memory could not be made available.
    /// - Returns: An instance represented by the ``Bytes`` sequence.
    @inlinable
    public func casting<R>(
        to target: R.Type = R.self
    ) throws(BytesError.ContiguousBytes.BufferSizeError) -> R {
        do {
            try canBeCasted(to: R.self)
        } catch {
            throw .castingFailure(error)
        }
        
        if let result = self.withContiguousStorageIfAvailable({
            UnsafeRawBufferPointer($0).loadUnaligned(as: R.self)
        }) {
            return result
        }
        
        /// If bytes is less than 4KB, then perform a copy first
        guard self.count <= 4*1024
        else { throw .contiguousBytesUnavailable(type: "\(Self.self)") }
        
        return Bytes(self).withUnsafeBytes { $0.loadUnaligned(as: R.self) }
    }
    
    /// Cast an _entire_ ``Bytes`` sequence to the lhs's type, copying buffers if needed no matter the size.
    /// - Warning: Only use this variant if you are absolutely certain the number of bytes to be copied won't have performance repercussions.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the memory layout of the bytes sequence does not match the desired type.
    /// - Returns: An instance represented by the ``Bytes`` sequence.
    @inlinable
    public func contiguousCasting<R>(
        to target: R.Type = R.self
    ) throws(BytesError.BufferSizeError) -> R {
        try canBeCasted(to: R.self)
        
        if let result = self.withContiguousStorageIfAvailable({
            UnsafeRawBufferPointer($0).loadUnaligned(as: R.self)
        }) {
            return result
        }
        
        /// Fallback to a copy if the range cannot be made contiguous.
        return Bytes(self).withUnsafeBytes { $0.loadUnaligned(as: R.self) }
    }
    
    /// Cast an _entire_ ``Bytes`` sequence to the lhs's type.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the memory layout of the bytes sequence does not match the desired type.
    /// - Returns: An instance represented by the ``Bytes`` sequence.
    @inlinable
    public func casting<R>(
        to target: R.Type = R.self
    ) throws(BytesError.BufferSizeError) -> R where Self: ContiguousBytesCollection {
        try canBeCasted(to: R.self)
        return self.withUnsafeBytes { $0.loadUnaligned(as: R.self) }
    }
    
    /// Create a new ``Bytes`` sequence from the memory occupied by the passed in value.
    /// - Parameter value: The value to cast to a sequence of bytes.
    @inlinable
    public init<T>(casting value: T) where Self: RangeReplaceableCollection {
        self = withUnsafeBytes(of: value) { Self($0) }
    }
    
    /// Check if a sequence of ``Bytes`` can be safely mapped to a collection of elements.
    /// - Parameter target: The type of element to map to.
    /// - Throws: ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the total size of the bytes sequence is not a multiple of the element's size.
    /// - Returns: `(elementSize: Int, elementCount: Int)`, to aid in building the new collection.
    @inlinable
    func canBeMapped<Element>(
        to target: Element.Type
    ) throws(BytesError.BufferSizeError) -> (elementSize: Int, elementCount: Int) {
        let elementSize = MemoryLayout<Element>.size
        let numberOfBytes = self.count
        let (elementCount, remainingElementSize) = numberOfBytes.quotientAndRemainder(dividingBy: elementSize)
        
        guard remainingElementSize == 0 else {
            throw .invalidBufferSize(targetSize: (elementCount + 1)*elementSize, targetType: "\(Element.self)<\(elementCount + 1)>", actualSize: numberOfBytes)
        }
        
        return (elementSize, elementCount)
    }
    
    /// Check if a sequence of ``Bytes`` can be safely mapped to a collection of elements of a given size.
    /// - Parameter targetSize: The size of element to map to.
    /// - Throws: ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the total size of the bytes sequence is not a multiple of the element's size.
    /// - Returns: the number of elements to aid in building the new collection.
    @inlinable
    func canBeMapped(
        to targetSize: Int
    ) throws(BytesError.BufferSizeError) -> Int {
        let numberOfBytes = self.count
        let (elementCount, remainingElementSize) = numberOfBytes.quotientAndRemainder(dividingBy: targetSize)
        
        guard remainingElementSize == 0 else {
            throw .invalidBufferSize(targetSize: (elementCount+1)*targetSize, targetType: "Bytes<\(targetSize)>", actualSize: numberOfBytes)
        }
        
        return elementCount
    }
}

extension Collection {
    /// Create a new ``Bytes`` sequence mapping each element accordingly.
    /// - Parameter transform: The transformation to perform on each element.
    /// - Returns: A ``Bytes`` sequence.
    @inlinable
    public func bytes(mapping transform: (Self.Element) -> Bytes) -> Bytes {
        bytes(for: Element.self, mapping: transform)
    }
    
    /// Create a new ``Bytes`` sequence mapping each element accordingly.
    /// - Parameters:
    ///   - target: The element that was used to encode the byte sequence.
    ///   - transform: The transformation to perform on each element.
    /// - Returns: A ``Bytes`` sequence.
    @inlinable
    public func bytes<EncodedElement>(for target: EncodedElement.Type, mapping transform: (Self.Element) -> Bytes) -> Bytes {
        var bytes = Bytes()
        bytes.reserveCapacity(self.count*MemoryLayout<EncodedElement>.size)
        for element in self {
            bytes.append(contentsOf: transform(element))
        }
        return bytes
    }
}

extension RangeReplaceableCollection {
    /// Creates a new collection from a sequence of bytes, transforming batches of bytes into the element type of the collection.
    /// - Parameters:
    ///   - bytes: The bytes to transform.
    ///   - transform: The transformation to perform on each element.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the total size of the bytes sequence is not a multiple of the element's size.
    ///     - ``BytesError/TransformationError/transformationFailure(_:)`` if the `transform` closure threw an error.
    /// - SeeAlso: ``init(bytes:element:mapping:)`` for when an element's memory layout can be used to infer the size.
    /// - SeeAlso: ``init(bytes:elementSize:mapping:)`` for when its not suitable to infer the size of an element from its memory layout.  
    @inlinable
    public init<
        Bytes: BytesCollection,
        TransformationFailure: Error
    >(
        bytes: Bytes,
        mapping transform: (Bytes.SubSequence) throws(TransformationFailure) -> Self.Element
    ) throws(BytesError.Transformation<TransformationFailure>.BufferSizeError) {
        try self.init(bytes: bytes, element: Element.self, mapping: transform)
    }
    
    /// Creates a new collection from a sequence of bytes, transforming batches of bytes into the specified element type.
    ///
    /// Pass an element with the memory layout size you intend to de-serialize and transform into elements that'll be saved within the collection.
    /// - Parameters:
    ///   - bytes: The bytes to transform.
    ///   - element: The element that was used to encode the byte sequence.
    ///   - transform: The transformation to perform on each element.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the total size of the bytes sequence is not a multiple of the element's size.
    ///     - ``BytesError/TransformationError/transformationFailure(_:)`` if the `transform` closure threw an error.
    /// - SeeAlso: ``init(bytes:mapping:)`` for when the collection element matches the encoded element.
    /// - SeeAlso: ``init(bytes:elementSize:mapping:)`` for when its not suitable to infer the size of an element from its memory layout.
    @inlinable
    public init<
        Bytes: BytesCollection,
        EncodedElement,
        TransformationFailure: Error
    >(
        bytes: Bytes,
        element: EncodedElement.Type,
        mapping transform: (Bytes.SubSequence) throws(TransformationFailure) -> Self.Element
    ) throws(BytesError.Transformation<TransformationFailure>.BufferSizeError) {
        let elementSize: Int
        let elementCount: Int
        do {
            (elementSize, elementCount) = try bytes.canBeMapped(to: EncodedElement.self)
        } catch {
            throw .castingFailure(error)
        }
        
        var result = Self()
        result.reserveCapacity(elementCount)
        
        var startIndex = bytes.startIndex
        var nextIndex = startIndex
        while bytes.formIndex(&nextIndex, offsetBy: elementSize, limitedBy: bytes.endIndex) {
            let slice = bytes[startIndex..<nextIndex]
            startIndex = nextIndex
            do {
                result.append(try transform(slice))
            } catch {
                throw .transformationFailure(error)
            }
        }
        
        self = result
    }
    
    /// Creates a new collection from a sequence of bytes, transforming batches of bytes into the specified element type.
    ///
    /// Pass the element size you wish to de-serialize and transform into elements that'll be saved within the collection.
    /// - Parameters:
    ///   - bytes: The bytes to transform.
    ///   - elementSize: The size of the element that was used to encode the byte sequence.
    ///   - transform: The transformation to perform on each element.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the total size of the bytes sequence is not a multiple of the element's size.
    ///     - ``BytesError/TransformationError/transformationFailure(_:)`` if the `transform` closure threw an error.
    /// - SeeAlso: ``init(bytes:mapping:)`` for when the collection element matches the encoded element.
    /// - SeeAlso: ``init(bytes:element:mapping:)`` for when an element's memory layout can be used to infer the size.
    @inlinable
    public init<
        Bytes: BytesCollection,
        TransformationFailure: Error
    >(
        bytes: Bytes,
        elementSize: Int,
        mapping transform: (Bytes.SubSequence) throws(TransformationFailure) -> Self.Element
    ) throws(BytesError.Transformation<TransformationFailure>.BufferSizeError) {
        let elementCount: Int
        do {
            elementCount = try bytes.canBeMapped(to: elementSize)
        } catch {
            throw .castingFailure(error)
        }
        
        var result = Self()
        result.reserveCapacity(elementCount)
        
        var startIndex = bytes.startIndex
        var nextIndex = startIndex
        while bytes.formIndex(&nextIndex, offsetBy: elementSize, limitedBy: bytes.endIndex) {
            let slice = bytes[startIndex..<nextIndex]
            startIndex = nextIndex
            do {
                result.append(try transform(slice))
            } catch {
                throw .transformationFailure(error)
            }
        }
        
        self = result
    }
}

extension Set {
    /// Creates a new Set from a sequence of bytes, transforming batches of bytes into the element type of the Set.
    /// - Parameters:
    ///   - bytes: The bytes to transform.
    ///   - transform: The transformation to perform on each element.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the total size of the bytes sequence is not a multiple of the element's size.
    ///     - ``BytesError/TransformationError/transformationFailure(_:)`` if the `transform` closure threw an error.
    /// - SeeAlso: ``init(bytes:element:mapping:)`` for when an element's memory layout can be used to infer the size.
    /// - SeeAlso: ``init(bytes:elementSize:mapping:)`` for when its not suitable to infer the size of an element from its memory layout.
    @inlinable
    public init<
        Bytes: BytesCollection,
        TransformationFailure: Error
    >(
        bytes: Bytes,
        mapping transform: (Bytes.SubSequence) throws(TransformationFailure) -> Self.Element
    ) throws(BytesError.Transformation<TransformationFailure>.BufferSizeError) {
        try self.init(bytes: bytes, element: Element.self, mapping: transform)
    }
    
    /// Creates a new Set from a sequence of bytes, transforming batches of bytes into the specified element type.
    ///
    /// Pass an element with the memory layout size you intend to de-serialize and transform into elements that'll be saved within the collection.
    /// - Parameters:
    ///   - bytes: The bytes to transform.
    ///   - element: The element that was used to encode the byte sequence.
    ///   - transform: The transformation to perform on each element.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the total size of the bytes sequence is not a multiple of the element's size.
    ///     - ``BytesError/TransformationError/transformationFailure(_:)`` if the `transform` closure threw an error.
    /// - SeeAlso: ``init(bytes:mapping:)`` for when the collection element matches the encoded element.
    /// - SeeAlso: ``init(bytes:element:mapping:)`` for when an element's memory layout can be used to infer the size.
    @inlinable
    public init<
        Bytes: BytesCollection,
        EncodedElement,
        TransformationFailure: Error
    >(
        bytes: Bytes,
        element: EncodedElement.Type,
        mapping transform: (Bytes.SubSequence) throws(TransformationFailure) -> Self.Element
    ) throws(BytesError.Transformation<TransformationFailure>.BufferSizeError) {
        let elementSize: Int
        let elementCount: Int
        do {
            (elementSize, elementCount) = try bytes.canBeMapped(to: EncodedElement.self)
        } catch {
            throw .castingFailure(error)
        }
        
        var result = Self()
        result.reserveCapacity(elementCount)
        
        var startIndex = bytes.startIndex
        var nextIndex = startIndex
        while bytes.formIndex(&nextIndex, offsetBy: elementSize, limitedBy: bytes.endIndex) {
            let slice = bytes[startIndex..<nextIndex]
            startIndex = nextIndex
            do {
                result.insert(try transform(slice))
            } catch {
                throw .transformationFailure(error)
            }
        }
        
        self = result
    }
    
    /// Creates a new Set from a sequence of bytes, transforming batches of bytes into the specified element type.
    ///
    /// Pass the element size you wish to de-serialize and transform into elements that'll be saved within the collection.
    /// - Parameters:
    ///   - bytes: The bytes to transform.
    ///   - elementSize: The size of the element that was used to encode the byte sequence.
    ///   - transform: The transformation to perform on each element.
    /// - Throws:
    ///     - ``BytesError/BufferSizeError/invalidBufferSize(targetSize:targetType:actualSize:)`` if the total size of the bytes sequence is not a multiple of the element's size.
    ///     - ``BytesError/TransformationError/transformationFailure(_:)`` if the `transform` closure threw an error.
    /// - SeeAlso: ``init(bytes:mapping:)`` for when the collection element matches the encoded element.
    /// - SeeAlso: ``init(bytes:element:mapping:)`` for when an element's memory layout can be used to infer the size.
    @inlinable
    public init<
        Bytes: BytesCollection,
        TransformationFailure: Error
    >(
        bytes: Bytes,
        elementSize: Int,
        mapping transform: (Bytes.SubSequence) throws(TransformationFailure) -> Self.Element
    ) throws(BytesError.Transformation<TransformationFailure>.BufferSizeError) {
        let elementCount: Int
        do {
            elementCount = try bytes.canBeMapped(to: elementSize)
        } catch {
            throw .castingFailure(error)
        }
        
        var result = Self()
        result.reserveCapacity(elementCount)
        
        var startIndex = bytes.startIndex
        var nextIndex = startIndex
        while bytes.formIndex(&nextIndex, offsetBy: elementSize, limitedBy: bytes.endIndex) {
            let slice = bytes[startIndex..<nextIndex]
            startIndex = nextIndex
            do {
                result.insert(try transform(slice))
            } catch {
                throw .transformationFailure(error)
            }
        }
        
        self = result
    }
}
