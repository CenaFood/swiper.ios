//
//  Challenge.swift
//  Koloda_Example
//
//  Created by Thibault Gagnaux on 08.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

class Challenge: Codable, CustomStringConvertible {
    let id: String
    let projectID: String
    let challengeType: String
    let summary: String
    let image: Image
    let answers: [String]
    
    var description: String {
        return "id: \(id) - projectID: \(projectID) - challengeType: \(challengeType) - summary: \(summary) - image: \(image) - answers: \(answers)"
    }

    
    init(id: String, projectID: String, challengeType: String, summary: String, image: Image, answers: [String]) {
        self.id = id
        self.projectID = projectID
        self.challengeType = challengeType
        self.summary = summary
        self.image = image
        self.answers = answers;
    }
    
    // if we want to change the mapping from Json properties to swift properties
    enum CodingKeys: String, CodingKey {
        case id //= "id"
        case projectID //= "projectID"
        case challengeType //= "challengeType"
        case summary = "description"
        case image //= "image"
        case answers //= "answers"
    }
}
