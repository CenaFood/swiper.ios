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
import LTMorphingLabel

extension CommunityContributionController {
    var color: UIColor {
        return AppleColors.red
    }
    
    var swipesTarget: Int {
        return 50000
    }
    
    var notificationTitle: String {
        return "Together We Are Strong"
    }
    
    var notificationText: String {
        var remainingSwipes = (swipesTarget - swipesCount)
        if remainingSwipes < 0 {
            remainingSwipes = 0
        }
        return "The community has already swiped \(swipesCount) meals! Only \(remainingSwipes) swipes remaining to reach our goal. Together we are strong!"
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

class CommunityContributionController: UIViewController, ProgressRingProtocol, UICircularProgressRingDelegate {
    

    // MARK: Properties
    var maxValue: Int = 0
    
    var swipesCount: Int = UserDefaults.standard.value(forKey: "communitySwipesCount") as? Int ?? 0 {
        didSet {
            DispatchQueue.main.async {
                self.startNormalAnimation()
            }
        }
    }
    
    var willAnimate: Bool = true
    
    // MARK: IBOutlets
    
    
    @IBOutlet weak var progressRing: UICircularProgressRing!
    @IBOutlet weak var progressDescription: UILabel!
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressRing.delegate = self
        
        setupProgressRing()
        setupProgressDescription(text: notificationText)
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
    
}

extension CommunityContributionController {
    func willDisplayLabel(for ring: UICircularProgressRing, _ label: UILabel) {
        label.numberOfLines = 0
    }
    
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
}


