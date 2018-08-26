//
//  StatisticsPageViewController.swift
//  cena
//
//  Created by Thibault Gagnaux on 21.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import UICircularProgressRing

struct pageNames {
    static let YourContribution = "Your Contribution"
    static let CommunityContribution = "Community Contribution"
}

class StatisticsPageViewController: UIPageViewController {
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: pageNames.YourContribution),
            self.getViewController(withIdentifier: pageNames.CommunityContribution)]
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
        
        if let firstVC = pages.first as? YourContributionController {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
//            setViewControllers([firstVC], direction: .forward, animated: true) { completed in
//                if completed { firstVC.resetProgressRing() }
//            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let yourContribution = pages.first as? YourContributionController {
            yourContribution.startRingAnimation()
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let yourContribution = pages.first as? YourContributionController {
            yourContribution.resetProgressRing()
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
        if let myImpactViewController = page as? YourContributionController {
            return myImpactViewController
        } else if let projectStatusViewController = page as? CommunityContributionController {
            return projectStatusViewController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        let nextViewController = pendingViewControllers.first
//        guard let nextIndex = getPageIndex(page: nextViewController, pages: pages) else { return }
//        nextViewController?.navigationController?.navigationBar.topItem?.title = classConstants.ControllerNames[currentIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished && completed {
            let currentPage = pageViewController.viewControllers?.first
            guard let index = getPageIndex(page: currentPage, pages: pages) else { return }
            currentIndex = index
            self.navigationItem.title = currentPage?.navigationItem.title
        }
    }
    
}

