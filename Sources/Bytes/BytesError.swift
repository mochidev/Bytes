//
//  BytesError.swift
//  https://github.com/mochidev/Bytes
//
//  Created by Dimitri Bouniol on 11/6/20.
//  Copyright © 2020-26 Mochi Development, Inc. All rights reserved.
//  mochidev-swift-bytes: F44D5591194F47C0834EC1EBD0102932
//

public enum BytesError: Error {
    case invalidMemorySize(targetSize: Int, targetType: String, actualSize: Int)
    case contiguousMemoryUnavailable(type: String)
    
    case invalidCharacterByteSequence
    case invalidRawRepresentableByteSequence
    case invalidUUIDByteSequence
    
    case checkedSequenceNotFound
}
