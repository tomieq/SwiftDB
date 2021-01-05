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
        
        
        do {
            let sampleObject = dataType.init()
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(sampleObject)
            if let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
            
                for (label, value) in dict {
                    
                    print("label=\(label) type =\(type(of: value))")
                }
            }
            self.columns = []
        } catch {
            self.columns = []
            print("Something went wrong")
        }
    }
    
    func dataTypeMatch(type: SwiftDBModel.Type) -> Bool {
        return String(describing: type) == self.dataType
    }
    
    func truncate() {
        self.content = []
    }
}
