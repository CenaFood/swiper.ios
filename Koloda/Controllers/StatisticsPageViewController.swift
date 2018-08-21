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
            self.getViewController(withIdentifier: "MyImpactNavigationController"),
            self.getViewController(withIdentifier: "ProjectStatusNavigationController")]
    }()

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
            return 0
        }
    }
    
extension StatisticsPageViewController: UIPageViewControllerDelegate { }

