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
            let db = SwiftDB()
            db.createDatabase(name: "tests")
            db.createTable(name: "cars", dataType: Car.self)
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
            let db = SwiftDB()
            db.createDatabase(name: "tests")
            db.createTable(name: "buses", dataType: Car.self)
            try db.insert(object: bus, into: "buses")
            XCTFail("Test should throw because types are different")
            
        } catch {
            
            if case SwiftDBError.invalidObjectType(_, _) = error {
                
            } else {
                XCTFail("Invalid exception \(error)")
            }
        }
    }
}
