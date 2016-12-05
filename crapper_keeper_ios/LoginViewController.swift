//
//  LoginViewController.swift
//  crapper_keeper_ios
//
//  Created by Regina Imhoff on 11/6/16.
//  Copyright © 2016 Regina Imhoff. All rights reserved.
//

import CoreData
import KeychainSwift
import UIKit
import FacebookCore
import FacebookLogin
import Alamofire

class LoginViewController: UIViewController, LoginButtonDelegate {
    @IBOutlet weak var uid: UITextField!
    @IBOutlet weak var oauthToken: UITextField!
    var containersController: ViewController!
    
    @IBAction func login(_ sender: Any) {
        Credentials.set(user: uid.text!, password: oauthToken.text!)
        
        self.dismiss(animated: true) {            
            self.containersController.refresh()
        }
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .cancelled:
            print("Facebook login cancelled")
        case .failed(let error):
            print("Facebook login failed (\(error))")
        case .success(_, _, let accessToken):
            Networking.facebookLogin(accessToken) { responseData in
                let statusCode = responseData.response?.statusCode
                
                print("statusCode = \(statusCode)")
            }
        }
    }
    
    // A different screen is used for logout
    func loginButtonDidLogOut(_ loginButton: LoginButton) {}
    
    override func viewDidLoad() {
        if let accessToken = FacebookCore.AccessToken.current {
            Networking.facebookLogin(accessToken) { responseData in
                let statusCode = responseData.response?.statusCode
                
                if 200 <= statusCode! && statusCode! <= 299 {
                    print("data = \(String(data: responseData.data!, encoding: String.Encoding.utf8))")
                    
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
                        let identity = json as! [String: Any]
                        Credentials.set(user: identity["uid"] as! String, password: identity["oauth_token"] as! String)
                        
                        self.dismiss(animated: true) {
                            self.containersController.refresh()
                        }
                    }
                } else {
                    print("Facebook login failed (status code \(statusCode))")
                }
            }
        } else {
            let loginButton = LoginButton(readPermissions: [ .publicProfile ])
            loginButton.center.x = view.center.x
            loginButton.center.y = view.center.y + 40
            loginButton.delegate = self
        
            view.addSubview(loginButton)
        }
    }
}
