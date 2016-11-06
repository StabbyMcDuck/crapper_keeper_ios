//
//  ContainerDetailViewController.swift
//  crapper_keeper_ios
//
//  Created by Regina Imhoff on 11/5/16.
//  Copyright © 2016 Regina Imhoff. All rights reserved.
//

import UIKit

class ContainerDetailViewController: UIViewController {

    @IBOutlet weak var containerNameTextField: UITextField!
    @IBOutlet weak var containerDescriptionTextView: UITextView!
    @IBOutlet weak var containerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerTabBarController = self.parent as! ContainerTabBarController
        let container = containerTabBarController.container

        // Do any additional setup after loading the view.
        self.containerNameTextField.text = container?.name
        self.containerDescriptionTextView.text = container?.containerDescription
        
        let image = container?.image
        
        if (image != nil) {
            self.containerImageView.image = UIImage(data: image as! Data)
        }
    }
    
}
