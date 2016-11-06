//
//  ViewController.swift
//  crapper_keeper_ios
//
//  Created by Regina Imhoff on 11/4/16.
//  Copyright © 2016 Regina Imhoff. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    /*@available(iOS 2.0, *)*/
    @IBOutlet weak var tableView: UITableView!

    var containers : [Container] = []
    var selectedContainer : Container? = nil
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.containers.count
    }

    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        let container = self.containers[indexPath.row]
        
        cell.textLabel!.text = container.name
        cell.imageView!.image = UIImage(data: container.image as! Data)
        
        return cell
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //makeSampleContainer()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Container> = Container.fetchRequest()
        
        let results = try! context.fetch(request)
        /*var results : [AnyObject]?
         
         do {
         results = try context.executeFetchRequest(request)
         } catch _ {
         results = nil
         } */
        
        if (!results.isEmpty){
            self.containers = results
        }
        
        self.tableView.reloadData()
    }

    func makeSampleContainer() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let container = NSEntityDescription.insertNewObject(forEntityName: "Container", into: context) as! Container
        
        container.name = "My apartment"
        container.image = UIImageJPEGRepresentation(UIImage(named: "tools.jpeg")!, 1) as NSData?
        
        do {
            try context.save()
        } catch _ {
            
        }
    }
    
    /*override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedContainer = self.containers[indexPath.row]
        self.performSegue(withIdentifier: "containersTableViewToContainerTabBarSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ContainerTabBarController {
          let containerTabBarController = segue.destination as! ContainerTabBarController
           containerTabBarController.container = self.selectedContainer
        }
    }
}

