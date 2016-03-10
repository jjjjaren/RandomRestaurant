//
//  RestaurantRandomizer.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/4/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import Foundation

class RestaurantRandomizer: Engine {

    private class func randomPosition(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)) + 1)
    }

    class func getRandomRestaurant(limitDays: Int = 1) -> Restaurant? {
        let restaurantManager = RestaurantManager()
        let restaurantsVisitedThisWeek = restaurantManager.getRestaurants(withActivityInTheLast: limitDays)
        let allRestaurants = restaurantManager.getAllRestaurants()
        let restaurants = allRestaurants.filter { restaurant -> Bool in
            return !restaurantsVisitedThisWeek.contains(restaurant)
        }
        let i = randomPosition(restaurants.count) - 1
        guard i < restaurants.count else {
            return nil
        }
        return restaurants[i]
    }
}