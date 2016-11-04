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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.containers.count
    }

    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        let container = self.containers[indexPath.row]
        cell.textLabel!.text = container.name
        return cell
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        makeSampleContainer()

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
    }

    func makeSampleContainer() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let container = NSEntityDescription.insertNewObject(forEntityName: "Container", into: context) as! Container
        
        container.name = "My apartment"
        
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
 
    
    
}

