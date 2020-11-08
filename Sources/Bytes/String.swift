//
//  String.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 11/7/20.
//  Copyright © 2020 Mochi Development, Inc. All rights reserved.
//

extension StringProtocol {
    /// Get the UTF-8 representation of a string as a contiguous sequence of Bytes.
    @inlinable
    public var utf8Bytes: Bytes {
        return Bytes(self.utf8)
    }
    
    /// Initialize a String from a contiguous sequence of Bytes representing UTF-8 characters.
    /// - Parameter utf8Bytes: The Bytes to interpret as a string.
    @inlinable
    public init<Bytes: BytesCollection>(utf8Bytes: Bytes) {
        self.init(decoding: utf8Bytes, as: UTF8.self)
    }
}
