//
//  RestaurantManager.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/4/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import Foundation

class RestaurantManager: Manager {

    func getAllRestaurants() -> [Restaurant] {
        return fetch(Restaurant.entityName, sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) as? [Restaurant] ?? [Restaurant]()
    }

    func getRestaurant(withName name: String) -> Restaurant? {
        return fetch(Restaurant.entityName, predicate: NSPredicate(format: "name = %@", name), limit: 1).first as? Restaurant
    }

    func getRestaurants(withActivityInTheLast days: Int = 7) -> [Restaurant] {
        var restaurants = fetch(Restaurant.entityName) as? [Restaurant] ?? [Restaurant]()
        restaurants = restaurants.filter { restaurant -> Bool in
            guard let mostRecentActivity = restaurant.activities.sortedArrayUsingDescriptors([NSSortDescriptor(key: "date", ascending: true)]).first as? Activity else {
                return false
            }
            return mostRecentActivity.date < NSDate().addDays(days)
        }
        return restaurants
    }

    func addRestaurant(name: String) -> Restaurant? {
        let r = Restaurant(context: context)
        r.uuid = NSUUID().UUIDString
        r.name = name
        r.createDate = NSDate()
        do {
            try r.validateForInsert()
            try context.save()
        } catch let e as NSError {
            log.error(e.userInfo)
            context.deleteObject(r)
            return nil
        }
        return r
    }

    func deleteRestaurant(name: String) -> Bool {
        guard let restaurant = fetch(Restaurant.entityName, predicate: NSPredicate(format: "name = %@", name), limit: 1).first else {
            return false
        }
        do {
            try restaurant.validateForDelete()
            context.deleteObject(restaurant)
            try context.save()
            return true
        } catch let e as NSError {
            log.error(e.userInfo)
            return false
        }
    }
}