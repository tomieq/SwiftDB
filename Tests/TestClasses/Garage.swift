//
//  Garage.swift
//  
//
//  Created by Tomasz Kucharski on 05/01/2021.
//

import Foundation
@testable import SwiftDB

class Garage: SwiftDBModel {
    var uniqueID: String
    
    var cars: [Car]?
    var buses: [Bus]?
    
    required init() {
        self.uniqueID = UUID().uuidString
    }
    
}
