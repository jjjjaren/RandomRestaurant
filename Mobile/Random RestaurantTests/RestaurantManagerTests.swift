//
//  RestaurantManagerTests.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/4/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import XCTest
@testable import Random_Restaurant

class RestaurantManagerTests: ManagerTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_AddRestaurant() {
        let manager = RestaurantManager()
        manager.addRestaurant("Test")
        let r = manager.getRestaurant(withName: "Test")
        XCTAssertNotNil(r)
    }

    func test_AddRestaurant_Performance() {
        let numberOfRestaurants = 100
        let manager = RestaurantManager()
        self.measureBlock {
            for i in 1...numberOfRestaurants {
                manager.addRestaurant("Test\(i)")
            }
        }
    }

    func test_GetAllRestaurants() {
        let numberOfRestaurants = 5
        let manager = RestaurantManager()
        for i in 1...numberOfRestaurants {
            manager.addRestaurant("Test\(i)")
        }
        let n = manager.getAllRestaurants()
        XCTAssertEqual(n.count, numberOfRestaurants, "Expected \(numberOfRestaurants), received \(n.count)")
    }

    func test_GetAllRestaurants_Performance() {
        let numberOfRestaurants = 1000
        let manager = RestaurantManager()
        for i in 1...numberOfRestaurants {
            manager.addRestaurant("Test\(i)")
        }
        self.measureBlock {
            manager.getAllRestaurants()
        }
    }

}