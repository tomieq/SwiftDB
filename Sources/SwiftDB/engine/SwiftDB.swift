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
        self.tables = []
    }
    
    func useDatabase(name: String) {
        self.databaseName = name
        // load tables into memory
        self.tables = []
    }
    
    func createTable<T: SwiftDBModel>(name: String, dataType: T.Type) {
        let table = SwiftDBTable(name: name, dataType: dataType)
        self.tables.append(table)
        print("Created new table \(name) for storing \(dataType) objects with columns \(table.columns.debugDescription)")
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
        guard table.dataTypeMatch(type: T.self) else {
            throw SwiftDBError.invalidObjectType(givenType: T.self, expectedType: table.dataType)
        }
        
        print("Inserted new data into \(tableName)")
        table.content.append(object)
    }
}
