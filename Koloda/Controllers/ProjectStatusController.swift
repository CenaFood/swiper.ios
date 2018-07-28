//
//  ProjectStatusController.swift
//  cena
//
//  Created by Thibault Gagnaux on 25.07.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class ProjectStatusController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    let eatFitController = EatFitViewController()
    
    let objects: [ChartObject] = {
        var objects: [ChartObject] = []
        
        let filePath = Bundle.main.path(forResource: "Objects", ofType: "plist")
        let contents = NSArray(contentsOfFile: filePath!)! as Array
        
        for dictionary in contents {
            let color = UIColor(hexString: dictionary["color"] as! String)
            let percentage = dictionary["percentage"] as! Int
            let title = dictionary["title"] as! String
            let description = dictionary["description"] as! String
            let logoName = dictionary["logoName"] as! String
            let logoImage = UIImage(named: logoName)!
            let object = ChartObject(color: color, percentage: percentage, title: title, description: description, logoImage: logoImage)
            
            objects.append(object)
        }
        
        return objects
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eatFitController.dataSource = self
        eatFitController.view.frame = stackView.frame
        addChildViewController(eatFitController)
        eatFitController.view.backgroundColor = .black
        stackView.yal_addSubview(eatFitController.view, options: .overlay)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eatFitController.reloadData()
    }
}

extension ProjectStatusController: EatFitViewControllerDataSource {
    
    func numberOfPagesForPagingViewController(_ controller: EatFitViewController) -> Int {
        return objects.count
    }
    
    func chartColorForPage(_ index: Int, forPagingViewController: EatFitViewController) -> UIColor {
        return objects[index].color
    }
    
    func percentageForPage(_ index: Int, forPagingViewController: EatFitViewController) -> Int {
        return objects[index].percentage
    }
    
    func titleForPage(_ index: Int, forPagingViewController: EatFitViewController) -> String {
        return objects[index].title
    }
    
    func descriptionForPage(_ index: Int, forPagingViewController: EatFitViewController) -> String {
        return objects[index].description
    }
    
    func logoForPage(_ index: Int, forPagingViewController: EatFitViewController) -> UIImage {
        return objects[index].logoImage
    }
    
    func chartThicknessForPagingViewController(_ controller: EatFitViewController) -> CGFloat {
        return 15
    }
}

