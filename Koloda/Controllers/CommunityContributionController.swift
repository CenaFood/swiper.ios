//
//  ProjectStatusViewController.swift
//  cena
//
//  Created by Thibault Gagnaux on 22.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import UICircularProgressRing

class CommunityContributionController: UIViewController {
    @IBOutlet weak var progressRing: UICircularProgressRing!
    
    override func viewDidLoad() {
        self.progressRing.maxValue = 100
        self.progressRing.minValue = 0
        self.progressRing.ringStyle = .ontop
        self.progressRing.font = .boldSystemFont(ofSize: 34)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressRing.startProgress(to: UICircularProgressRing.ProgressValue(80), duration: 2)
    }
}

