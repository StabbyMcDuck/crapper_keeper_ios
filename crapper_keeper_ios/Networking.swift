//
//  Networking.swift
//  crapper_keeper_ios
//
//  Created by Regina Imhoff on 11/6/16.
//  Copyright © 2016 Regina Imhoff. All rights reserved.
//

import Alamofire
import DATAStack
import FacebookCore
import Sync

//let hostURL = "http://192.168.0.135"
let hostURL = "https://afternoon-springs-92546.herokuapp.com"
let containersURL = "\(hostURL)/api/v1/containers"
let usersURL = "\(hostURL)/api/v1/users"
let facebookAuthURL = "\(hostURL)/api/v1/identities"

class Networking: NSObject {
    
    let dataStack: DATAStack
    
    required init(dataStack: DATAStack) {
        self.dataStack = dataStack
    }
    
    static func facebookLogin(_ accessToken: FacebookCore.AccessToken, loggedIn: @escaping (() -> Void)) {
        facebookLogin(
            accessToken,
            responseData: { responseData in
                let statusCode = responseData.response?.statusCode
                
                if 200 <= statusCode! && statusCode! <= 299 {
                    let jsonResult = Request.serializeResponseJSON(
                        options: JSONSerialization.ReadingOptions.allowFragments,
                        response: responseData.response,
                        data: responseData.data,
                        error: nil
                    )
                    
                    switch jsonResult {
                    case .failure(let error):
                        print("error = \(error)")
                    case .success(let json):
                        print("json = \(json)")
                        let identity = json as! [String: Any]
                        let user = identity["uid"] as! String
                        let password = identity["oauth_token"] as! String
                        Credentials.set(user: user, password: password)
                        
                        loggedIn()
                    }
                } else {
                    print("Facebook login failed (status code \(statusCode))")
                }
            }
        )
    }
    
    static func facebookLogin(_ accessToken: FacebookCore.AccessToken,
                       responseData: @escaping ((DataResponse<Data>) -> Void)) {
        let parameters: Parameters = [
            "access_token": accessToken.authenticationToken,
            "provider": "facebook"
        ]
        
        Alamofire
            .request(facebookAuthURL, method: .post, parameters: parameters)
            .responseData { response in
                responseData(response)
        }
    }
    
    private func fetch(credentials: Credentials, inEntityNamed: String, url: String, _ completion: @escaping (NSError?) -> Void) {
        //print("Authentication: '\(credentials.user)' '\(credentials.password)'")
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
        Alamofire.upload(
            multipartFormData: { (multipartFormData) in
                multipartFormData.append((container.containerDescription ?? "").data(using: .utf8)!, withName: "container[description]")
                multipartFormData.append(container.name!.data(using: .utf8)!, withName: "container[name]")
                multipartFormData.append((container.userId?.data(using: .utf8))!, withName: "container[user_id]")
             
                if let image = container.image {
                    multipartFormData.append(image as Data, withName: "container[image]", fileName: "image.png", mimeType: "image/png")
                }
            },
            to: containersURL
        ){ encodingResult in
            switch encodingResult {
            case .success( let upload, _, _):
                upload.responseJSON { response in
                    switch response.result {
                        case .success(let json):
                            let change = json as! [String: Any]
                            print("Change = \(change)")
                            
                            Sync.changes([change], inEntityNamed: "Container", dataStack: self.dataStack, operations: [.Insert, .Update]) { error in
                                print("Error syncing create's change: \(error)")
                                completion(error)
                            }
                        
                        case .failure(let error):
                            print(error)
                        }
                    }
            case .failure(let error):
                print("Encoding error: \(error)")
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
