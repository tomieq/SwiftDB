//
//  SwiftDBModel.swift
//  
//
//  Created by Tomasz Kucharski on 04/01/2021.
//

import Foundation

class SwiftDBModel: Codable {
    var uniqueID: String
    
    required init() {
        self.uniqueID = UUID().uuidString
    }
}
