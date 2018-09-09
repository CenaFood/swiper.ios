//
//  AboutUsViewController.swift
//  cena
//
//  Created by Thibault Gagnaux on 07.09.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MessageUI

struct MailConstants {
    static let emailTitle = "Feedback"
    static let userID = AuthController().getUserId()
    static let messageBody = "We value your privacy and protect your data. Please include the following identifier in your mail to simplify our process in serving you:\n\n\(userID ?? "We could not identify you, please try again")"
    static let recipient = ["thibault.gagnaux@students.fhnw.ch"]
}

class AboutUsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var infoButton: UIButton!
    
    // MARK: Properties:
    
    
    
    @IBAction func openMail(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(MailConstants.recipient)
            mail.setSubject(MailConstants.emailTitle)
            mail.setMessageBody(MailConstants.messageBody, isHTML: false)
            present(mail, animated: true, completion: nil)
        } else {
            print("Cannot send mail")
        }
    }
}

extension AboutUsViewController {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            let alert = Util.createSimpleAlert(title: error.localizedDescription, message: "Oops, something went wrong.")
            self.present(alert, animated: true)
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
