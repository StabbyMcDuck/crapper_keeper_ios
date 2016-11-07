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
    
    private func fetch(inEntityNamed: String, url: String, user: String, password: String, _ completion: @escaping (NSError?) -> Void) {
        Alamofire.request(url)
            .authenticate(user: user, password: password)
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
                    print("Error")
                }
        }
    }
    
    func fetchContainers(user: String, password: String, _ completion: @escaping (NSError?) -> Void) {
        fetch(inEntityNamed: "Container", url: containersURL, user: user, password: password, completion)
    }
}
