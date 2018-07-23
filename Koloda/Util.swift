//
//  util.swift
//  cena
//
//  Created by Thibault Gagnaux on 23.07.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class Util {

static func createSimpleAlert(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: "Connection Error", message: message,
                                  preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(okAction)
    return alert
}

}
