//
//  Container+CoreDataProperties.swift
//  crapper_keeper_ios
//
//  Created by Regina Imhoff on 11/6/16.
//  Copyright © 2016 Regina Imhoff. All rights reserved.
//

import Foundation
import CoreData


extension Container {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Container> {
        return NSFetchRequest<Container>(entityName: "Container");
    }

    @NSManaged public var containerDescription: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var user: User?
    @NSManaged public var userId: String?

}
