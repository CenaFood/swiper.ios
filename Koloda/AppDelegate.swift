//
//  AppDelegate.swift
//  Koloda
//
//  Created by Eugene Andreyev on 07/01/2015.
//  Copyright (c) 07/01/2015 Eugene Andreyev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        let viewController =  hasLoginKey ? storyboard.instantiateViewController(withIdentifier: "SummaryViewController") : storyboard.instantiateViewController(withIdentifier: "StartViewController")
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
        return true
    }
}
