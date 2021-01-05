//
//  SwiftDBModelWrap.swift
//  
//
//  Created by Tomasz Kucharski on 05/01/2021.
//

import Foundation

class SwiftDBModelWrap {
    let model: SwiftDBModel
    var metaData: [SwiftDBModelMetaData] = []
    
    init(_ model: SwiftDBModel) {
        self.model = model
        self.updateMetaData()
    }
    
    private func updateMetaData() {
        self.metaData = []
        var mirror: Mirror? = Mirror(reflecting: self.model)
        while mirror != nil {
            mirror?.children.forEach { child in
                
                if let label = child.label {
                    let value = String(describing: self.unwrap(child.value))
                    self.metaData.append(SwiftDBModelMetaData(name: label, value: value))
                }
            }
            mirror = mirror?.superclassMirror
        }
    }
    
    private func unwrap<T>(_ any: T) -> Any
    {
        let mirror = Mirror(reflecting: any)
        guard mirror.displayStyle == .optional, let first = mirror.children.first else {
            return any
        }
        return first.value
    }
}

struct SwiftDBModelMetaData {
    let name: String
    let value: String
}
