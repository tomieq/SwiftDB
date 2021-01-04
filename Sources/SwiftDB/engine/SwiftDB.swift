//
//  SwiftDB.swift
//  
//
//  Created by Tomasz Kucharski on 04/01/2021.
//

import Foundation

class SwiftDB {

    private var databaseName: String?
    private var meta: [String: SwiftDBModel.Type] = [:]
    private var content: [String: [Codable]] = [:]
    
    func createDatabase(name: String) {
        self.databaseName = name
    }
    
    func useDatabase(name: String) {
        self.databaseName = name
    }
    
    func createTable<T: SwiftDBModel>(name: String, template: T.Type) {
        self.meta[name] = template
        self.content[name] = []
        print("Created new table \(name) for storing \(template) objects")
    }
    
    func dropTable(name: String) {
        self.meta[name] = nil
        self.content[name] = nil
    }
    
    func truncateTable(name: String) {
        self.content[name] = nil
    }
    
    func insert<T: SwiftDBModel>(object: T, into tableName: String) throws {
        guard let expectedModel = self.meta[tableName] else {
            throw SwiftDBError.tableNotExists(name: tableName)
        }
        guard T.self == expectedModel else {
            throw SwiftDBError.invalidObjectType(given: T.self, expected: expectedModel)
        }
    }
}
