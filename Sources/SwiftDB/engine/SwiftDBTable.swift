//
//  SwiftDBTable.swift
//  
//
//  Created by Tomasz Kucharski on 04/01/2021.
//

import Foundation

class SwiftDBTable {
    let name: String
    let dataType: SwiftDBModel.Type
    var autoIncrementIndex: Int = 1
    var content: [SwiftDBModel] = []
    
    init(name: String, dataType: SwiftDBModel.Type) {
        self.name = name
        self.dataType = dataType
    }
    
    func truncate() {
        self.content = []
        self.autoIncrementIndex = 1
    }
    
    func incrementIndex() {
        self.autoIncrementIndex = self.autoIncrementIndex + 1
    }
}
