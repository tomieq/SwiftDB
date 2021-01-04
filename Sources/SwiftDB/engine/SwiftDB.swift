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
    private var autoIncrementIndex: [String: Int] = [:]
    
    func createDatabase(name: String) {
        self.databaseName = name
    }
    
    func useDatabase(name: String) {
        self.databaseName = name
    }
    
    func createTable<T: SwiftDBModel>(name: String, template: T.Type) {
        self.meta[name] = template
        self.content[name] = []
        self.autoIncrementIndex[name] = 0
        print("Created new table \(name) for storing \(template) objects")
    }
    
    func dropTable(name: String) {
        self.meta[name] = nil
        self.content[name] = nil
        self.autoIncrementIndex[name] = nil
    }
    
    func truncateTable(name: String) {
        self.content[name] = nil
        self.autoIncrementIndex[name] = 0
    }
    
    func insert<T: SwiftDBModel>(object: T, into tableName: String) throws {
        guard let expectedModel = self.meta[tableName] else {
            throw SwiftDBError.tableNotExists(name: tableName)
        }
        guard T.self == expectedModel else {
            throw SwiftDBError.invalidObjectType(given: T.self, expected: expectedModel)
        }
        
        let nextIndex = (self.autoIncrementIndex[tableName] ?? 0) + 1
        
        
        self.autoIncrementIndex[tableName] = nextIndex
    }
}
