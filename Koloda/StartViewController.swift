//
//  StartViewController.swift
//  Koloda_Example
//
//  Created by Thibault Gagnaux on 20.10.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

import UIKit

let numberOfMeals : Int = 5

class StartViewController: UIViewController {
    @IBOutlet weak var startView: UIImageView!
    
    fileprivate var dataSource: [UIImage] = {
        var array: [UIImage] = []
        for index in 0..<numberOfMeals {
            array.append(UIImage(named: "startMeal\(index + 1)")!)
        }
        
        return array
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let randIndex : Int = Int(arc4random_uniform(UInt32(numberOfMeals)))
        print("index is \(randIndex)")
        startView.image = dataSource[randIndex]
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    

}

