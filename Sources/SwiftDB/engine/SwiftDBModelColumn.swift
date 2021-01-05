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
