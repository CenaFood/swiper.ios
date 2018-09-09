//
//  Project.swift
//  Koloda_Example
//
//  Created by Thibault Gagnaux on 08.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

class Project: Codable {
    let id: String
    let description: String
    let issueDate: Date
    let expiryDate: Date
    
    init(id: String, description: String, issueDate: Date, expiryDate: Date) {
        self.id = id
        self.description = description
        self.issueDate = issueDate
        self.expiryDate = expiryDate
    }
}
