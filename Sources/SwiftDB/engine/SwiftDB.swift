//
//  SwiftDB.swift
//  
//
//  Created by Tomasz Kucharski on 04/01/2021.
//

import Foundation

class SwiftDB {

    private var databaseName: String?
    
    func createDatabase(name: String) {
        self.databaseName = name
    }
    
    func useDatabase(name: String) {
        self.databaseName = name
    }
    
    func createTable(name: String, template: Codable) {
        
    }
    
    func dropTable(name: String) {
        
    }
    
    func truncateTable(name: String) {
        
    }
    
    func insert(object: Codable) {
        
    }
}
