//
//  SwiftDBModel.swift
//  
//
//  Created by Tomasz Kucharski on 04/01/2021.
//

import Foundation

protocol SwiftDBModel: Codable {
    var id: Int? { get }
}