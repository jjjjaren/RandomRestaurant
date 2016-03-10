//
//  ActivityManager.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/4/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import Foundation

class ActivityManager: Manager {

    func getAllActivities() -> [Activity] {
        return fetch(Activity.entityName, sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)]) as? [Activity] ?? [Activity]()
    }

    func getActivity(withUuid uuid: String) -> Activity? {
        return fetch(Activity.entityName, predicate: NSPredicate(format: "uuid = %@", uuid)).first as? Activity
    }

    func addActivity(restaurant: Restaurant, date: NSDate = NSDate()) -> Activity? {
        let a = Activity(context: context)
        a.uuid = NSUUID().UUIDString
        a.date = date
        a.restaurant = restaurant
        do {
            try a.validateForInsert()
            try context.save()
        } catch let e as NSError {
            log.error(e.userInfo)
            context.deleteObject(a)
            return nil
        }
        return a
    }

    func deleteActivity(withUuid uuid: String) -> Bool {
        guard let activity = getActivity(withUuid: uuid) else {
            return false
        }
        return deleteActivity(activity)
    }

    func deleteActivity(activity: Activity) -> Bool {
        do {
            // try activity.validateForDelete()
            context.deleteObject(activity)
            try context.save()
            return true
        } catch let e as NSError {
            log.error(e.userInfo)
            return false
        }
    }

    func deleteAllActivities(forRestaurant restaurant: Restaurant) -> Bool {
        let uuids = restaurant.activities.map { activity -> String in
            return activity.uuid
        }
        for uuid in uuids {
            if !deleteActivity(withUuid: uuid) {
                return false
            }
        }
        return true
    }

}