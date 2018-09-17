//
//  Identifier.swift
//  cena
//
//  Created by Thibault Gagnaux on 19.03.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

class Identifier: APIBase, CustomStringConvertible {
    let icloudkitid: String
    
    private enum CodingKeys: String, CodingKey {
        case icloudkitid
    }
    
    init(identifier: String) {
        self.icloudkitid = identifier
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.icloudkitid = try container.decode(String.self, forKey: .icloudkitid)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(icloudkitid, forKey: .icloudkitid)
    }
    
    var description: String {
        return "icloudkitid: \(icloudkitid)"
    }
}
