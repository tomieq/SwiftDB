//
//  SwiftDBTests.swift
//  
//
//  Created by Tomasz Kucharski on 05/01/2021.
//

@testable import SwiftDB

import Foundation
import XCTest


class SwiftDBTests: XCTestCase {

    func testInsert() {
        
        let car = Car()
        car.color = "red"
        car.fuelLevel = 50
        
        do {
            let db = try SwiftDB(databaseName: "tests")
            try db.createTable(name: "cars", dataType: Car.self)
            try db.insert(object: car, into: "cars")
            
            let retrievedCars: [Car] = try db.select(from: "cars")
            XCTAssertEqual(retrievedCars.count, 1)
        } catch {
            XCTFail("Test should not throw")
        }
 
    }
    
    func testIncorrectDataTypeInsert() {
        let bus = Bus()
        bus.doorAmount = 3
        
        do {
            let db = try SwiftDB(databaseName: "tests")
            try db.createTable(name: "buses", dataType: Car.self)
            try db.insert(object: bus, into: "buses")
            XCTFail("Test should throw because types are different")
            
        } catch {
            
            if case SwiftDBError.invalidObjectType(_, _) = error {
                
            } else {
                XCTFail("Invalid exception \(error)")
            }
        }
    }
    
    func testSelectAll() {
        let audi = Car()
        audi.color = "black"
        audi.fuelLevel = 50
        
        let mercedes = Car()
        mercedes.color = "silver"
        mercedes.fuelLevel = 90
        
        do {
            let db = try SwiftDB(databaseName: "tests")
            try db.createTable(name: "cars", dataType: Car.self)
            try db.insert(object: audi, into: "cars")
            try db.insert(object: mercedes, into: "cars")
            
            let retrievedCars: [Car] = try db.select(from: "cars")
            XCTAssertEqual(retrievedCars.count, 2)
        } catch {
            XCTFail("Test should not throw")
        }
    }
    
    func testDeleteSingle() {
        
        let audi = Car()
        audi.color = "black"
        audi.fuelLevel = 50
        
        let mercedes = Car()
        mercedes.color = "silver"
        mercedes.fuelLevel = 90
        
        do {
            let db = try SwiftDB(databaseName: "tests")
            try db.createTable(name: "cars", dataType: Car.self)
            try db.insert(object: audi, into: "cars")
            try db.insert(object: mercedes, into: "cars")
            
            var retrievedCars: [Car] = try db.select(from: "cars")
            XCTAssertEqual(retrievedCars.count, 2)
            
            try db.delete(object: mercedes, from: "cars")
            
            retrievedCars = try db.select(from: "cars")
            XCTAssertEqual(retrievedCars.count, 1)
        } catch {
            XCTFail("Test should not throw")
        }
    }
    
    func testComplexInsert() {
        
        let audi = Car()
        audi.color = "black"
        audi.fuelLevel = 50
        
        let mercedes = Car()
        mercedes.color = "silver"
        mercedes.fuelLevel = 90
        
        let garage = Garage()
        garage.cars = [audi, mercedes]
        
        do {
            let db = try SwiftDB(databaseName: "tests")
            try db.createTable(name: "garages", dataType: Garage.self)
            try db.insert(object: garage, into: "garages")
            
            let garages: [Garage] = try db.select(from: "garages")
            let retrievedCars = garages.first?.cars ?? []
            XCTAssertEqual(retrievedCars.count, 2)
        } catch {
            XCTFail("Test should not throw")
        }
    }
    
    func testPersistentStore() {
        
        let car = Car()
        car.color = "red"
        car.fuelLevel = 50
        
        do {
            let db = try SwiftDB(.fileStorage(path: FileManager.default.currentDirectoryPath), databaseName: "tests")
            try db.createTable(name: "cars", dataType: Car.self)
            try db.insert(object: car, into: "cars")
            
            let retrievedCars: [Car] = try db.select(from: "cars")
            XCTAssertEqual(retrievedCars.count, 1)
        } catch {
            XCTFail("Test should not throw")
        }
        
    }
}
