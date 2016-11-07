//
//  User+CoreDataProperties.swift
//  crapper_keeper_ios
//
//  Created by Regina Imhoff on 11/6/16.
//  Copyright © 2016 Regina Imhoff. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var containers: NSSet?
    @NSManaged public var identities: NSSet?

}

// MARK: Generated accessors for containers
extension User {

    @objc(addContainersObject:)
    @NSManaged public func addToContainers(_ value: Container)

    @objc(removeContainersObject:)
    @NSManaged public func removeFromContainers(_ value: Container)

    @objc(addContainers:)
    @NSManaged public func addToContainers(_ values: NSSet)

    @objc(removeContainers:)
    @NSManaged public func removeFromContainers(_ values: NSSet)

}

// MARK: Generated accessors for identities
extension User {

    @objc(addIdentitiesObject:)
    @NSManaged public func addToIdentities(_ value: Identity)

    @objc(removeIdentitiesObject:)
    @NSManaged public func removeFromIdentities(_ value: Identity)

    @objc(addIdentities:)
    @NSManaged public func addToIdentities(_ values: NSSet)

    @objc(removeIdentities:)
    @NSManaged public func removeFromIdentities(_ values: NSSet)

}
