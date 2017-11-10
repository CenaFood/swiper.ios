//
//  SignupViewController.swift
//  Koloda_Example
//
//  Created by Thibault Gagnaux on 10.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import TransitionButton

class SignupViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    @IBOutlet weak var discoverButton: TransitionButton!
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        // TODO: Accept input from autocompletion into the email field
        //self.title = "Welcome to cena"
        super.viewDidLoad()
        emailField.delegate = self
        setupEmailField()
        setupButton()
        // hide keyboard when touched outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tap(gesture: UITapGestureRecognizer) {
        emailField.resignFirstResponder()
    }
    
    
    //MARK: TextField Delegates
    
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     if !isValidEmail(testStr: emailField.text!) {
     emailField.errorMessage = "Invalid email"
     } else {
     // The error message will only disappear when we reset it to nil or empty string
     emailField.errorMessage = ""
     }
     return true
     }
     */
    
     func textFieldDidBeginEditing(_ textField: UITextField) {
        emailField.placeholder = "Please enter your email"
        emailField.title = "email"
        emailField.titleColor = .white
     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    /*
     func textFieldDidEndEditing(_ textField: UITextField) {
     if !isValidEmail(testStr: emailField.text!) {
     emailField.titleColor = UIColor(named: "red")!
     emailField.title = "Invalid email"
     } else {
     emailField.titleColor = UIColor(named: "green")!
     emailField.title = "Valid email"
     }
     dismiss(animated: true)
     }
     */
    
    
    
    //MARK: Private methods
     
     func setupEmailField() {
        emailField.placeholder = "Please enter your email"
        emailField.lineColor = .white
        emailField.selectedTitleColor = .white
        emailField.layer.cornerRadius = 8.0
        emailField.textColor = UIColor.white
        emailField.selectedLineColor = UIColor(named: "pink")!
        emailField.placeholderColor = .white
        emailField.textAlignment = .center
        emailField.errorColor = UIColor(named: "red")!
     
     }
    
    
     func setupButton() {
        discoverButton.backgroundColor = UIColor(named: "pink")!
        discoverButton.setTitle("Discover your taste", for: .normal)
        discoverButton.spinnerColor = .white
        //discoverButton.layer.cornerRadius = 8
     }
    
    @IBAction func buttonPressed(_ sender: TransitionButton) {
        emailField.resignFirstResponder()
        sender.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            //usleep(50000) // 3: Do your networking task or background work here.
            DispatchQueue.main.async(execute: { () -> Void in
                // 4: Stop the animation, here you have three options for the `animationStyle` property:
                // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                // .shake: when you want to reflect to the user that the task did not complete successfly
                // .normal
                guard let emailText = self.emailField.text, !emailText.isEmpty else {
                    sender.stopAnimation(animationStyle: .shake, completion: {
                    self.emailField.placeholder = "Invalid email"
                    })
                    return
                }
                if (!self.isValidEmail(testStr: emailText)) {
                    sender.stopAnimation(animationStyle: .shake, completion: {
                        self.emailField.titleColor = UIColor(named: "red")!
                        self.emailField.title = "Invalid email"
                    })
                } else {
                    sender.stopAnimation(animationStyle: .expand, completion: {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let backgroundAnimationViewController = storyboard.instantiateViewController(withIdentifier: "cenaSwiper")
                        self.present(backgroundAnimationViewController, animated: true, completion: nil)
                    })
                }
            })
        })
     }
     
     func isValidEmail(testStr:String) -> Bool {
     // print("validate calendar: \(testStr)")
     let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
     let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
     return emailTest.evaluate(with: testStr)
     }
}



