//
//  main.swift
//  
//
//  Created by Tomasz Kucharski on 04/01/2021.
//

import Foundation

print("SwiftDB is going to be created!")

class User: SwiftDBModel {
    var id: Int?
    var name: String?
}

class Car: SwiftDBModel {
    var id: Int?
    var color: String?
}

let db = SwiftDB()
db.createDatabase(name: "test")
db.createTable(name: "users", dataType: User.self)
db.createTable(name: "cars", dataType: Car.self)

var user1 = User()
user1.name = "John"
var user2 = User()
user2.name = "Alice"

var car = Car()
car.color = "red"

do {
    try db.insert(object: user1, into: "users")
    print("id=\(user1.id)")
    try db.insert(object: user2, into: "users")
    print("id=\(user2.id)")
    try db.insert(object: car, into: "cars")
    try db.insert(object: car, into: "users")
} catch  {
    print("Exception \(error.self), \(error.localizedDescription)")
}
