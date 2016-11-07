//
//  newContainerViewController.swift
//  crapper_keeper_ios
//
//  Created by Regina Imhoff on 11/5/16.
//  Copyright © 2016 Regina Imhoff. All rights reserved.
//

import UIKit
import CoreData

class NewContainerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var containerDescriptionTextField: UITextView!
    
    @IBOutlet weak var containerNameTextField: UITextField!
    
    @IBOutlet weak var containerImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewContainerViewController.imageTapped))
        
        self.containerImageView.addGestureRecognizer(imageTapRecognizer)
    }

    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageTapped() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let cameraViewController = UIImagePickerController()
            cameraViewController.sourceType = UIImagePickerControllerSourceType.camera
            cameraViewController.delegate = self
            
            self.present(cameraViewController, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
         self.containerImageView.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        
        picker.dismiss(animated: true)
    }
 
    @IBAction func saveTapped(_ sender: Any)    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let container = NSEntityDescription.insertNewObject(forEntityName: "Container", into: context) as! Container
        
        container.name = containerNameTextField.text
        container.containerDescription = containerDescriptionTextField.text
        if let image = self.containerImageView!.image {
            container.image = UIImagePNGRepresentation(image) as NSData?
        }
        
        do {
            try context.save()
        } catch _ {
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }

}
