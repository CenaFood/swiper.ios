//
//  ProgressContainerViewController.swift
//  cena
//
//  Created by Thibault Gagnaux on 26.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

public class ProgressContainerViewController: UIViewController {
    var progressViewController: ProgressViewController?
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let viewController = segue.destination as? ProgressViewController else { return }
        progressViewController = viewController
    }
    
    
}
