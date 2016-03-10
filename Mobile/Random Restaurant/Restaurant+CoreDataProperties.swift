//
//  Restaurant+CoreDataProperties.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/4/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Restaurant {

    @NSManaged var uuid: String
    @NSManaged var name: String
    @NSManaged var createDate: NSDate
    @NSManaged var updateDate: NSDate?
    @NSManaged var activities: NSOrderedSet

}
