//
//  ChallengeDTO.swift
//  Koloda_Example
//
//  Created by Thibault Gagnaux on 08.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

class challenge: Codable {
    let id: String
    let projectID: String
    let type: String
    let description: String
    let image: IImage
    let answers: [String]
    //let test = "https://scontent-amt2-1.cdninstagram.com/t51.2885-15/e35/23825329_702402206622090_500261469762355200_n.jpg";
}
    

