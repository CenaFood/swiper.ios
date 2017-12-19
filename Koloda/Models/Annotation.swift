//
//  Annotation.swift
//  Koloda_Example
//
//  Created by Thibault Gagnaux on 13.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

class Annotation: Codable, CustomStringConvertible {
    let challengeID: String
    let userID: String
    var answer: String?
    var latitude: Double?
    var longitude: Double?
    var localTime: Date?

    init(challengeID: String, userID: String, answer: String?, location: Location?, localTime: Date?) {
        self.challengeID = challengeID
        self.userID = userID
        self.answer = answer
        self.latitude = location?.latitude
        self.longitude = location?.longitude
        self.localTime = localTime
    }
    
    var description: String {
        return "challengeID: \(challengeID) - userID: \(userID) - answer: \(answer!) - longitude: \(longitude!) - latitude: \(latitude!) - localTime: \(String(describing: localTime))"
    }
}




