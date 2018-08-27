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
    .header1("Terms Of Service."),
    .normal("Here come our terms of services")]
    
    static let PrivacyPolicy = "privacy policy"
    static let PrivacyPolicyText: [AttributedTextBlock] = [
        .normal(""),
        .header1("U.S. Returns & Refunds Policy."),
        .header2("Standard Return Policy."),
        .normal("There are a few important things to keep in mind when returning a product you purchased online from Apple:"),
        .list("You have 14 calendar days to return an item from the date you received it."),
        .list("Only items that have been purchased directly from Apple, either online or at an Apple Retail Store, can be returned to Apple. Apple products purchased through other retailers must be returned in accordance with their respective returns and refunds policy."),
        .list("Please ensure that the item you're returning is repackaged with all the cords, adapters and documentation that were included when you received it."),
        .normal("There are some items, however, that are ineligible for return, including:"),
        .list("Opened software"),
        .list("Electronic Software Downloads"),
        .list("Software Up-to-Date Program Products (software upgrades)"),
        .list("Apple Store Gift Cards"),
        .list("Apple Developer products (membership, technical support incidents, WWDC tickets)"),
        .list("Apple Print Products"),
        .normal("*You can return software, provided that it has not been installed on any computer. Software that contains a printed software license may not be returned if the seal or sticker on the software media packaging is broken.")]
    
    static let legalTypeToText = [PrivacyPolicy: PrivacyPolicyText, TermsOfService: TermsOfServiceText]
    
    static let TermsAndPrivacyRegex = "\\sterms\\sof\\sservice|\\sprivacy\\spolicy"
}

struct AppleColors {
    static let blue: UIColor = UIColor(named: "tealBlue") ?? .blue
    static let pink: UIColor = UIColor(named: "pink") ?? .purple
}
