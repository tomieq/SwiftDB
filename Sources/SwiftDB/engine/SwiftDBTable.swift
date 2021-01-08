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
    var content: [SwiftDBModelWrap] = []
    
    init<T: SwiftDBModel>(name: String, dataType: T.Type) {
        self.name = name
        self.dataType = String(describing: dataType)
        
        let sampleObject = dataType.init()
        self.columns = sampleObject.getColumns()
    }
    
    func dataTypeMatch(type: SwiftDBModel.Type) -> Bool {
        let sampleObject = type.init()
        if String(describing: type) != self.dataType {
            return false
        }
        if self.columns != sampleObject.getColumns() {
            return false
        }
        return true
    }
    
    func objectExists(uniqueID: String, in tableName: String) -> Bool {
        return self.content.count{ $0.model.uniqueID == uniqueID } > 0
    }
    
    func truncate() {
        self.content = []
    }
    
    class func filterContent<T: Equatable>(content: [SwiftDBModelWrap], attribute: String, value: T) throws -> [SwiftDBModelWrap] {
        return try content.filter { wrap in
            if let metaData = (wrap.metaData.filter { $0.name == attribute }.first) {
                guard let objectValue = metaData.value as? T else {
                    throw SwiftDBError.queryError(info: "Attribute \(attribute) is not a \(T.self) type.")
                }
                if objectValue == value {
                    return true
                }
            }
            return false
        }
    }
}
