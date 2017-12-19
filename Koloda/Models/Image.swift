//
//  Image.swift
//  Koloda_Example
//
//  Created by Thibault Gagnaux on 08.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

class Image: Codable, CustomStringConvertible {
    let fileName: String
    let fileExtension: String
    let height: Int
    let width: Int
    let url: String
    
    init(fileName: String, fileExtension: String, height: Int, width: Int, url: String) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.height = height
        self.width = width
        self.url = url
    }
    
    enum CodinKeys: String, CodingKey {
        case fileName = "fileName"
        case fileExtension = "fileExtension"
        case height = "height"
        case width = "width"
        case url = "url"
    }
    
    var description: String {
        return "fileName: \(fileName) - fileExtension: \(fileExtension) - height: \(height) - width: \(width) - url: \(url)"
    }
}
