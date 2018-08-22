//
//  MyImpactViewController.swift
//  cena
//
//  Created by Thibault Gagnaux on 21.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import UICircularProgressRing

class MyImpactViewController: UIViewController {
    @IBOutlet weak var progressRing: UICircularProgressRing!
    @IBOutlet weak var swipesText: UILabel!
    
    override func viewDidLoad() {
        self.progressRing.maxValue = 500
        self.progressRing.minValue = 0
        self.progressRing.ringStyle = .ontop
        self.progressRing.font = .boldSystemFont(ofSize: 34)
    }
    
    @IBAction func startAnimation(_ sender: UIButton) {
        self.progressRing.startProgress(to: 74, duration: 6)
    }
}
