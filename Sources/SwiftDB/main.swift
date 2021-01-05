//
//  main.swift
//  
//
//  Created by Tomasz Kucharski on 04/01/2021.
//

import Foundation

print("SwiftDB is going to be created!")

class User: SwiftDBModel {
    
    var uniqueID: String
    
    var id: Int?
    var name: String?
    
    required init() {
        self.uniqueID = UUID().uuidString
    }
}

class Car: SwiftDBModel {
    var uniqueID: String
    
    var id: Int?
    var color: String?
    
    required init() {
        self.uniqueID = UUID().uuidString
    }
}

class Bus: Car {
    var doorAmount: Int?
}

let db = SwiftDB()
db.createDatabase(name: "test")
db.createTable(name: "users", dataType: User.self)
db.createTable(name: "cars", dataType: Car.self)
db.createTable(name: "buses", dataType: Bus.self)

var user1 = User()
user1.name = "John"
var user2 = User()
user2.name = "Alice"

var car = Car()
car.color = "red"

var bus = Bus()
bus.doorAmount = 3

do {
    try db.insert(object: user1, into: "users")
    try db.insert(object: user2, into: "users")
    try db.insert(object: car, into: "cars")
    try db.insert(object: bus, into: "buses")
    //try db.insert(object: car, into: "users")
} catch  {
    print("Exception \(error.self), \(error.localizedDescription)")
}
