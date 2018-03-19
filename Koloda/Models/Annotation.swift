//
//  Annotation.swift
//  Koloda_Example
//
//  Created by Thibault Gagnaux on 13.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

class Annotation: APIBase, CustomStringConvertible {
    let challengeID: String
    let userID: String
    var answer: String?
    var latitude: Double?
    var longitude: Double?
    var localTime: Date?
    
    private enum CodingKeys: String, CodingKey {
        case challengeID
        case userID
        case answer
        case latitude
        case longitude
        case localTime
    }

    init(challengeID: String, userID: String, answer: String?, location: Location?, localTime: Date?) {
        self.challengeID = challengeID
        self.userID = userID
        self.answer = answer
        self.latitude = location?.latitude
        self.longitude = location?.longitude
        self.localTime = localTime
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.challengeID = try container.decode(String.self, forKey: .challengeID)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.answer = try container.decode(String.self, forKey: .answer)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.localTime = try container.decode(Date.self, forKey: .localTime)
    
        try super.init(from: decoder)
        
    }
    
    var description: String {
        return "challengeID: \(challengeID) - userID: \(userID) - answer: \(answer!) - longitude: \(longitude!) - latitude: \(latitude!) - localTime: \(String(describing: localTime))"
    }
}




