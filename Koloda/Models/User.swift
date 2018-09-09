//
//  User.swift
//  Koloda_Example
//
//  Created by Thibault Gagnaux on 08.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

class User: Codable {
    let password: String
    let email: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    var description: String {
        return "email: \(email) - password: \(password)"
    }
}
