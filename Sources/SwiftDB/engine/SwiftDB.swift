//
//  SwiftDB.swift
//  
//
//  Created by Tomasz Kucharski on 04/01/2021.
//

import Foundation

class SwiftDB {

    private var databaseName: String?
    private var tables: [SwiftDBTable] = []
    
    func createDatabase(name: String) {
        self.databaseName = name
    }
    
    func useDatabase(name: String) {
        self.databaseName = name
    }
    
    func createTable<T: SwiftDBModel>(name: String, dataType: T.Type) {
        let table = SwiftDBTable(name: name, dataType: dataType)
        self.tables.append(table)
        print("Created new table \(name) for storing \(dataType) objects")
    }
    
    func dropTable(name: String) {
        self.tables = self.tables.filter { $0.name != name }
    }
    
    func truncateTable(name: String) throws {
        
        guard let table = (self.tables.filter{ $0.name == name }.first) else {
            throw SwiftDBError.tableNotExists(name: name)
        }
        table.truncate()
    }
    
    func insert<T: SwiftDBModel>(object: T, into tableName: String) throws {
        guard let table = (self.tables.filter{ $0.name == tableName }.first) else {
            throw SwiftDBError.tableNotExists(name: tableName)
        }
        let expectedModel = table.dataType
        guard T.self == expectedModel else {
            throw SwiftDBError.invalidObjectType(given: T.self, expected: expectedModel)
        }
        
        guard object.id == .none else {
            throw SwiftDBError.invalidObjectState(info: "Inserted object cannot have set id")
        }
        print("Inserted new data into \(tableName)")
        
        object.id = table.autoIncrementIndex
        table.incrementIndex()
    }
}
