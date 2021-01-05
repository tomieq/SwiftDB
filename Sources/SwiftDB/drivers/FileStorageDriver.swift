//
//  FileStorageDriver.swift
//  
//
//  Created by Tomasz Kucharski on 05/01/2021.
//

import Foundation

class FileStorageDriver: StorageDriver {
    let databaseName: String
    let rootUrl: URL
    
    init(databaseName: String, path: String) throws {
        self.databaseName = databaseName
        
        var url = URL(fileURLWithPath: path)
        url.appendPathComponent("SwiftDB")
        url.appendPathComponent(databaseName)
        
        self.rootUrl = url
        do {
            print("Initialize storage at \(url.absoluteString)")
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            
        } catch {
            throw SwiftDBError.persistentStorageError(error: error)
        }
    }
    
    func save<T: SwiftDBModel>(table: SwiftDBTable, dataType: T.Type) throws {
        if let encodable = table.content as? [T] {
            do {
                var url = self.rootUrl
                url.appendPathComponent("\(table.name).json")
                
                let encoder = JSONEncoder()
                let data = try encoder.encode(encodable)
                let json = String(decoding: data, as: UTF8.self)
                try json.write(to: url, atomically: true, encoding: .utf8)
                print("Saved \(encodable.count) objects into \(url.absoluteString)")
            } catch {
                throw SwiftDBError.persistentStorageError(error: error)
            }
        }
    }
}
