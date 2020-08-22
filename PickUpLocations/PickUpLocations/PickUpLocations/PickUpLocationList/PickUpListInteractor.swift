//
//  PickUpListInteractor.swift
//  PickUpLocations
//
//  Created by Ravi Vora on 19/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation

protocol PickUpListBusinessLogic {
    func fetchPickupList(request: PickUpListModel.Request)
    func showLoading()
}

final class PickUpListInteractor: PickUpListBusinessLogic {
    
    var presenter: PickUpListPresenterInterface!
    var worker: PickUpListWorkerInterface!
    
    init(presenter: PickUpListPresenterInterface, worker:
        PickUpListWorkerInterface = PickUpListWorker(with: PickUpListService())) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func fetchPickupList(request: PickUpListModel.Request) {
        
        worker.fetchPickUpList(request: request, success: { (pickupList) in
            self.presenter.displayPickUpList(axPickUpList: pickupList.pickUp!)
            self.presenter.hideLoading()
        }) { (code, error) in
            self.presenter.hideLoading()
            self.presenter.showAlertError()
        }
    }
    
    func showLoading() {
        self.presenter.showLoading()
    }
}
