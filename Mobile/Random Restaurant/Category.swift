//
//  Category.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/10/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import Foundation
import CoreData


class Category: NSManagedObject {

    // Insert code here to add functionality to your managed object subclass

    convenience init(context: NSManagedObjectContext) {
        self.init(entityName: "Category", context: context)
    }
}
