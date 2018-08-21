//
//  StatisticsPageViewController.swift
//  cena
//
//  Created by Thibault Gagnaux on 21.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class StatisticsPageViewController: UIPageViewController {
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "MyImpactController"),
            self.getViewController(withIdentifier: "ProjectStatusController")]
    }()
    
    fileprivate var currentIndex: Int!

    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
    
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let myImpactViewController = pages.first as? MyImpactViewController {
            print("My Impact Tab view has appeared")
            myImpactViewController.progressRing.startProgress(to: 49, duration: 3)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let myImpactViewController = pages.first as? MyImpactViewController {
            myImpactViewController.progressRing.resetProgress()
        }
    }
}
    
    extension StatisticsPageViewController: UIPageViewControllerDataSource {
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = pages.index(of: viewController) else {
                return nil
            }
            return index > 0 ? pages[index - 1] : nil
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = pages.index(of: viewController) else {
                return nil
            }
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
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let myImpactViewController = pendingViewControllers.first as? MyImpactViewController {
            myImpactViewController.navigationController?.navigationBar.topItem?.title = "My Impact"
        }
    }
    
}

