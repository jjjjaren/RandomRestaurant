//
//  NSManagedObject+Extensions.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/4/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {

    // MARK: Initializers

    convenience init(entityName: String, context: NSManagedObjectContext) {
        self.init(entity: NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
    }

    // MARK: Properties

    class var entityName: String {
        var name = NSStringFromClass(self)
        name = name.componentsSeparatedByString(".").last!
        return name
    }

}