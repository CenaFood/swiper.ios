//
//  CustomOverlayView.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/27/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda

private let overlayRightImageName = "overlay_like"
private let overlayLeftImageName = "overlay_skip"
private let overlayNoFood = "overlay_no_food"

class CustomOverlayView: OverlayView {

    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        var imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        return imageView
        }()
    
    override var overlayState: SwipeResultDirection?  {
        didSet {
            switch overlayState {
            case .left? :
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .up? :
                overlayImageView.image = UIImage(named: overlayNoFood)
            case .right? :
                overlayImageView.image = UIImage(named: overlayRightImageName)
            case .down? :
                overlayImageView.image = UIImage(named: overlayNoFood)
            default:
                overlayImageView.image = nil
            }
            
        }
    }

}
