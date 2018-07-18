//
//  AppDelegate.swift
//  Koloda
//
//  Created by Eugene Andreyev on 07/01/2015.
//  Copyright (c) 07/01/2015 Eugene Andreyev. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        print("Is already a user? \(hasLoginKey)")
        let viewController =  hasLoginKey ? storyboard.instantiateViewController(withIdentifier: "SummaryViewController") : storyboard.instantiateViewController(withIdentifier: "StartViewController")
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
        login()
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if CLLocationManager.authorizationStatus() == .denied {
            askUserForPermissionAlert()
        }
    }
    
    func login() {
        guard let credentials = AuthController().getCredentials() else {
            print("Could not get iCloud identifier")
            return
        }
        CenaAPI().login(credentials: credentials)
    }
    
    private func askUserForPermissionAlert() {
        
        let alert = UIAlertController(title: "Location Services Off", message: "Turn on location settings in cena",
                                      preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Go To Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            } else {
                print("Error: Could not open Cena settings")
            }
        }
        alert.addAction(settingsAction)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
}
}
