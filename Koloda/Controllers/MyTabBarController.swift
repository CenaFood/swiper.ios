//
//  MyTabBarController.swift
//  cena
//
//  Created by Thibault Gagnaux on 21.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let myImpactController = viewController as? MyImpactViewController {
            print("My Impact Controller selected")
            myImpactController.progressRing.startProgress(to: 88, duration: 5)
        }
    }
}
