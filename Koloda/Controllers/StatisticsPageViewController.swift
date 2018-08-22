//
//  StatisticsPageViewController.swift
//  cena
//
//  Created by Thibault Gagnaux on 21.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import UICircularProgressRing

struct classConstants {
    static let ControllerNames: [String] = ["My Contribution", "Project Status"]
    static let swipesCount = 80.0
    static let swipesTarget = 500.0
}

class StatisticsPageViewController: UIPageViewController {
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: classConstants.ControllerNames[0]),
            self.getViewController(withIdentifier: classConstants.ControllerNames[1])]
    }()
    
    fileprivate var currentIndex: Int!

    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        currentIndex = 0
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let myContribution = pages[0] as? MyImpactViewController {
            myContribution.progressRing.startProgress(to: UICircularProgressRing.ProgressValue(classConstants.swipesCount / classConstants.swipesTarget * 100), duration: 2) {
                let remainingSwipes = classConstants.swipesTarget - classConstants.swipesCount
                myContribution.swipesText.text = "You have already swiped \(classConstants.swipesCount) meals. Only \(remainingSwipes) swipes remaining! You're awesome!"
//                myContribution.progressRing.innerRingColor = .yellow
//                myContribution.progressRing.startAngle = 90
//                myContribution.progressRing.value = 0
//                myContribution.progressRing.startProgress(to: 50, duration: 8)
            }
        }
    }
    
}
    
    extension StatisticsPageViewController: UIPageViewControllerDataSource {
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = getPageIndex(page: viewController, pages: pages) else { return nil }
            return index > 0 ? pages[index - 1] : nil
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = getPageIndex(page: viewController, pages: pages) else { return nil }
            return index + 1 < pages.count ? pages[index + 1] : nil
        }
        
        func presentationCount(for pageViewController: UIPageViewController) -> Int {
            return pages.count
        }
        
        func presentationIndex(for pageViewController: UIPageViewController) -> Int {
            return currentIndex ?? 0
        }
    }
    
extension StatisticsPageViewController: UIPageViewControllerDelegate {
    
    private func getPageIndex(page: UIViewController?, pages: [UIViewController]) -> Int? {
        return pages.index(where: {$0 == page })
    }
    
    private func getPage(page: UIViewController?) -> UIViewController? {
        if let myImpactViewController = page as? MyImpactViewController {
            return myImpactViewController
        } else if let projectStatusViewController = page as? ProjectStatusViewController {
            return projectStatusViewController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let nextViewController = pendingViewControllers.first
        guard let nextIndex = getPageIndex(page: nextViewController, pages: pages) else { return }
        currentIndex = nextIndex
        nextViewController?.navigationController?.navigationBar.topItem?.title = classConstants.ControllerNames[currentIndex]
    }
    
}

