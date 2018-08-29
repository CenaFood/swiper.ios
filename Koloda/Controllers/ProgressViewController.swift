 //
//  ProgressViewController.swift
//  cena
//
//  Created by Thibault Gagnaux on 26.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import UICircularProgressRing
import SwiftEntryKit
import PromiseKit

struct classConstants {
    static let maxValue = 100
    static let minValue = 0
    static let swipesCount = 60
    static let swipesTarget = 1000
    static let ringStyle: UICircularProgressRingStyle = .ontop
    static let font: UIFont = .preferredFont(forTextStyle: .largeTitle)
    static let projectName = "cena"
}


protocol ProgressRingProtocol: class {
    var progressRing: UICircularProgressRing! { get }
    var value: Int { get }
    var minValue: Int { get }
    var maxValue: Int { get }
    var ringStyle: UICircularProgressRingStyle { get }
    var font: UIFont { get }
    var color: UIColor { get }
    var swipesCount: Int { get set }
    var swipesTarget: Int { get }
    var willAnimate: Bool { get set }
    
    func setupProgressRing(progressRing: UICircularProgressRing)
    func resetProgressRing()
    func calculatePercentage() -> Double
    func startRingAnimation()
    func getSwipesCount(stats: [Stats]) -> Int?
    func setSwipesCount()
    
    var notificationTitle: String { get }
    var notificationText: String { get }
    var notificationImage: UIImage? { get }
    func presentBottomFloat(title: String, description: String, image: UIImage?)
}


extension ProgressRingProtocol {
    var value: Int {
        return 0
    }
    
    var minValue: Int {
        return 0
    }
    
    var maxValue: Int {
        return 100
    }
    
    var ringStyle: UICircularProgressRingStyle {
        return .ontop
    }
    
    var font: UIFont {
        return .preferredFont(forTextStyle: .largeTitle)
    }
    
    func setupProgressRing(progressRing: UICircularProgressRing) {
        progressRing.value = UICircularProgressRing.ProgressValue(value)
        progressRing.maxValue = UICircularProgressRing.ProgressValue(maxValue)
        progressRing.minValue = UICircularProgressRing.ProgressValue(minValue)
        progressRing.ringStyle = ringStyle
        progressRing.font = font
        progressRing.innerRingColor = color
        progressRing.fontColor = color
    }
    
    func startRingAnimation() {
        guard let progressRing = progressRing else { return }
        progressRing.startProgress(to: UICircularProgressRing.ProgressValue(calculatePercentage()), duration: 2) {
            self.presentBottomFloat(title: self.notificationTitle, description: self.notificationText, image: self.notificationImage)
        }
    }
    
    func resetProgressRing() {
        guard let progressRing = progressRing else { return }
        progressRing.resetProgress()
    }
    
    
    func calculatePercentage() -> Double {
        return Double(swipesCount) / Double(swipesTarget) * 100
    }
    
    func presentBottomFloat(title: String, description: String, image: UIImage?) {
        var attributes = EKAttributes.bottomNote
        Util.setupAttribute(attributes: &attributes, color: color)
        let contentView = Util.createNotification(title: title, description: description, image: image)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}

//extension ProgressViewController {
//}

class ProgressViewController: UIViewController, ProgressRingProtocol {
    
    
    
    
    var willAnimate: Bool = true
    

    // MARK: Properties
    
    var swipesCount: Int = 0 {
        didSet { startRingAnimation() }
    }
    
    var color: UIColor {
        get { return AppleColors.blue }
    }
    
    var swipesTarget: Int {
        return 400
    }
    
    let notificationTitle: String = "You're Awesome"
    
    var notificationText: String {
        var remainingSwipes = (swipesTarget - swipesCount)
        if remainingSwipes < 0 {
            remainingSwipes = 0
        }
        return "You have already swiped \(swipesCount) meals. Only \(remainingSwipes) swipes remaining!"
    }
    
    var notificationImage: UIImage? {
        return nil
    }
    
    
    
    @IBOutlet weak var progressRing: UICircularProgressRing!
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressRing(progressRing: self.progressRing)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !progressRing.isAnimating {
            progressRing.continueProgress()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if willAnimate {
            setSwipesCount()
            willAnimate = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if progressRing.isAnimating {
            progressRing.pauseProgress()
        }
    }
    
    // Private functions
    
    
    func setSwipesCount() {
            let backgroundQueue = DispatchQueue.global(qos: .background)
            backgroundQueue.async {
                firstly {
                    CenaAPI().getStats()
                    }.done { projectStats -> Void in
                        if let swipesCount = self.getSwipesCount(stats: projectStats) {
                            self.swipesCount = swipesCount
                        }
                    }.catch { _ in
                        DispatchQueue.main.async {
                            let alert = Util.createSimpleAlert(title: "error", message: "No internet")
                                self.present(alert, animated: true)
                        }
                }
            }
    }
    
    func getSwipesCount(stats: [Stats]) -> Int? {
        for stat in stats {
            if stat.projectName == classConstants.projectName {
                return stat.personalLabelsCount
            }
        }
        return nil
    }

    @objc func reload(_ sender: UIBarButtonItem) {
        print("reload tapped")
        progressRing.value = 0
        self.startRingAnimation()
    }
    
    
}
