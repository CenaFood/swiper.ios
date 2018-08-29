//
//  StatisticsPageViewController.swift
//  cena
//
//  Created by Thibault Gagnaux on 21.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import UICircularProgressRing
import PromiseKit

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
        
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
//            setViewControllers([firstVC], direction: .forward, animated: true) { _ in
//                firstVC.progressViewController?.startRingAnimation()
//        }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func getProjectStat(stats: [Stats]) -> Stats? {
        for stat in stats {
            if stat.projectName == classConstants.projectName {
                return stat
            }
        }
        return nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("We are at index \(currentIndex!)")
//        if let yourContribution = pages[currentIndex] as? ProgressContainerViewController {
//            print("Starting ring animation")
//            yourContribution.progressViewController?.startRingAnimation()
//        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let progressPage = pages[0] as? ProgressViewController
        let communityPage = pages[1] as? CommunityContributionController
        progressPage?.resetProgressRing(progressRing: (progressPage?.progressRing)!)
//        communityPage?.resetProgressRing(progressRing: (communityPage?.progressRing)!)
//        for page in progressPages ?? [] {
//            page.progressViewController?.resetProgressRing()
//        }
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
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished && completed {
            let currentPage = pageViewController.viewControllers?.first
            guard let index = getPageIndex(page: currentPage, pages: pages) else { return }
            currentIndex = index
            self.navigationItem.title = currentPage?.navigationItem.title
        }
    }
    
}

