//
//  MyImpactViewController.swift
//  cena
//
//  Created by Thibault Gagnaux on 21.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import UICircularProgressRing
import SwiftEntryKit

struct classConstants {
    static let swipesCount = 60
    static let swipesTarget = 100
}

class YourContributionController: UIViewController {
    @IBOutlet weak var progressRing: UICircularProgressRing!
    @IBOutlet weak var swipesText: UILabel!
    
    override func viewDidLoad() {
        self.progressRing.value = 0
        self.progressRing.maxValue = 100
        self.progressRing.minValue = 0
        self.progressRing.ringStyle = .ontop
        self.progressRing.font = .boldSystemFont(ofSize: 34)
    }

    
    @IBAction func startAnimation(_ sender: UIButton) {
        startRingAnimation()
    }
    
    func resetProgressRing() {
        progressRing.resetProgress()
    }
    
    func startRingAnimation() {
        progressRing.startProgress(to: UICircularProgressRing.ProgressValue(classConstants.swipesCount), duration: 2) {
            let remainingSwipes = classConstants.swipesTarget - classConstants.swipesCount
            let descriptionText = "You have already swiped \(classConstants.swipesCount) meals. Only \(remainingSwipes) swipes remaining! You're awesome!"
            self.presentBottomFloat(descriptionText: descriptionText)
        }
    }
        
    private func presentBottomFloat(descriptionText: String) {
            var attributes = EKAttributes.bottomNote
            //            attributes.entryBackground = .gradient(gradient: .init(colors: [.red, .green], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
            attributes.entryBackground = .color(color: UIColor(named: "tealBlue")!)
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
