//
//  AboutUsIntroViewController.swift
//  cena
//
//  Created by Thibault Gagnaux on 09.09.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class AboutUsIntroViewController: UIViewController {
    @IBOutlet weak var contactButton: UIButton!
    override func viewDidLoad() {
        contactButton.layer.cornerRadius = 8
    }
}
