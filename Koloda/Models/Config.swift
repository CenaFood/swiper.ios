//
//  Config.swift
//  cena
//
//  Created by Thibault Gagnaux on 25.06.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import RLBAlertsPickers

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
    static let TermsOfServiceText: [AttributedTextBlock] = [
    .normal(""),
    .header1("Terms Of Service"),
    .normal("Here come our terms of services")]
    
    static let PrivacyPolicy = "privacy policy"
    static let PrivacyPolicyText: [AttributedTextBlock] = [
        .normal(""),
        .header1("Privacy Policy"),
        .normal("Here comes our privacy policy")]
    
    static let legalTypeToText = [PrivacyPolicy: PrivacyPolicyText, TermsOfService: TermsOfServiceText]
    
    static let TermsAndPrivacyRegex = "\\sterms\\sof\\sservice|\\sprivacy\\spolicy"
}

struct AppleColors {
    static let blue: UIColor = UIColor(named: "tealBlue") ?? .blue
    static let pink: UIColor = UIColor(named: "pink") ?? .purple
    static let orange: UIColor = UIColor(named: "orange") ?? .orange
    static let red: UIColor = UIColor(named: "red") ?? .red
    static let green: UIColor = UIColor(named: "green") ?? .green
}
