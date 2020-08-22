//
//  PickUpListPresenter.swift
//  PickUpLocations
//
//  Created by Ravi Vora on 19/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation

protocol PickUpListPresenterInterface {
    func displayPickUpList(axPickUpList: [PickUpListModel.Response.PickUp])
    func showLoading()
    func hideLoading()
    func showAlertError()
}

class PickUpListPresenter: PickUpListPresenterInterface {
    
    var pickUpListView: PickUpListView!
    
    init(viewController: PickUpListView) {
        self.pickUpListView = viewController
    }
    
    func displayPickUpList(axPickUpList: [PickUpListModel.Response.PickUp]) {
        
        var displayedPickUps: [PickUpListModel.ViewModel] = []
        
        for pickup in axPickUpList {
            if pickup.name != "" {
                let displayedPickUp = PickUpListModel.ViewModel(name: pickup.name ?? "", city: pickup.city ?? "", address: pickup.address ?? "" , latitude: pickup.latitude ?? 0.0, longitude: pickup.longitude ?? 0.0, distanceValue: 0.0, isSelected: false)
                displayedPickUps.append(displayedPickUp)
            }
        }
        self.pickUpListView.displayPickUpList(axPickUpList: displayedPickUps)
    }
    
    func showLoading() {
        self.pickUpListView.showLoading()
    }
    
    func hideLoading() {
        self.pickUpListView.hideLoading()
    }
    
    func showAlertError() {
        self.pickUpListView.showAlertError()
    }
}
