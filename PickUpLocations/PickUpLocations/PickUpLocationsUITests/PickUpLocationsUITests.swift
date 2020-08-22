//
//  PickUpLocationsUITests.swift
//  PickUpLocationsUITests
//
//  Created by Ravi Vora on 19/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import XCTest
@testable import PickUpLocations

class PickUpLocationsUITests: XCTestCase {

    var customKeywordsUtils: CustomKeywordsUtils? = CustomKeywordsUtils.init()
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        customKeywordsUtils?.deleteOnlyApp()
    }

    func testExample() {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testForPickUpListScreen() {
        
        // Wait for webservice call result
        let exp = self.expectation(description: "myExpectation")
        
        let queue = DispatchQueue(label: "com.admin.PickUpLocations")
        let delay: DispatchTimeInterval = .seconds((2))
        queue.asyncAfter(deadline: .now() + delay) {
            XCTAssertTrue(true)
            exp.fulfill()
        }
        self.waitForExpectations(timeout: 4){ [] error in
            print("X: async expectation")
            XCTAssertTrue(true)
        }
        
        // Load PickUp TableView
        let pickUpTableView = app.tables.matching(identifier: "tableView--pickupListTableView")
        let pickUpLocationCell = pickUpTableView.cells.element(matching: .cell, identifier: "PickUpLocationCell0")
        customKeywordsUtils?.swipeToFindElement(app: app, element: pickUpLocationCell, count: 2)
        
        _ = customKeywordsUtils?.swipeToExpectedCellByText(collectionView:pickUpTableView.cells["PickUpLocationCell0"].firstMatch, expectedText: "Bandung Street Children Program", loopCount: 1, swipeSide: .up)
        
        // Tap on back button
        app.navigationBars
            .buttons["navigation-location"].tap()
        
        let exp1 = self.expectation(description: "myExpectation")
        
        let queue1 = DispatchQueue(label: "com.admin.PickUpLocations")
        let delay1: DispatchTimeInterval = .seconds((2))
        queue1.asyncAfter(deadline: .now() + delay1) {
            XCTAssertTrue(true)
            exp1.fulfill()
        }
        self.waitForExpectations(timeout: 4){ [] error in
            print("X: async expectation")
            XCTAssertTrue(true)
        }
        
       _ = customKeywordsUtils?.swipeToExpectedCellByText(collectionView:pickUpTableView.cells["PickUpLocationCell0"].firstMatch, expectedText: "YCAB", loopCount: 1, swipeSide: .up)
    }
}
