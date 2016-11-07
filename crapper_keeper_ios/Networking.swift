//
//  Networking.swift
//  crapper_keeper_ios
//
//  Created by Regina Imhoff on 11/6/16.
//  Copyright © 2016 Regina Imhoff. All rights reserved.
//

import Alamofire
import DATAStack
import Sync

class Networking: NSObject {
    let containersURL = "https://afternoon-springs-92546.herokuapp.com/api/v1/containers"
    let usersURL = "https://afternoon-springs-92546.herokuapp.com/api/v1/users"
    
    let dataStack: DATAStack
    
    required init(dataStack: DATAStack) {
        self.dataStack = dataStack
    }
    
    private func fetch(credentials: Credentials, inEntityNamed: String, url: String, _ completion: @escaping (NSError?) -> Void) {
        Alamofire
            .request(url)
            .authenticate(user: credentials.user, password: credentials.password)
            .responseData { response in
                let statusCode = response.response?.statusCode
                
                if 200 <= statusCode! && statusCode! <= 299 {
                    let jsonResult = Request.serializeResponseJSON(options: JSONSerialization.ReadingOptions.allowFragments, response: response.response, data: response.data, error: nil)
                    
                    switch jsonResult {
                        
                    case .success(let json):
                        let changes = json as! [[String: Any]]
                        
                        Sync.changes(changes, inEntityNamed: inEntityNamed, dataStack: self.dataStack) { error in
                            completion(error)
                        }
                        
                    case .failure(let error):
                        print(error)
                        
                        
                    }
                } else if (statusCode! == 401) {
                    print("Authentication error")
                } else {
                    print("Error (HTTP Status Code \(statusCode)")
                }
        }
    }
    
    func createContainer(_ container: Container, credentials: Credentials, _ completion: @escaping (NSError?) -> Void) {
        let parameters: Parameters = [
            "description": container.containerDescription ?? "",
            "name": container.name!,
            "user_id": container.userId!
        ]
        
        Alamofire
            .request(containersURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .authenticate(user: credentials.user, password: credentials.password)
            .responseData { response in
                let statusCode = response.response?.statusCode
                
                if statusCode == 301 {
                    let jsonResult = Request.serializeResponseJSON(options: JSONSerialization.ReadingOptions.allowFragments, response: response.response, data: response.data, error: nil)
                    
                    switch jsonResult {
                        
                    case .success(let json):
                        print("Created \(json)")
                        
                        // Don't call Sync.changes because only created is available
                        completion(nil)
                    case .failure(let error):
                        print(error)
                        
                        
                    }
                } else if statusCode == 401 {
                    print("Authentication error")
                } else {
                    print("Error (HTTP Status Code \(statusCode)")
                }
        }
    }
    
    func fetchContainers(credentials: Credentials, _ completion: @escaping (NSError?) -> Void) {
        fetch(credentials: credentials, inEntityNamed: "Container", url: containersURL, completion)
    }
    
    func fetchUsers(credentials: Credentials, _ completion: @escaping (NSError?) -> Void) {
        fetch(credentials: credentials, inEntityNamed: "User", url: usersURL, completion)
    }
}
