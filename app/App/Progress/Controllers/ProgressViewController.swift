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
import LTMorphingLabel

struct classConstants {
    static let projectName = "cena"
}

class ProgressViewController: UIViewController, ProgressRingProtocol, UICircularProgressRingDelegate, ProgressProtocol {
    
    // MARK: Properties
    var willAnimate: Bool = true
    var swipesCount: Int = 0
    
    // MARK: IBOutlets
    @IBOutlet weak var rankName: LTMorphingLabel!
    @IBOutlet weak var progressRing: UICircularProgressRing!
    @IBOutlet weak var progressDescription: UILabel!
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressRing.delegate = self
        setupRankName()
        setupProgressDescription(text: progressText[currentLevel])
        
        UserDefaults.standard.addObserver(self, forKeyPath: ProgressKeyConstants.UserSwipesCount, options: NSKeyValueObservingOptions.new, context: nil)
        swipesCount = getUserSwipesCount()
        resetProgressRing()
        startRingAnimaton()
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: ProgressKeyConstants.UserSwipesCount)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if willAnimate {
            updateSwipesCount()
            prepareProgressRingForAnimation()
            DispatchQueue.main.async {
                self.startRingAnimaton()
            }
            willAnimate = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !progressRing.isAnimating {
            progressRing.continueProgress()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if progressRing.isAnimating {
            progressRing.pauseProgress()
        }
    }
    
    // MARK: Private methods
    func setupRankName() {
        rankName.morphingEnabled = false
        rankName.text = levelText[currentLevel]
        rankName.numberOfLines = 1
        rankName.morphingDuration = 2
        rankName.morphingEffect = .scale
        rankName.font = UIFont.preferredFont(forTextStyle: .title1)
    }
    
    func updateSwipesCount() {
        swipesCount = getUserSwipesCount()
    }
}
 
 extension ProgressViewController {
    
    var color: UIColor {
        get { return AppleColors.orange }
    }
    
    var levelUpColor: UIColor {
        return AppleColors.green
    }
    
    var swipesTarget: Int {
        return 400
    }
    
    var notificationText: String {
        return progressText[currentLevel]
    }
    
    
    var currentLevel: Int {
        return UserDefaults.standard.value(forKey: ProgressKeyConstants.CurrentUserLevel) as? Int ?? 0
    }
    
    var level: Int {
        switch percentage {
        case 0..<5:
            return 0
        case 5..<40:
            return 1
        case 40..<80:
            return 2
        case 80..<100:
            return 3
        case 100..<200:
            return 4
        case 200..<300:
            return 5
        default:
            return currentLevel
        }
    }
    
    var levelText: [String] {
        return ["Beginner", "Junior Swiper", "Senior Swiper", "Master Swiper", "Top Swiper", "Meta"]
    }
    
    var swipedMealsInfo: String {
        return "You have already swiped \(swipesCount) meals."
    }
    
    var progressText: [String] {
        return ["Hello newcomer! \(swipedMealsInfo) Keep going because the time will never be just right.", "Hello Junior! \(swipedMealsInfo) You are doing very well. Hang in there and don't give up swiping.", "Hello Senior! \(swipedMealsInfo) You definitely know how to swipe that finger.", "Hello Master! \(swipedMealsInfo) You're awesome and so close to the goal.", "Hello Top Swiper! \(swipedMealsInfo) Congratulations, you have reached the goal! Thank you.", "Hello meta! \(swipedMealsInfo) That is twice as much as you needed. You are a true hero and we will be forever in your debt!"]
    }
    
    func willDisplayLabel(for ring: UICircularProgressRing, _ label: UILabel) {
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
    }
    
    func startRingAnimaton() {
        if currentLevel < level {
            UserDefaults.standard.set(level, forKey: ProgressKeyConstants.CurrentUserLevel)
            DispatchQueue.main.async {
                self.startLevelUpAnimation()
            }
        } else {
            DispatchQueue.main.async {
                self.startNormalAnimation()
            }
        }
    }
    
    func startLevelUpAnimation() {
        guard let progressRing = progressRing else { return }
        self.rankName.morphingEnabled = true
            progressRing.startProgress(to: UICircularProgressRing.ProgressValue(swipesCount), duration: 2) {
            self.rankName.text = self.levelText[self.level]
            self.progressRing.pulsate()
            UIView.animate(withDuration: 2.0, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.progressDescription.text = self.progressText[self.currentLevel]
                self.progressDescription.alpha = 1.0
                self.progressRing.innerRingColor = self.levelUpColor
                self.progressRing.fontColor = self.levelUpColor
                self.progressRing.valueIndicator = " Swipes\nLevel Up"
            })
        }
    }
 }

 extension UICircularProgressRing {
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.98
        pulse.toValue = 1.05
        pulse.autoreverses = false
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 1
        
        layer.add(pulse, forKey: nil)
    }
 }
