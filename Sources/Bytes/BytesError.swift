//
//  BytesError.swift
//  Bytes
//
//  Created by Dimitri Bouniol on 11/6/20.
//  Copyright © 2020 Mochi Development, Inc. All rights reserved.
//

public enum BytesError: Error {
    case invalidMemorySize(targetSize: Int, targetType: String, actualSize: Int)
    case contiguousMemoryUnavailable(type: String)
    
    case invalidCharacterByteSequence
    case invalidRawRepresentableByteSequence
    case invalidUUIDByteSequence
    
    case checkedSequenceNotFound
}
