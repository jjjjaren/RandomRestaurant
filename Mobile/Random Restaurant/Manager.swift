//
//  Manager.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/4/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import Foundation
import CoreData

class Manager {

    let context: NSManagedObjectContext

    init() {
        if NSThread.isMainThread() {
            context = DataAccess.sharedInstance.managedObjectContext
        } else {
            let privateMoc = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
            privateMoc.parentContext = DataAccess.sharedInstance.managedObjectContext
            privateMoc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            context = privateMoc
        }
    }

    deinit {
        DataAccess.sharedInstance.saveContext(context)
    }

    final func fetch(entityName: String, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, limit: Int? = nil) -> [NSManagedObject] {
        // Build request
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        if let limit = limit {
            request.fetchLimit = limit
        }

        // Execute request
        var results = [NSManagedObject]()
        do {
            results = try context.executeFetchRequest(request) as? [NSManagedObject] ?? [NSManagedObject]()
        } catch let e as NSError {
            log.error(e.userInfo)
        }
        return results
    }

}