//
//  User.swift
//  Koloda_Example
//
//  Created by Thibault Gagnaux on 08.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

class User: Codable {
    let id: String
    let email: String
    
    init(id: String, email: String) {
        self.id = id
        self.email = email
    }
}
