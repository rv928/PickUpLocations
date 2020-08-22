//
//  PickUpLocationViewControllerTests.swift
//  PickUpLocationsTests
//
//  Created by Ravi Vora on 20/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import XCTest
import UIKit

@testable import PickUpLocations

class PickUpLocationViewControllerTests: XCTestCase {

    var sut: PickUpLocationViewController!
    var delegate: UITableViewDelegate!
    var interactorSpy = InteractorSpy()
    
    override func setUp() {
         sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PickUpLocationViewController") as? PickUpLocationViewController
         sut.beginAppearanceTransition(true, animated: false)
         sut.endAppearanceTransition()
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

    func testShouldDisplayFetchedPickUps() {
        
        // Given
        let tableViewSpy = TableViewSpy()
        sut.pickupListTableView = tableViewSpy
        
        let viewModels: [PickUpListModel.ViewModel] = []
        
        let exp = self.expectation(description: "myExpectation")
        // When
        sut.displayPickUpList(axPickUpList: viewModels)
        
        let queue = DispatchQueue(label: "com.admin.PickUpLocations")
        let delay: DispatchTimeInterval = .seconds((10))
        queue.asyncAfter(deadline: .now() + delay) {
            XCTAssertTrue(true)
            exp.fulfill()
        }
        self.waitForExpectations(timeout: 30){ [] error in
            print("X: async expectation")
            // Then
            XCTAssert(tableViewSpy.reloadDataCalled, "Displaying fetched pickups should reload the table view")
        }
    }
    
    func testNumberOfRowsInAnySectionShouldEqualNumberOfPickUpsToDisplay() {
        // Given
        let tableViewSpy = TableViewSpy()
        sut.pickupListTableView = tableViewSpy

        var viewModels: [PickUpListModel.ViewModel] = []
        
        for _ in 0...5 {
            let displayedPickUp = PickUpListModel.ViewModel(name: "Bandung Street Children Program", city: "Jakarta Barat", address: "Jl. Lodaya No. 65 Bandung", latitude: -6.9310196, longitude: 107.621932, distanceValue: 0.0, isSelected: false)
            viewModels.append(displayedPickUp)
        }
        sut.displayPickUpList(axPickUpList: viewModels)
        
        let exp = self.expectation(description: "myExpectation")
        
        let queue = DispatchQueue(label: "com.admin.PickUpLocations")
        let delay: DispatchTimeInterval = .seconds((10))
        queue.asyncAfter(deadline: .now() + delay) {
            XCTAssertTrue(true)
            exp.fulfill()
        }
        self.waitForExpectations(timeout: 30){ [] error in
            print("X: async expectation")
            // When
            let numberOfRows = self.sut.tableView(self.sut.pickupListTableView, numberOfRowsInSection: 1)
            // Then
            XCTAssertEqual(numberOfRows, viewModels.count,"The number of tableView rows should equal the number of pickups to display")
        }
    }
}
