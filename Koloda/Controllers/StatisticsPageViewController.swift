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
import SwiftEntryKit

struct pageNames {
    static let YourContribution = "Your Contribution"
    static let CommunityContribution = "Community Contribution"
}

class StatisticsPageViewController: UIPageViewController {
    
    // MARK: Properties
    
    weak var customPageControlDelegate: CustomPageControlDelegate?
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        customPageControlDelegate?.didUpadtePageCount(viewController: self, newPageCount: pages.count)
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    @objc func reload() {
        guard let currentPage = pages[currentIndex] as? ProgressRingProtocol else { return }
        if let communityPage = pages[currentIndex] as? CommunityContributionController {
            communityPage.setSwipesCount()
        } else {
            currentPage.resetProgressRing()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            currentPage.startNormalAnimation()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for page in self.pages {
            guard let page = page as? ProgressRingProtocol else { return }
            page.willAnimate = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
            customPageControlDelegate?.didUpdatePageIndex(viewController: self, newPageIndex: currentIndex)
            self.navigationItem.title = currentPage?.navigationItem.title
        }
    }
}

protocol CustomPageControlDelegate: class {
    func didUpadtePageCount(viewController: UIViewController, newPageCount: Int)
    func didUpdatePageIndex(viewController: UIViewController, newPageIndex: Int)
}

