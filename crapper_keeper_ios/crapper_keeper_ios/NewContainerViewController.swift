//
//  newContainerViewController.swift
//  crapper_keeper_ios
//
//  Created by Regina Imhoff on 11/5/16.
//  Copyright © 2016 Regina Imhoff. All rights reserved.
//

import UIKit
import CoreData

class NewContainerViewController: UIViewController {

    @IBOutlet weak var containerDescriptionTextField: UITextView!
    
    @IBOutlet weak var containerNameTextField: UITextField!
    
    @IBOutlet weak var containerImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveTapped(_ sender: Any)    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let container = NSEntityDescription.insertNewObject(forEntityName: "Container", into: context) as! Container
        
        container.name = containerNameTextField.text
        container.containerDescription = containerDescriptionTextField.text
        container.image = UIImageJPEGRepresentation(UIImage(named: "tools.jpeg")!, 1) as NSData?
        
        do {
            try context.save()
        } catch _ {
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }

}
