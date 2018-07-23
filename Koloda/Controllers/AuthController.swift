//
//  AuthController.swift
//  cena
//
//  Created by Thibault Gagnaux on 25.06.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class AuthController {
    public func getJWTToken() -> String {
        #if IOS_SIMULATOR
            return UserDefaults.standard.object(forKey: "username") as! String
        #else
            guard let userId = UserDefaults.standard.value(forKey: "username") as? String else {
                print("Could not get iCloud identifier")
                return ""
            }
        
            let passwordItem = KeychainPasswordItem(service: KeychhainConfiguration.serviceName, account: userId, accessGroup: KeychhainConfiguration.accessGroup)
            do {
                let keychainPassword = try passwordItem.readPassword()
                
                return keychainPassword
            } catch {
                fatalError("Error updating keychain - \(error)")
            }
        #endif
    }
    
    func savePassword(username: String, token: String) {
        #if IOS_SIMULATOR
            UserDefaults.standard.set(token, forKey: "username")
        #else
        let passwordItem = KeychainPasswordItem(service: KeychhainConfiguration.serviceName, account: username, accessGroup: KeychhainConfiguration.accessGroup)
        do {
            try passwordItem.savePassword(token)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
        #endif
        UserDefaults.standard.set(true, forKey: "hasLoginKey")
    }
    
    public func getEmail() -> String {
        #if IOS_SIMULATOR
        return DummyUser.Email
        #else
        guard let userId = UserDefaults.standard.value(forKey: "username") as? String else {
            print("Could not get username")
            return ""
        }
        return userId
        #endif
    }
    
    public func getPassword() -> String {
        #if IOS_SIMULATOR
        return DummyUser.Password
        #else
        guard let userId = UserDefaults.standard.value(forKey: "username") as? String else {
            print("Could not get username")
            return ""
        }
        return userId
        #endif
    }
    
    public func isRegistered() -> Bool {
        return UserDefaults.standard.value(forKey: "username") != nil
    }
    
    func getUserId() -> String? {
        return UserDefaults.standard.value(forKey: "username") as? String
    }
    
    func saveCloudKitIdentifier() {
        #if IOS_SIMULATOR
        UserDefaults.standard.setValue(DummyUser.userID, forKey: "username")
        #else
        let container = CKContainer.default()
        container.fetchUserRecordID {(recordID, error) in
            guard let recordID = recordID else {
                NSLog("Error: \(String(describing: error))")
                return
            }
            UserDefaults.standard.setValue(recordID.recordName, forKey: "username")
        }
        #endif
    }
    
    public func getCredentials() -> Credentials? {
        #if IOS_SIMULATOR
        return Credentials(email: DummyUser.Email, password: DummyUser.Password)
        #else
        guard let userId = getUserId() else {
            return nil
        }
        return Credentials(email: userId, password: userId)
        #endif
    }
    
    public func login() {
        guard let credentials = getCredentials() else {
            print("Could not get CloudKitIdentifier")
            return
        }
        CenaAPI().login(credentials: credentials)
    }
}
