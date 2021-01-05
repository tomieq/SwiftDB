//
//  StorageDriver.swift
//  
//
//  Created by Tomasz Kucharski on 05/01/2021.
//

import Foundation

protocol StorageDriver {
    func save<T: SwiftDBModel>(table: SwiftDBTable, dataType: T.Type) throws
}
