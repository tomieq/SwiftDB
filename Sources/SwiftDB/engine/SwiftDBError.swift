//
//  SwiftDBError.swift
//  
//
//  Created by Tomasz Kucharski on 04/01/2021.
//

import Foundation

enum SwiftDBError: Error {
    case persistentStorageError(error: Error)
    case tableNotExists(name: String)
    case invalidObjectType(givenType: SwiftDBModel.Type, expectedType: String)
    case invalidObjectState(info: String)
    case objectAlreadyExists
    case queryError(info: String)
}

extension SwiftDBError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .persistentStorageError(let error):
            return "Error with persistent store: \(error.localizedDescription)"
        case .tableNotExists(let name):
            return "Table \(name) does not exists"
        case .invalidObjectType(let given, let expected):
            return "Expected type is \(expected) but \(given) given"
        case .invalidObjectState(let info):
            return info
        case .objectAlreadyExists:
            return "Object with given uniqueID already exists in table"
        case .queryError(let info):
            return "Query error: \(info)"
        }
    }
}
