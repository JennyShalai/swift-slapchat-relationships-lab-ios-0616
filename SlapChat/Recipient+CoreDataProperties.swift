//
//  Recipient+CoreDataProperties.swift
//  SlapChat
//
//  Created by Jenny on 7/24/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Recipient {

    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var email: String?
    @NSManaged var twitter: String?
    @NSManaged var messages: NSSet?

}
