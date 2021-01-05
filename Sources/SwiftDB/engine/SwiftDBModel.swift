//
//  SwiftDBModel.swift
//  
//
//  Created by Tomasz Kucharski on 04/01/2021.
//

import Foundation

protocol SwiftDBModel: class, Codable {
    var uniqueID: String { get }
    
    init()
}


extension SwiftDBModel {
    func getColumns() -> [SwiftDBModelColumn] {
        var columns = [SwiftDBModelColumn]()
        
        var mirror: Mirror? = Mirror(reflecting: self)
        while mirror != nil {
            mirror?.children.forEach { child in
                let dataType = String(describing: type(of: child.value))
                if let label = child.label {
                    columns.append(SwiftDBModelColumn(name: label, dataType: dataType))
                }
            }
            mirror = mirror?.superclassMirror
        }
        return columns
    }
}
