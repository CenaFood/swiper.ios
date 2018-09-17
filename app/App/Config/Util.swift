//
//  util.swift
//  cena
//
//  Created by Thibault Gagnaux on 23.07.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit

func print(_ object: Any) {
    #if DEBUG
        Swift.print(object)
    #endif
}

class Util {

    static func createSimpleAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
    
    static func noInternetConnectionAlert() -> UIAlertController {
        return Util.createSimpleAlert(title: "No Internet", message: "Make sure that airplane mode is turned off and then press the refresh button")
    }
    
    static func setupAttribute(attributes: inout EKAttributes, color: UIColor) {
        attributes.entryBackground = .color(color: color)
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.displayDuration = 5
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.positionConstraints.maxSize = .init(width: .intrinsic, height: .intrinsic)
        attributes.screenInteraction = .dismiss
    }
    
    static func createSimpleMessage(title: String, description: String, image: UIImage?) -> EKSimpleMessage {
        let title = EKProperty.LabelContent(text: title, style: .init(font: .preferredFont(forTextStyle: .headline), color: .white))
        let description = EKProperty.LabelContent(text: description, style: .init(font: .preferredFont(forTextStyle: .body), color: .white))
        if let image = image {
            let imageContent = EKProperty.ImageContent(image: image, size: CGSize(width: 16, height: 20))
            return EKSimpleMessage(image: imageContent, title: title, description: description)
        }
        return EKSimpleMessage(image: nil, title: title, description: description)
    }
    
    static func createNotification(title: String, description: String, image: UIImage?) -> EKNotificationMessageView {
        let simpleMessage = createSimpleMessage(title: title, description: description, image: image)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        return EKNotificationMessageView(with: notificationMessage)
    }
    
    static func presentBottomFloat(title: String, description: String, image: UIImage?, color: UIColor) {
        var attributes = EKAttributes.bottomNote
        Util.setupAttribute(attributes: &attributes, color: color)
        let contentView = Util.createNotification(title: title, description: description, image: image)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
