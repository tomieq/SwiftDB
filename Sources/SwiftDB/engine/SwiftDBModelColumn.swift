//
//  SwiftDBModelColumn.swift
//  
//
//  Created by Tomasz Kucharski on 05/01/2021.
//

import Foundation

struct SwiftDBModelColumn {
    let name: String
    let dataType: String
}

extension SwiftDBModelColumn: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(self.name)(\(self.dataType))"
    }
}

extension SwiftDBModelColumn: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.name != rhs.name {
            return false
        }
        if lhs.dataType != rhs.dataType {
            return false
        }
        return true
    }
}
