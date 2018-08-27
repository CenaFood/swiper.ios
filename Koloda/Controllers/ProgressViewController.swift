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

struct classConstants {
    static let maxValue = 100
    static let minValue = 0
    static let swipesCount = 60
    static let swipesTarget = 100
    static let ringStyle: UICircularProgressRingStyle = .ontop
    static let font: UIFont = .preferredFont(forTextStyle: .largeTitle)
}

protocol Progress {
    var innerRingColor: UIColor? { get }
//    var outerRingColor: UIColor { get set }
//    var fontColor: UIColor {get set }
//    var swipesCount: Int { get set }
}

class ProgressViewController: UIViewController{
    @IBOutlet weak var progressRing: UICircularProgressRing!
    fileprivate var willAnimate: Bool = true
    var color = UIColor(named: "tealBlue")!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressRing.value = 20
        self.progressRing.maxValue = UICircularProgressRing.ProgressValue(classConstants.maxValue)
        self.progressRing.minValue = UICircularProgressRing.ProgressValue(classConstants.minValue)
        self.progressRing.ringStyle = classConstants.ringStyle
        self.progressRing.font = classConstants.font
    }
    
    func resetProgressRing() {
        progressRing.resetProgress()
        willAnimate = true
    }
    
    func setRingColor(color: UIColor) {
        progressRing.innerRingColor = color
        progressRing.fontColor = color
        self.color = color
    }
    
    func startRingAnimation() {
        if willAnimate {
            progressRing.startProgress(to: UICircularProgressRing.ProgressValue(classConstants.swipesCount), duration: 2) {
                let remainingSwipes = classConstants.swipesTarget - classConstants.swipesCount
                let descriptionText = "You have already swiped \(classConstants.swipesCount) meals. Only \(remainingSwipes) swipes remaining! You're awesome!"
                self.presentBottomFloat(descriptionText: descriptionText)
                self.willAnimate = false
            }
        }
    }
    
    private func presentBottomFloat(descriptionText: String) {
        var attributes = EKAttributes.bottomNote
        //            attributes.entryBackground = .gradient(gradient: .init(colors: [.red, .green], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.entryBackground = .color(color: color)
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.displayDuration = 5
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.positionConstraints.maxSize = .init(width: .intrinsic, height: .intrinsic)
        
        let title = EKProperty.LabelContent(text: "On Fire", style: .init(font: .preferredFont(forTextStyle: .headline), color: .white))
        let description = EKProperty.LabelContent(text: descriptionText, style: .init(font: .preferredFont(forTextStyle: .body), color: .white))
        let image = EKProperty.ImageContent(image: UIImage(named: "fire")!, size: CGSize(width: 16, height: 20))
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
