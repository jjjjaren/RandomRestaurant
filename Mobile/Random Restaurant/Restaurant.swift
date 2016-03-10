//
//  Restaurant.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/4/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import Foundation
import CoreData


class Restaurant: NSManagedObject {

    // Insert code here to add functionality to your managed object subclass

    convenience init(context: NSManagedObjectContext) {
        self.init(entityName: "Restaurant", context: context)
    }

}
