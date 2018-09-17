//
//  ProgressRingProtocol.swift
//  cena
//
//  Created by Thibault Gagnaux on 31.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UICircularProgressRing
import SwiftEntryKit

protocol ProgressProtocol: class {
    func getUserSwipesCount() -> Int
    
    func getCommunitySwipesCount() -> Int
    
    func getCurrentDiscoverLevel() -> Int
    
    func saveUserSwipesCount(count: Int)
    
    func saveCommunitySwipesCount(count: Int)
    
    func saveCurrentDiscoverLevel(level: Int)
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
    var progressDescription: UILabel! { get set }
    var percentage: Double { get }
    
    func setupProgressRing()
    func resetProgressRing()
    func prepareProgressRingForAnimation()
    func startNormalAnimation()
    func setupProgressDescription(text: String)
    
    var notificationText: String { get }
}


extension ProgressRingProtocol {
    var value: Int {
        return swipesCount
    }
    
    var minValue: Int {
        return 0
    }
    
    var maxValue: Int {
        return swipesCount > swipesTarget ? swipesCount : swipesTarget
    }
    
    var ringStyle: UICircularProgressRingStyle {
        return .ontop
    }
    
    var font: UIFont {
        return .preferredFont(forTextStyle: .title1)
    }
    
    var percentage: Double {
        return Double(swipesCount) / Double(swipesTarget) * 100
    }
    
    func setupProgressRing() {
        progressRing.maxValue = UICircularProgressRing.ProgressValue(maxValue)
        progressRing.minValue = UICircularProgressRing.ProgressValue(minValue)
        progressRing.ringStyle = ringStyle
        progressRing.font = font
        progressRing.innerRingColor = color
        progressRing.fontColor = color
        progressRing.valueIndicator = " Swipes \n of \(swipesTarget)"
    }
    
    func startNormalAnimation() {
        guard let progressRing = progressRing else { return }
        progressRing.startProgress(to: UICircularProgressRing.ProgressValue(swipesCount), duration: 2) {
            UIView.animate(withDuration: 2.0, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.progressDescription.text = self.notificationText
                self.progressDescription.alpha = 1.0
            })
        }
    }
    
    func resetProgressRing() {
        guard let progressRing = progressRing else { return }
        progressRing.resetProgress()
        prepareProgressRingForAnimation()
    }
    
    func prepareProgressRingForAnimation() {
        guard (progressRing) != nil else { return }
        setupProgressRing()
        progressDescription.alpha = 0.0
    }
    
    func setupProgressDescription(text: String) {
        progressDescription.numberOfLines = 0
        progressDescription.font = UIFont.preferredFont(forTextStyle: .body)
        progressDescription.alpha = 0.0
        progressDescription.text = text
    }
}

extension ProgressProtocol {
    
    func getUserSwipesCount() -> Int {
        return UserDefaults.standard.value(forKey: ProgressKeyConstants.UserSwipesCount) as? Int ?? 0
    }
    
    func getCommunitySwipesCount() -> Int {
        return UserDefaults.standard.value(forKey: ProgressKeyConstants.CommunitySwipesCount) as? Int ?? 0
    }
    
    func getCurrentDiscoverLevel() -> Int {
        return UserDefaults.standard.value(forKey: ProgressKeyConstants.CurrentDiscoveryLevel) as? Int ?? 0
    }
    
    func saveUserSwipesCount(count: Int) {
        UserDefaults.standard.setValue(count, forKey: ProgressKeyConstants.UserSwipesCount)
    }
    
    func saveCommunitySwipesCount(count: Int) {
        UserDefaults.standard.setValue(count, forKey: ProgressKeyConstants.CommunitySwipesCount)
    }
    
    func saveCurrentDiscoverLevel(level: Int) {
        UserDefaults.standard.setValue(level, forKey: ProgressKeyConstants.CurrentDiscoveryLevel)
    }
}

