//
//  SwiftDBModelWrap.swift
//  
//
//  Created by Tomasz Kucharski on 05/01/2021.
//

import Foundation


struct SwiftDBModelMetaData {
    let name: String
    let value: Any
}

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
                    let unwrappedSomeValue = self.unwrap(child.value)
                    if    (unwrappedSomeValue is String || unwrappedSomeValue is Int || unwrappedSomeValue is Bool) {
                        self.metaData.append(SwiftDBModelMetaData(name: label, value: unwrappedSomeValue))
                        print("Added metadata \(label)=\(String(describing: unwrappedSomeValue))")
                    }
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

extension SwiftDBModelWrap: Equatable {
    static func == (lhs: SwiftDBModelWrap, rhs: SwiftDBModelWrap) -> Bool {
        return lhs.model.uniqueID == rhs.model.uniqueID
    }
}
