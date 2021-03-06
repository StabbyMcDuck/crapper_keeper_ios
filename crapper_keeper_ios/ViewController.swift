//
//  ViewController.swift
//  crapper_keeper_ios
//
//  Created by Regina Imhoff on 11/4/16.
//  Copyright © 2016 Regina Imhoff. All rights reserved.
//

import CoreData
import DATAStack
import FacebookLogin
import KeychainSwift
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /*@available(iOS 2.0, *)*/
    @IBOutlet weak var tableView: UITableView!
    
    var containers : [Container] = []
    var dataStack: DATAStack? = nil
    lazy var networking: Networking = Networking(dataStack: self.dataStack!)
    var refreshControl: UIRefreshControl? = nil
    var selectedContainer : Container? = nil
    var user: User? = nil
    
    func fetchCurrentObjects() {
        let request: NSFetchRequest<Container> = Container.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        self.containers = try! dataStack!.mainContext.fetch(request)
        
       /* for container in containers {
            print("Container (id: \(container.id), userId: \(container.userId), user: \(container.user))")
        } */
        
        self.tableView.reloadData()
     }
    
    func fetchNewData(credentials: Credentials) {
        self.networking.fetchUsers(credentials: credentials) { _ in
            let request: NSFetchRequest<User> = User.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
            let users = try! self.dataStack!.mainContext.fetch(request)
            
            if users.count >= 1 {
                self.user = users[0]
            }
            
            
            self.networking.fetchContainers(credentials: credentials) { _ in
                self.fetchCurrentObjects()
                self.refreshControl?.endRefreshing()
            }
        }
        
    }
    
    func refresh() {
        if let credentials = Credentials.get() {
            self.fetchNewData(credentials: credentials)
        } else {
            self.performSegue(withIdentifier: "loginSegue", sender: self)
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
        
        refresh()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCurrentObjects()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedContainer = self.containers[indexPath.row]
        self.performSegue(withIdentifier: "containersTableViewToContainerTabBarSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ContainerTabBarController {
          let containerTabBarController = segue.destination as! ContainerTabBarController
           containerTabBarController.container = self.selectedContainer
        } else if (segue.destination is LoginViewController) {
            if segue.identifier == "logoutSegue" {
                LoginManager().logOut()
                
                Credentials.delete()
                
                try! dataStack!.drop()
                
                self.containers = []
            }
            
            let loginViewController = segue.destination as! LoginViewController
            loginViewController.containersController = self
        } else if (segue.destination is NewContainerViewController) {
            let newContainerViewController = segue.destination as! NewContainerViewController
            newContainerViewController.networking = networking
            newContainerViewController.user = user
        }
    }
}

