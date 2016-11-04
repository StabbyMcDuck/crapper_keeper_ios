//
//  Container+CoreDataProperties.swift
//  crapper_keeper_ios
//
//  Created by Regina Imhoff on 11/4/16.
//  Copyright © 2016 Regina Imhoff. All rights reserved.
//

import Foundation
import CoreData


extension Container {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Container> {
        return NSFetchRequest<Container>(entityName: "Container");
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var containerDescription: String?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var image: NSData?

}
