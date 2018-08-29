//
//  ProjectStatusViewController.swift
//  cena
//
//  Created by Thibault Gagnaux on 22.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import UICircularProgressRing
import PromiseKit

extension CommunityContributionController {
    var color: UIColor {
        return AppleColors.pink
    }
    
    var swipesTarget: Int {
        return 100000
    }
    
    var notificationTitle: String {
        return "Together We Are Strong"
    }
    
    var notificationText: String {
        var remainingSwipes = (swipesTarget - swipesCount)
        if remainingSwipes < 0 {
            remainingSwipes = 0
        }
        return "The community has already swiped \(swipesCount) meals! Only \(remainingSwipes) swipes remaining to reach our goal."
    }
    
    var notificationImage: UIImage? {
        return nil
    }
    
    func getSwipesCount(stats: [Stats]) -> Int? {
        for stat in stats {
            if stat.projectName == classConstants.projectName {
                return stat.labelCount
            }
        }
        return nil
    }
}

class CommunityContributionController: UIViewController, ProgressRingProtocol, NotificationProtocol {
    
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

    
    
    @IBOutlet weak var progressRing: UICircularProgressRing!
    
    
    
    var swipesCount: Int = 0 {
        didSet { startRingAnimation(progressRing: progressRing) }
    }
    
    func startRingAnimation(progressRing: UICircularProgressRing?) {
        guard let progressRing = progressRing else { return }
        progressRing.startProgress(to: UICircularProgressRing.ProgressValue(calculatePercentage()), duration: 2) {
            self.presentBottomFloat(title: self.notificationTitle, description: self.notificationText, image: self.notificationImage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Trying to load community controller")
        setupProgressRing(progressRing: progressRing)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSwipesCount()
    }
}


