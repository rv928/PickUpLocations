//
//  TestDoubles.swift
//  PickUpLocationsTests
//
//  Created by Ravi Vora on 20/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation
import UIKit
@testable import PickUpLocations

// MARK:- Test doubles

class PresenterSpy: PickUpListPresenterInterface {
    
    var presentPickupsCalled = false
    var pickups: [PickUpListModel.Response.PickUp]?
    
    func displayPickUpList(axPickUpList: [PickUpListModel.Response.PickUp]) {
        self.presentPickupsCalled = true
        self.pickups = axPickUpList
    }
    
    func showLoading() {}
    func hideLoading() {}
    func showAlertError() {}
}

class WorkerSpy: PickUpListWorkerInterface {
    
    var fetchPickupsCalled = false
    var pickups: PickUpListModel.Response.PickUpList?
    
    init(pickups: PickUpListModel.Response.PickUpList?) {
        if pickups != nil {
            self.pickups = pickups!
        }
    }
    
    func fetchPickUpList(request: PickUpListModel.Request, success: @escaping (PickUpListModel.Response.PickUpList) -> (), fail: @escaping (Int?, String?) -> ()) {
        
        fetchPickupsCalled = true
        if pickups != nil {
            success(pickups!)
        } else {
            fail(401,"Error")
        }
    }
}

class ViewControllerSpy: PickUpListView {
    
    var displayFetchedPickupsCalled = false
    var pickups: [PickUpListModel.ViewModel] = []
    
    func displayPickUpList(axPickUpList: [PickUpListModel.ViewModel]) {
        displayFetchedPickupsCalled = true
        self.pickups = axPickUpList
    }
    
    func showLoading() {}
    func hideLoading() {}
    func showAlertError() {}
}

class InteractorSpy: PickUpListBusinessLogic {
    
    var fetchPickupsCalled = false
    
    func fetchPickupList(request: PickUpListModel.Request) {
        fetchPickupsCalled = true
    }
    
    func showLoading() {}
}

class TableViewSpy: UITableView {
    
    var reloadDataCalled = false
    
    override func reloadData() {
        reloadDataCalled = true
    }
}
