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

    private var databaseName: String?
    private var type: SwiftDBType
    private var tables: [SwiftDBTable] = []
    
    init(_ type: SwiftDBType = .memory) {
        self.type = type
    }
    
    func createDatabase(name: String) throws {
        self.databaseName = name
        self.tables = []
    }
    
    func useDatabase(name: String) throws {
        self.databaseName = name
        // load tables into memory
        self.tables = []
    }
    
    private func getTable(named name: String) -> SwiftDBTable? {
        return self.tables.filter{ $0.name == name }.first
    }
    
    func createTable<T: SwiftDBModel>(name: String, dataType: T.Type) throws {
        guard let _ = self.databaseName else {
            throw SwiftDBError.databaseNotSelected
        }
        let table = SwiftDBTable(name: name, dataType: dataType)
        self.tables.append(table)
        print("Created new table \(name) for storing \(dataType) objects with columns \(table.columns.debugDescription)")
    }
    
    func dropTable(name: String) throws {
        guard let _ = self.databaseName else {
            throw SwiftDBError.databaseNotSelected
        }
        self.tables = self.tables.filter { $0.name != name }
    }
    
    func truncateTable(name: String) throws {
        guard let _ = self.databaseName else {
            throw SwiftDBError.databaseNotSelected
        }
        guard let table = self.getTable(named: name) else {
            throw SwiftDBError.tableNotExists(name: name)
        }
        table.truncate()
    }
    
    func insert<T: SwiftDBModel>(object: T, into tableName: String) throws {
        guard let _ = self.databaseName else {
            throw SwiftDBError.databaseNotSelected
        }
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
        
        let encoder = JSONEncoder()
        if let encodable = table.content as? [T] {
            do {
                let data = try encoder.encode(encodable)
                print("Encoded data=\(String(decoding: data, as: UTF8.self))")
            } catch {
                print("Encoder error \(error.localizedDescription)")
            }
        }
    }
    
    func delete<T: SwiftDBModel>(object: T, from tableName: String) throws {
        guard let _ = self.databaseName else {
            throw SwiftDBError.databaseNotSelected
        }
        guard let table = self.getTable(named: tableName) else {
            throw SwiftDBError.tableNotExists(name: tableName)
        }
        guard table.dataTypeMatch(type: T.self) else {
            throw SwiftDBError.invalidObjectType(givenType: T.self, expectedType: table.dataType)
        }
        
        table.content = table.content.filter { $0.uniqueID != object.uniqueID }
        print("Deleted object from \(tableName) with uniqueID=\(object.uniqueID)")
    }
    
    func select<T: SwiftDBModel>(from tableName: String) throws -> [T]  {
        guard let _ = self.databaseName else {
            throw SwiftDBError.databaseNotSelected
        }
        guard let table = self.getTable(named: tableName) else {
            throw SwiftDBError.tableNotExists(name: tableName)
        }
        guard table.dataTypeMatch(type: T.self) else {
            throw SwiftDBError.invalidObjectType(givenType: T.self, expectedType: table.dataType)
        }
        return (table.content as? [T]) ?? []
        
    }
}
