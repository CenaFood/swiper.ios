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
    
    override func viewDidLoad() {
        self.progressRing.maxValue = 100
        self.progressRing.innerRingColor = UIColor.blue
    }
    
    @IBAction func startAnimation(_ sender: UIButton) {
        self.progressRing.startProgress(to: 74, duration: 6)
    }
}
