//
//  SwiftDBQuery.swift
//  
//
//  Created by Tomasz Kucharski on 08/01/2021.
//

import Foundation

enum SwiftDBQuery {
    case equalsString(attribute: String, value: String)
    case equalsInt(attribute: String, value: Int)
    case equalsBool(attribute: String, value: Bool)
    case or([SwiftDBQuery])
    case and([SwiftDBQuery])
    
    static func equals(_ attribute: String, toString value: String) -> SwiftDBQuery {
        return .equalsString(attribute: attribute, value: value)
    }
    static func equals(_ attribute: String, toInt value: Int) -> SwiftDBQuery {
        return .equalsInt(attribute: attribute, value: value)
    }
    static func equals(_ attribute: String, toBool value: Bool) -> SwiftDBQuery {
        return .equalsBool(attribute: attribute, value: value)
    }
}
