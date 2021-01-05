//
//  SwiftDBTable.swift
//  
//
//  Created by Tomasz Kucharski on 04/01/2021.
//

import Foundation

class SwiftDBTable {
    let name: String
    let dataType: String
    let columns: [SwiftDBModelColumn]
    var content: [SwiftDBModel] = []
    
    init(name: String, dataType: SwiftDBModel.Type) {
        self.name = name
        self.dataType = String(describing: dataType)
    }
    
    func dataTypeMatch(type: SwiftDBModel.Type) -> Bool {
        return String(describing: type) == self.dataType
    }
    
    func truncate() {
        self.content = []
    }
}
