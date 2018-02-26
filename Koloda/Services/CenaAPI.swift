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

class CenaAPI {
    //private let queue = OperationQueue()
    private let currentDevice = DCDevice.current
    
    private struct Response: Codable {
        //let test: [Challenge]?
        let image: [Image?]
    }
    
    private enum API {
        
        case getAllChallenges
        case getChallenge(Int)
        case createAnnotation(Annotation)
        case updateAnnotation(Int, Annotation)
        case deleteAnnotation(Int)
        case authenticateWithToken
        // Base endpoint
        private static let basePath = "http://86.119.37.97:5001"
       
        /*
         Head on over to https://bonseyes. to get your
         free API key, and then replace the value below with it.
         */
        private static let key = ""
        
        
        // Set the method
        var method: String {
            switch self {
            case .getAllChallenges, .getChallenge: return "GET"
            case .createAnnotation, .authenticateWithToken: return "POST"
            case .updateAnnotation: return "PUT"
            case .deleteAnnotation: return "DELETE"
            }
        }
        
        
        // Construct the request from url, method and parameters
        public func asURLRequest() -> URLRequest {
            // Build the request endpoint
            let url: URL = {
                let relativePath: String?
                // DONE: Set relativePath to use id, as appropriate
                switch self {
                case .getAllChallenges: relativePath = "/challenges"
                case .getChallenge(let id): relativePath = "/challenges/\(id)"
                case .createAnnotation: relativePath = "/annotations"
                case .updateAnnotation(let id, _), .deleteAnnotation(let id): relativePath = "/annotations/\(id)"
                case .authenticateWithToken: relativePath = "/auth/register"
                }
                
                var url = URL(string: API.basePath)!
                if let path = relativePath {
                    url = url.appendingPathComponent(path)
                }
                return url
            }()
            
            // Set up request parameters
            let parameters: Annotation? = {
                switch self {
                case .getAllChallenges, .getChallenge, .deleteAnnotation, .authenticateWithToken: return nil
                case .createAnnotation(let annotation), .updateAnnotation(_, let annotation): return annotation
                }
            }()
            
            // Create request
            var request = URLRequest(url: url)
            request.httpMethod = method
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            guard let post = parameters else { return request }
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            do {
                let data = try encoder.encode(post)
//                let json = String(data: data, encoding: .utf8)
                request.httpBody = data
            } catch let encodeError as NSError {
                print("Encoder error: \(encodeError.localizedDescription)\n")
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
                //print(skippedResources, failedResources, completedResources)
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
                //print(String(data: data, encoding: .utf8)!)
                _ = try decoder.decode(Annotation.self, from: data)
                //print("Successfully posted annotation")
                
                //self.annotation = annotation
            } catch let decodeError as NSError {
                print("Decoding error: \(decodeError.localizedDescription)\n")
                return
            }
        }
        task.resume()
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
            print(stringToken)
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
                // save valid token into keychain
            }
            task.resume()
        }
    }
}
