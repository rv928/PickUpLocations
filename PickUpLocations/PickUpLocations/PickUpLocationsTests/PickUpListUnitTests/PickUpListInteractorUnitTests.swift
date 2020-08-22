//
//  PickUpListInteractorUnitTests.swift
//  PickUpLocationsTests
//
//  Created by Ravi Vora on 20/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import XCTest
@testable import PickUpLocations

class PickUpListInteractorUnitTests: XCTestCase {

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

    func testFetchPickupsCallsWorkerToFetch() {
        // Given
        let pickUpWorkerSpy = WorkerSpy(pickups: nil)
        let presenterSpy = PresenterSpy()
        
        let sut = PickUpListInteractor(presenter: presenterSpy, worker: pickUpWorkerSpy)
        let exp = self.expectation(description: "myExpectation")
        
        var request = PickUpListModel.Request()
        request.shopID = 1
        // When
        sut.fetchPickupList(request: request)
        
        let queue = DispatchQueue(label: "com.admin.PikcUpLocations")
        let delay: DispatchTimeInterval = .seconds((5))
        queue.asyncAfter(deadline: .now() + delay) {
            XCTAssertTrue(true)
            exp.fulfill()
        }
        self.waitForExpectations(timeout: 30){ [] error in
            print("X: async expectation")
            // Then
            XCTAssert(pickUpWorkerSpy.fetchPickupsCalled, "fetchPickups() should ask the worker to fetch pickups")
        }
    }
    
    func testFetchPickUpCallsPresenterToFormatFetchedPickUps() {
        
        // Given
        let pickups = PickUpListModel.Response.PickUpList.init(pickups: Seeds.Pickups.all)
        let presenterSpy = PresenterSpy()
        let pickupWorkerSpy = WorkerSpy(pickups: pickups)
        
        let sut = PickUpListInteractor(presenter: presenterSpy, worker: pickupWorkerSpy)
        var request = PickUpListModel.Request()
        request.shopID = 1
        // When
        sut.fetchPickupList(request: request)
        // Then
        XCTAssertEqual(presenterSpy.pickups?.count,
                       pickups.pickUp?.count, "displayPickUpList() should ask the presenter to format the same amount of pickups it fetched")
    }
}
