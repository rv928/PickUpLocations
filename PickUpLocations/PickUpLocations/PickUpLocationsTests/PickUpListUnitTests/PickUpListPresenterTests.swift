//
//  PickUpListPresenterTests.swift
//  PickUpLocationsTests
//
//  Created by Ravi Vora on 20/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import XCTest
@testable import PickUpLocations

class PickUpListPresenterTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    // MARK: - Tests
    
    func testDisplayFetchedPickUpsCalledByPresenter() {
        // Given
        let viewControllerSpy = ViewControllerSpy()
        let sut = PickUpListPresenter(viewController: viewControllerSpy)
        // When
        sut.displayPickUpList(axPickUpList: [])
        // Then
        XCTAssert(viewControllerSpy.displayFetchedPickupsCalled,
                  "displayPickUpList() should ask the view controller to display them")
    }
    
    func testPresentFetchedPickUpsShouldFormatFetchedPickUpsForDisplay() {
        // Given
        let viewControllerSpy = ViewControllerSpy()
        let sut = PickUpListPresenter(viewController: viewControllerSpy)
        let pickups = [Seeds.Pickups.pickup1]
        // When
        sut.displayPickUpList(axPickUpList: pickups)

        // Then
        let displayedPickUps = viewControllerSpy.pickups
        
        XCTAssertEqual(displayedPickUps.count, pickups.count,
                       "displayedPickups() should ask the view controller to display same amount of pickups it receive")
        
        for (_, displayedPickUp) in displayedPickUps.enumerated() {
            XCTAssertEqual(displayedPickUp.name, "Bandung Street Children Program")
        }
    }
}
