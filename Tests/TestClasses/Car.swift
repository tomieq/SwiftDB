//
//  Car.swift
//  
//
//  Created by Tomasz Kucharski on 05/01/2021.
//

import Foundation
@testable import SwiftDB

class Car: SwiftDBModel {
    var uniqueID: String
    
    var color: String?
    var fuelLevel: Int?
    
    required init() {
        self.uniqueID = UUID().uuidString
    }
    
}

