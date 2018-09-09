//
//  ProgressRingProtocol.swift
//  cena
//
//  Created by Thibault Gagnaux on 31.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UICircularProgressRing
import SwiftEntryKit

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
    
    func setupProgressRing()
    func resetProgressRing()
    func calculatePercentage() -> Double
    func startRingAnimation()
    func getSwipesCount(stats: [Stats]) -> Int?
    func setSwipesCount()
    func setupProgressDescription(text: String)
    
    var notificationText: String { get }
}


extension ProgressRingProtocol {
    var value: Int {
        return 0
    }
    
    var minValue: Int {
        return 0
    }
    
    var maxValue: Int {
        return swipesCount < swipesTarget ? swipesTarget: swipesCount
    }
    
    var ringStyle: UICircularProgressRingStyle {
        return .ontop
    }
    
    var font: UIFont {
        return .preferredFont(forTextStyle: .title1)
    }
    
    func setupProgressRing() {
        progressRing.value = UICircularProgressRing.ProgressValue(value)
        progressRing.maxValue = UICircularProgressRing.ProgressValue(maxValue)
        progressRing.minValue = UICircularProgressRing.ProgressValue(minValue)
        progressRing.ringStyle = ringStyle
        progressRing.font = font
        progressRing.innerRingColor = color
        progressRing.fontColor = color
        progressRing.valueIndicator = " Swipes \n of \(swipesTarget)"
    }
    
    func startRingAnimation() {
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
        setupProgressRing()
        progressDescription.alpha = 0.0
    }
    
    
    func calculatePercentage() -> Double {
        print(Double(swipesCount) / Double(swipesTarget) * 100)
        return Double(swipesCount) / Double(swipesTarget) * 100
    }
    
    
    
    func setupProgressDescription(text: String) {
        progressDescription.numberOfLines = 0
        progressDescription.font = UIFont.preferredFont(forTextStyle: .body)
        progressDescription.alpha = 0.0
        progressDescription.text = text
    }
}

