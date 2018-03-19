//
//  Credentials.swift
//  cena
//
//  Created by Thibault Gagnaux on 12.03.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

class Credentials: APIBase, CustomStringConvertible {
    let email: String
    let password: String
    
    private enum CodingKeys: String, CodingKey {
        case email
        case password
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
    }
    
    var description: String {
        return "username: \(email) - password: \(password)"
    }
}
