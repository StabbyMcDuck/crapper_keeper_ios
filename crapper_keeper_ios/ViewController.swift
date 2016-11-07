//
//  ViewController.swift
//  crapper_keeper_ios
//
//  Created by Regina Imhoff on 11/4/16.
//  Copyright © 2016 Regina Imhoff. All rights reserved.
//

import UIKit
import CoreData
import DATAStack

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let user = "1d4e3c41-d348-414f-bfa4-a681e9d0a2db"
    let password = "d7b17c5f-0b83-4a4f-8027-f6106064dfc7"
    
    /*@available(iOS 2.0, *)*/
    @IBOutlet weak var tableView: UITableView!
    
    var containers : [Container] = []
    var dataStack: DATAStack? = nil
    lazy var networking: Networking = Networking(dataStack: self.dataStack!)
    var refreshControl: UIRefreshControl? = nil
    var selectedContainer : Container? = nil
    
    func fetchCurrentObjects() {
        let request: NSFetchRequest<Container> = Container.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        self.containers = try! dataStack!.mainContext.fetch(request)
        
        for container in containers {
            print("Container (id: \(container.id), userId: \(container.userId), user: \(container.user))")
        }
        
        self.tableView.reloadData()
     }
    
    func fetchNewData(user: String, password: String) {
        self.networking.fetchUsers(user: user, password: password) { _ in
            let request: NSFetchRequest<User> = User.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            let users = try! self.dataStack!.mainContext.fetch(request)
            
            for user in users {
              print("User (id: \(user.id), name: \(user.name))")
            }
            
            self.networking.fetchContainers(user: user, password: password) { _ in
                self.fetchCurrentObjects()
                self.refreshControl?.endRefreshing()
            }
        }
        
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.containers.count
    }

    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let container = self.containers[indexPath.row]
        
        cell.textLabel!.text = container.name
        
        if let image = container.image {
            cell.imageView!.image = UIImage(data: image as Data)
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.dataStack = appDelegate.dataStack
            
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(ViewController.fetchNewData), for: .valueChanged)
        
        self.fetchCurrentObjects()
        self.fetchNewData(user: user, password: password)
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

