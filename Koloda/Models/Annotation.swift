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
    var answer: String?
    var latitude: Double?
    var longitude: Double?
    var localTime: Date?
    
    private enum CodingKeys: String, CodingKey {
        case challengeID
        case answer
        case latitude
        case longitude
        case localTime
    }

    init(challengeID: String, answer: String?, location: Location?, localTime: Date?) {
        self.challengeID = challengeID
        self.answer = answer
        self.latitude = location?.latitude
        self.longitude = location?.longitude
        self.localTime = localTime
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.challengeID = try container.decode(String.self, forKey: .challengeID)
        self.answer = try container.decode(String.self, forKey: .answer)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.localTime = try container.decode(Date.self, forKey: .localTime)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(challengeID, forKey: .challengeID)
        try container.encode(answer, forKey: .answer)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(localTime, forKey: .localTime)
    }
        
    
    var description: String {
        return "challengeID: \(challengeID) - answer: \(answer!) - longitude: \(longitude!) - latitude: \(latitude!) - localTime: \(String(describing: localTime!))"
    }
}




