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

class LoginViewController: UIViewController {
    @IBOutlet weak var uid: UITextField!
    @IBOutlet weak var oauthToken: UITextField!
    var containersController: ViewController!
    
    @IBAction func login(_ sender: Any) {
        Credentials.set(user: uid.text!, password: oauthToken.text!)
        
        self.dismiss(animated: true) {            
            self.containersController.refresh()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
