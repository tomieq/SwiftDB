//
//  SwiftDBError.swift
//  
//
//  Created by Tomasz Kucharski on 04/01/2021.
//

import Foundation

enum SwiftDBError: Error {
    case tableNotExists(name: String)
    case invalidObjectType(given: SwiftDBModel.Type, expected: SwiftDBModel.Type)
    case invalidObjectState(info: String)
}

extension SwiftDBError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .tableNotExists(let name):
            return "Table \(name) does not exists"
        case .invalidObjectType(let given, let expected):
            return "Expected type is \(expected) but \(given) given"
        case .invalidObjectState(let info):
            return info
        }
    }
}