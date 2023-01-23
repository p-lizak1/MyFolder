//
//  User.swift
//  MyFolder
//
//  Created by Peter Lizak on 18/01/2023.
//

import Foundation

struct User: Codable {
    let firstName, lastName: String
    var rootItem: Item
}

