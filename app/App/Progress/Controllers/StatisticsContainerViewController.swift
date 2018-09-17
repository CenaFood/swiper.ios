//
//  StatisticsContainerViewController.swift
//  cena
//
//  Created by Thibault Gagnaux on 07.09.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class StatisticsContainerViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var customPageControl: UIPageControl!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let statisticsPageViewController = segue.destination.childViewControllers.first as? StatisticsPageViewController {
            statisticsPageViewController.customPageControlDelegate = self
        }
    }
}

extension StatisticsContainerViewController: CustomPageControlDelegate {
    func didUpadtePageCount(viewController: UIViewController, newPageCount: Int) {
        customPageControl.numberOfPages = newPageCount
    }
    
    func didUpdatePageIndex(viewController: UIViewController, newPageIndex: Int) {
        customPageControl.currentPage = newPageIndex
    }
    
}
