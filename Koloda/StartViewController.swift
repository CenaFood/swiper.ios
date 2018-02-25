//
//  StartViewController.swift
//  Koloda_Example
//
//  Created by Thibault Gagnaux on 20.10.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import TransitionButton
import Instructions

let numberOfMeals : Int = 5


class StartViewController: UIViewController {
    @IBOutlet weak var welcomeTitle: UILabel!
    @IBOutlet weak var startView: UIImageView!
    @IBOutlet weak var signupButton: UIButton!
    
    var coachMarksController = CoachMarksController()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        // TODO: Accept input from autocompletion into the email field
        //self.title = "Welcome to cena"
        super.viewDidLoad()
        //emailField.delegate = self
        self.navigationController?.navigationBar.tintColor = .white
        
        setupStartImage()
        signupButton.layer.cornerRadius = 8
        let size = UIFont.buttonFontSize
        let font = UIFont.systemFont(ofSize: size)
        signupButton.titleLabel?.font = font
        
        self.coachMarksController.dataSource = self
        self.coachMarksController.overlay.allowTap = true
        //setupEmailField()
        //setupButton()
        //setupTitle()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sleep(2)
        self.coachMarksController.start(on: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coachMarksController.stop(immediately: true)
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
    
    /*
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailField.title = "email"
        emailField.titleColor = .white
    }
 */
    
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
    
    func setupTitle() {
        welcomeTitle.layer.cornerRadius = 8.0
    }
    
    func setupStartImage() {
        startView.layer.cornerRadius = 8.0
        startView.clipsToBounds = true
        let startImage = UIImage(named: "start")!
         startView.image = startImage
    }
    /*
 
    func setupEmailField() {
        emailField.placeholder = "email"
        emailField.lineColor = .white
        emailField.selectedTitleColor = .white
        emailField.layer.cornerRadius = 8.0
        emailField.textColor = UIColor.white
        emailField.selectedLineColor = .white
        emailField.placeholderColor = .white
        emailField.textAlignment = .center
        emailField.errorColor = UIColor(named: "red")!
    
    }
 
 */
    
    /*
    func setupButton() {
        discoverButton.backgroundColor = UIColor(named: "pink")!
        discoverButton.setTitle("Discover your taste", for: .normal)
        //discoverButton.spinnerColor = .white
    }
    
    @IBAction func buttonPressed(_ sender: TransitionButton) {
        emailField.resignFirstResponder()
        sender.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            sleep(1) // 3: Do your networking task or background work here.
            DispatchQueue.main.async(execute: { () -> Void in
                // 4: Stop the animation, here you have three options for the `animationStyle` property:
                // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                // .shake: when you want to reflect to the user that the task did not complete successfly
                // .normal
                guard let emailText = self.emailField.text, !emailText.isEmpty else {
                    sender.stopAnimation(animationStyle: .shake, completion: {
                        self.emailField.text = "Please enter your email"
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
 
 */
}


extension StartViewController: CoachMarksControllerDataSource {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        coachViews.bodyView.hintLabel.text = "Press here to start the tutorial"
        coachViews.bodyView.nextLabel.text = "ok"
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: self.signupButton)
    }
    
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }
    
}


