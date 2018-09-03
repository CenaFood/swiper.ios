//
//  Stats.swift
//  cena
//
//  Created by Thibault Gagnaux on 27.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

class Stats: Codable, CustomStringConvertible {
    let projectName: String
    let labelCount: Int
    let personalLabelsCount: Int
    
    var description: String {
        return "projectName: \(projectName) - labelCount: \(labelCount) - personalLabelsCount: \(personalLabelsCount)"
    }
    
    init(projectName: String, labelCount: Int, personalLabelsCount: Int) {
        self.projectName = projectName
        self.labelCount = labelCount
        self.personalLabelsCount = personalLabelsCount
    }
}
