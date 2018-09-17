//
//  Config.swift
//  cena
//
//  Created by Thibault Gagnaux on 25.06.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

struct DummyUser {
    static let FirstName = "John"
    static let LastName = "Dee"
    static let Email = "ios@simulator.ch"
    static let Password = "johndummyDee1"
    static let userID = "6A1BA20A-8D25-4E71-8BD8-E6872FD53ADA"
    static var JWTToken = ""
}

struct Legal {
    static let TermsOfService = "terms of service"
    static let PrivacyPolicy = "privacy policy"
    static let TermsOfServicesRegex = "\\sterms\\sof\\sservice"
    static let PrivacyPolicyRegex = "\\sprivacy\\spolicy"
    static let PrivacyPolicyWebsite = "https://cenafood.github.io/website/privacy_policy"
}

struct AppleColors {
    static let blue: UIColor = UIColor(named: "tealBlue") ?? .blue
    static let pink: UIColor = UIColor(named: "pink") ?? .purple
    static let orange: UIColor = UIColor(named: "orange") ?? .orange
    static let red: UIColor = UIColor(named: "red") ?? .red
    static let green: UIColor = UIColor(named: "green") ?? .green
}

struct ProgressKeyConstants {
    static let UserSwipesCount = "userSwipesCount"
    static let CommunitySwipesCount = "communitySwipesCount"
    static let CurrentDiscoveryLevel = "currentDiscoveryLevel"
    static let CurrentUserLevel = "currentUserLevel"
}
