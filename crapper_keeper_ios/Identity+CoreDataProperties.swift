//
//  Identity+CoreDataProperties.swift
//  crapper_keeper_ios
//
//  Created by Regina Imhoff on 11/6/16.
//  Copyright © 2016 Regina Imhoff. All rights reserved.
//

import Foundation
import CoreData


extension Identity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Identity> {
        return NSFetchRequest<Identity>(entityName: "Identity");
    }

    @NSManaged public var provider: String?
    @NSManaged public var uid: String?
    @NSManaged public var oauthToken: String?
    @NSManaged public var oathTokenExpiresAt: NSDate?
    @NSManaged public var user: User?

}
