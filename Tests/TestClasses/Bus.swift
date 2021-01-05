//
//  File.swift
//  
//
//  Created by Tomasz Kucharski on 05/01/2021.
//

import Foundation
@testable import SwiftDB

class Bus: SwiftDBModel {
    var uniqueID: String

    var doorAmount: Int?
    
    required init() {
        self.uniqueID = UUID().uuidString
    }
    
}
