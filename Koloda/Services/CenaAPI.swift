//
//  CenaAPI.swift
//  Koloda_Example
//
//  Created by Thibault Gagnaux on 08.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import DeviceCheck
import CloudKit
import JWTDecode
import PromiseKit

class CenaAPI {
    private let currentDevice = DCDevice.current
    
    private struct Response: Codable {
        let image: [Image?]
    }
    
    private enum API {
        
        case getAllChallenges
        case getChallenge(Int)
        case createAnnotation(Annotation)
        case updateAnnotation(Int, Annotation)
        case deleteAnnotation(Int)
        case authenticateWithToken
        case register(Credentials)
        case login(Credentials)
        case getStats
        
        private static let basePath = "https://cenaswiper.luethi.rocks"
        
        var method: String {
            switch self {
            case .getAllChallenges, .getChallenge, .getStats: return "GET"
            case .createAnnotation, .authenticateWithToken, .register, .login: return "POST"
            case .updateAnnotation: return "PUT"
            case .deleteAnnotation: return "DELETE"
            }
        }
        
        public func asURLRequest() -> URLRequest {
            let url: URL = {
                let relativePath: String?
                switch self {
                case .getAllChallenges: relativePath = "/challenges"
                case .getChallenge(let id): relativePath = "/challenges/\(id)"
                case .createAnnotation: relativePath = "/annotations"
                case .updateAnnotation(let id, _), .deleteAnnotation(let id): relativePath = "/annotations/\(id)"
                case .authenticateWithToken: relativePath = "/auth/login"
                case .register: relativePath = "/auth/register"
                case .login: relativePath = "/auth/login"
                case .getStats: relativePath = "/stats"
                }
                
                var url = URL(string: API.basePath)!
                if let path = relativePath {
                    url = url.appendingPathComponent(path)
                }
                return url
            }()
            
            let parameters: APIBase? = {
                switch self {
                case .getAllChallenges, .getChallenge, .deleteAnnotation, .authenticateWithToken, .getStats: return nil
                case .createAnnotation(let annotation), .updateAnnotation(_, let annotation): return annotation
                case .register(let credentials): return credentials
                case .login(let credentials): return credentials
                }
            }()
            
            func readPassword() -> String {
                #if IOS_SIMULATOR
                    return DummyUser.Password
                #else
                    guard let user_id = UserDefaults.standard.value(forKey: "username") as? String else {
                        print("Could not get iCloud identifier")
                        return ""
                    }
                
                    let passwordItem = KeychainPasswordItem(service: KeychhainConfiguration.serviceName, account: user_id, accessGroup: KeychhainConfiguration.accessGroup)
                    do {
                        let keychainPassword = try passwordItem.readPassword()
                        
                        return keychainPassword
                    } catch {
                        fatalError("Error updating keychain - \(error)")
                    }
                #endif
                
                }
            
            let token: String? = {
                switch self {
                case .getAllChallenges, .getChallenge, .deleteAnnotation, .authenticateWithToken, .createAnnotation(_), .updateAnnotation(_, _), .getStats: return AuthController().getJWTToken()
                case .register(_), .login(_): return nil
                }
            }()
            
            var request = URLRequest(url: url)
            request.httpMethod = method
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            if let JWToken = token {
                request.addValue("Bearer " + JWToken, forHTTPHeaderField: "Authorization")
            }
            guard let post = parameters else { return request }
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            do {
                let data = try encoder.encode(post)
                let json = String(data: data, encoding: .utf8)
                print(json!)
                request.httpBody = data
            } catch let encodeError as NSError {
                print("Encoder error: \(encodeError.localizedDescription) + \(post)\n")
            }
            return request
        }
    }
    
    
    
    private(set) var challenges: [Challenge] = []
    private(set) var image: [Image] = []
    private(set) var images: [UIImage] = []
    private(set) var test: [Challenge] = []
    private(set) var imageURLs: [String] = []
    let session = URLSession(configuration: .default)
    
    
    
        
    func getAllChallenges(completion: @escaping ([Challenge]) -> ()) {
        let task = session.dataTask(with: API.getAllChallenges.asURLRequest()) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("No data or statusCode not OK")
                return
            }
            do {
                let challenges = try JSONDecoder().decode([Challenge].self, from: data)
                self.challenges = challenges
            } catch let decodeError as NSError {
                print("Decoding error: \(decodeError.localizedDescription)\n")
                return
            }
            
            completion(self.challenges)
        }
        task.resume()
    }
    
    func getStats() -> Promise<[Stats]> {
        return Promise<[Stats]> { seal in
            let task = session.dataTask(with: API.getStats.asURLRequest()) { (data, response, error) in
                if let error = error {
                    NSLog("Error: \(String(describing: error))")
                    seal.reject(error)
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    NSLog("statusCode not OK")
                    return
                }
                do {
                    let projectStats = try JSONDecoder().decode([Stats].self, from: data!)
                    seal.fulfill(projectStats)
                } catch let decodeError as NSError {
                    seal.reject(decodeError)
                }
            }
                task.resume()
        }
    }

    func fetchImageURLs(completion: @escaping ([Challenge], [String]) -> ()) {
        getAllChallenges() { challenges in
            var imageURLs: [String] = []
            for challenge in challenges {
                imageURLs.append(challenge.image.url)
            }
            completion(challenges, imageURLs)
        }
    }
    
    
    func prefetchImages(completion: @escaping ([Challenge], [URL]) -> ()) {
        fetchImageURLs() { challenges, imageURLs in
            let urls = imageURLs.map{ URL(string: $0)!}
            let prefetcher = ImagePrefetcher(urls: urls) {
                skippedResources, failedResources, completedResources in
            }
            DispatchQueue.main.async {
                completion(challenges, urls)
            }
            prefetcher.start()
            
        }
    }
    
    func postAnnotations(annotation: Annotation) {
        let request = API.createAnnotation(annotation).asURLRequest()
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 201 else {
                print("No data or statusCode not OK")
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                _ = try decoder.decode(Annotation.self, from: data)
                
            } catch let decodeError as NSError {
                print("Decoding error: \(decodeError.localizedDescription)\n")
                return
            }
        }
        task.resume()
    }
    
    func register(credentials: Credentials) {
        let request = API.register(credentials).asURLRequest()
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("No data or statusCode not OK")
                return
            }
            let JWTToken = self.decodeJWT(data: data)
            AuthController().savePassword(username: credentials.password, token: JWTToken)
        }
        task.resume()
    }
    
    
    
    func login(credentials: Credentials) {
        let request = API.login(credentials).asURLRequest()
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("No data or statusCode not OK")
                self.register(credentials: credentials)
                return
            }
            let JWTToken = self.decodeJWT(data: data)
            AuthController().savePassword(username: credentials.password, token: JWTToken)
        }
        task.resume()
    }
    
    func decodeJWT(data: Data) -> String {
        guard let JWToken = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .punctuationCharacters) else {
                print("Could not process JWT token")
                return ""
            }
        return JWToken
    }
    
    
    func generateToken(completion: @escaping (String) -> ()) {
        guard currentDevice.isSupported else {
            print("Platform is not supported. Make sure you aren't running in the simulator.")
            return
        }
        currentDevice.generateToken { (data, error) in
            guard let token = data else {
                print("No token could be generated!")
                return
            }
            let stringToken = token.base64EncodedString()
            completion(stringToken)
        }
    }
    
    func authenticateWithToken() {
        generateToken { tokenString in
            var request = API.authenticateWithToken.asURLRequest()
            request.setValue("Bearer \(tokenString)", forHTTPHeaderField: "Authorization")
            let task = self.session.dataTask(with: request) { (data, response, error) in
                guard let _ = data, let response = response as? HTTPURLResponse, response.statusCode == 201 else {
                    print("No data or statusCode not OK")
                    return
                }
            }
            task.resume()
        }
    }
}
