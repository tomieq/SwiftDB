//
//  SwiftDB.swift
//  
//
//  Created by Tomasz Kucharski on 04/01/2021.
//

import Foundation

enum SwiftDBType {
    case memory
    case fileStorage(path: String)
}

class SwiftDB {

    private var databaseName: String
    private var storageDriver: StorageDriver
    private var tables: [SwiftDBTable] = []
    
    init(_ type: SwiftDBType = .memory, databaseName: String) throws {
        
        self.databaseName = databaseName
        switch type {
        case .memory:
            self.storageDriver = MemoryStorageDriver()
        case .fileStorage(let path):
            try self.storageDriver = FileStorageDriver(databaseName: databaseName, path: path)
        }
        
    }
    
    private func getTable(named name: String) -> SwiftDBTable? {
        return self.tables.filter{ $0.name == name }.first
    }
    
    func createTable<T: SwiftDBModel>(name: String, dataType: T.Type) throws {

        let table = SwiftDBTable(name: name, dataType: dataType)
        self.tables.append(table)
        print("Created new table \(name) for storing \(dataType) objects with columns \(table.columns.debugDescription)")
        try self.save(table: table, dataType: T.self)
    }
    
    func dropTable(name: String) throws {

        self.tables = self.tables.filter { $0.name != name }
    }
    
    func truncateTable(name: String) throws {

        guard let table = self.getTable(named: name) else {
            throw SwiftDBError.tableNotExists(name: name)
        }
        table.truncate()
    }
    
    func insert<T: SwiftDBModel>(object: T, into tableName: String) throws {

        guard let table = self.getTable(named: tableName) else {
            throw SwiftDBError.tableNotExists(name: tableName)
        }
        guard table.dataTypeMatch(type: T.self) else {
            throw SwiftDBError.invalidObjectType(givenType: T.self, expectedType: table.dataType)
        }
        
        if table.objectExists(uniqueID: object.uniqueID, in: tableName) {
            throw SwiftDBError.objectAlreadyExists
        }
        
        print("Inserted new data into \(tableName)")
        table.content.append(object)
        
        try self.save(table: table, dataType: T.self)
    }
    
    func delete<T: SwiftDBModel>(object: T, from tableName: String) throws {

        guard let table = self.getTable(named: tableName) else {
            throw SwiftDBError.tableNotExists(name: tableName)
        }
        guard table.dataTypeMatch(type: T.self) else {
            throw SwiftDBError.invalidObjectType(givenType: T.self, expectedType: table.dataType)
        }
        
        table.content = table.content.filter { $0.uniqueID != object.uniqueID }
        print("Deleted object from \(tableName) with uniqueID=\(object.uniqueID)")
        try self.save(table: table, dataType: T.self)
    }
    
    func select<T: SwiftDBModel>(from tableName: String) throws -> [T]  {

        guard let table = self.getTable(named: tableName) else {
            throw SwiftDBError.tableNotExists(name: tableName)
        }
        guard table.dataTypeMatch(type: T.self) else {
            throw SwiftDBError.invalidObjectType(givenType: T.self, expectedType: table.dataType)
        }
        return (table.content as? [T]) ?? []
        
    }
    
    private func save<T: SwiftDBModel>(table: SwiftDBTable, dataType: T.Type) throws {
        try self.storageDriver.save(table: table, dataType: dataType)
    }
}
