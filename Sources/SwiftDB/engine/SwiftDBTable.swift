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
    
    init<T: SwiftDBModel>(name: String, dataType: T.Type) {
        self.name = name
        self.dataType = String(describing: dataType)
        
        let sampleObject = dataType.init()
        self.columns = sampleObject.getColumns()
    }
    
    func dataTypeMatch(type: SwiftDBModel.Type) -> Bool {
        return String(describing: type) == self.dataType
    }
    
    func truncate() {
        self.content = []
    }
}
