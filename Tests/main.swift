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
    
    func testSelectQueryEquals() {
        
        let audi = Car()
        audi.color = "black"
        audi.fuelLevel = 50
        audi.isOpen = false
        
        let mercedes = Car()
        mercedes.color = "silver"
        mercedes.fuelLevel = 90
        mercedes.isOpen = true
        
        do {
            let db = try SwiftDB(databaseName: "tests")
            try db.createTable(name: "cars", dataType: Car.self)
            try db.insert(object: audi, into: "cars")
            try db.insert(object: mercedes, into: "cars")
            
            var cars: [Car] = try db.select(from: "cars", where: .equalsString(attribute: "color", value: "silver"))
            XCTAssertEqual(cars.count, 1)
            XCTAssertNotNil(cars.first)
            XCTAssertEqual("silver", cars.first?.color)
            
            cars = try db.select(from: "cars", where: .equalsInt(attribute: "fuelLevel", value: 90))
            XCTAssertEqual(cars.count, 1)
            XCTAssertNotNil(cars.first)
            XCTAssertEqual(90, cars.first?.fuelLevel)
            
            cars = try db.select(from: "cars", where: .equalsBool(attribute: "isOpen", value: true))
            XCTAssertEqual(cars.count, 1)
            XCTAssertNotNil(cars.first)
            XCTAssertEqual(true, cars.first?.isOpen)
        } catch {
            XCTFail("Test should not throw")
        }
    }
    
    func testModifyinigInsertedObject() {
        let car = Car()
        car.color = "red"
        car.fuelLevel = 50
        
        do {
            let db = try SwiftDB(databaseName: "tests")
            try db.createTable(name: "cars", dataType: Car.self)
            try db.insert(object: car, into: "cars")
            
            car.fuelLevel = 10
            
            var cars: [Car] = try db.select(from: "cars")
            XCTAssertEqual(cars.count, 1)
            var retrievedCar = cars.first
            XCTAssertEqual(retrievedCar?.fuelLevel, 50)
            
            retrievedCar?.fuelLevel = 100
            
            cars = try db.select(from: "cars")
            XCTAssertEqual(cars.count, 1)
            retrievedCar = cars.first
            XCTAssertEqual(retrievedCar?.fuelLevel, 50)
        } catch {
            XCTFail("Test should not throw")
        }
    }
    
    func testOrQuery() {
        let audi = Car()
        audi.color = "black"
        audi.fuelLevel = 50
        audi.isOpen = false
        
        let mercedes = Car()
        mercedes.color = "silver"
        mercedes.fuelLevel = 90
        mercedes.isOpen = true
        
        let toyota = Car()
        toyota.color = "red"
        toyota.fuelLevel = 90
        
        let mazda = Car()
        mazda.color = "blue"
        mazda.fuelLevel = 90
        
        do {
            let db = try SwiftDB(databaseName: "tests")
            try db.createTable(name: "cars", dataType: Car.self)
            try db.insert(object: audi, into: "cars")
            try db.insert(object: mercedes, into: "cars")
            try db.insert(object: toyota, into: "cars")
            try db.insert(object: mazda, into: "cars")
            
            var cars: [Car] = try db.select(from: "cars", where: .or([
                .equalsString(attribute: "color", value: "silver"),
                .equalsInt(attribute: "fuelLevel", value: 90)
            ]))
            XCTAssertEqual(cars.count, 3)
            
            
            
            cars = try db.select(from: "cars", where: .or([
                .equalsString(attribute: "color", value: "black"),
                .equalsString(attribute: "color", value: "red")
            ]))
            XCTAssertEqual(cars.count, 2)
        } catch {
            XCTFail("Test should not throw")
        }
    }
    
    func testAndQuery() {
        
        let audi = Car()
        audi.color = "black"
        audi.fuelLevel = 50
        audi.isOpen = false
        
        let mercedes = Car()
        mercedes.color = "silver"
        mercedes.fuelLevel = 90
        mercedes.isOpen = true
        
        let toyota = Car()
        toyota.color = "red"
        toyota.fuelLevel = 90
        
        let mazda = Car()
        mazda.color = "blue"
        mazda.fuelLevel = 90
        
        do {
            let db = try SwiftDB(databaseName: "tests")
            try db.createTable(name: "cars", dataType: Car.self)
            try db.insert(object: audi, into: "cars")
            try db.insert(object: mercedes, into: "cars")
            try db.insert(object: toyota, into: "cars")
            try db.insert(object: mazda, into: "cars")
            
            var cars: [Car] = try db.select(from: "cars", where: .and([
                .equalsString(attribute: "color", value: "silver"),
                .equalsInt(attribute: "fuelLevel", value: 90)
            ]))
            XCTAssertEqual(cars.count, 1)
            XCTAssertEqual(cars.first?.fuelLevel, 90)
            
            
            cars = try db.select(from: "cars", where: .and([
                .equalsString(attribute: "color", value: "silver"),
                .equalsInt(attribute: "fuelLevel", value: 50)
            ]))
            XCTAssertEqual(cars.count, 0)
            
        } catch {
            XCTFail("Test should not throw")
        }
    }
}
