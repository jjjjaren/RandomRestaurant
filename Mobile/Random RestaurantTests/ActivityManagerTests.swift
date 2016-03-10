//
//  ActivityManagerTests.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/4/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import XCTest
@testable import Random_Restaurant

class ActivityManagerTests: ManagerTests {

    func test_GetAllActivities() {
        let n = 20
        let manager = ActivityManager()
        guard let r = RestaurantManager().addRestaurant("Test") else {
            XCTFail("Object cannot be nil")
            return
        }
        for _ in 1...n {
            let a = manager.addActivity(r)
            XCTAssertNotNil(a)
        }
        let activities = manager.getAllActivities()
        XCTAssertEqual(activities.count, n, "Expected \(n), recevied \(activities.count)")
    }

    func test_GetAllActivities_Performance() {
        let n = 100
        let manager = ActivityManager()
        guard let r = RestaurantManager().addRestaurant("Test") else {
            XCTFail("Object cannot be nil")
            return
        }
        for _ in 1...n {
            let a = manager.addActivity(r)
            XCTAssertNotNil(a)
        }
        self.measureBlock {
            manager.getAllActivities()
        }
    }



    func test_GetActivity_WithDate() {
        let manager = ActivityManager()
        guard let r = RestaurantManager().addRestaurant("Test") else {
            XCTFail("Object cannot be nil")
            return
        }
        let now = NSDate()
        let a = manager.addActivity(r, date: now)
        XCTAssertNotNil(a)
        XCTAssertTrue(a?.date.isEqualToDate(now) ?? false)
    }

    func test_AddActivity() {
        let manager = ActivityManager()
        guard let r = RestaurantManager().addRestaurant("Test") else {
            XCTFail("Object cannot be nil")
            return
        }
        let a = manager.addActivity(r)
        XCTAssertNotNil(a)
    }

    func test_AddActivity_Performance() {
        let n = 100
        let manager = ActivityManager()
        guard let r = RestaurantManager().addRestaurant("Test") else {
            XCTFail("Object cannot be nil")
            return
        }
        self.measureBlock {
            for _ in 1...n {
                manager.addActivity(r)
            }
        }
    }
}
