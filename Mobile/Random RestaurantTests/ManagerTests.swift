//
//  ManagerTests.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/4/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import XCTest
@testable import Random_Restaurant

class ManagerTests: XCTestCase {

    private let kTestSqliteFileName = "XCTestDB.sqlite"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        DataAccess.sharedInstance.sqliteFileName = kTestSqliteFileName
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let dataAccess = DataAccess.sharedInstance
        dataAccess.managedObjectContext.reset()
        do {
            for store in dataAccess.persistentStoreCoordinator.persistentStores {
                try dataAccess.persistentStoreCoordinator.removePersistentStore(store)
            }
            let url = dataAccess.applicationDocumentsDirectory.URLByAppendingPathComponent(kTestSqliteFileName)
            let fileManager = NSFileManager.defaultManager()
            try fileManager.removeItemAtURL(url)
        } catch let error as NSError {
            log.error("Remove failed: \(error.localizedDescription)")
        }
        dataAccess.reset()
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

    
}