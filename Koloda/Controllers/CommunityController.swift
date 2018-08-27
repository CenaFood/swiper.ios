//
//  CommunityController.swift
//  cena
//
//  Created by Thibault Gagnaux on 27.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class CommunityController: ProgressViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor(named: "pink") ?? .purple
        self.setRingColor(color: color)
        self.progressRing.value = 1
    }
}
