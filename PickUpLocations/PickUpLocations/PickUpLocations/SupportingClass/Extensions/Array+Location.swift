//
//  Array+Location.swift
//  PickUpLocations
//
//  Created by Ravi Vora on 20/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation
import CoreLocation

extension Array where Element == PickUpListModel.ViewModel {

    mutating func sort(by location: CLLocation) {
         return sort(by: { $0.distance(to: location) < $1.distance(to: location) })
    }

    func sorted(by location: CLLocation) -> [PickUpListModel.ViewModel] {
        return sorted(by: { $0.distance(to: location) < $1.distance(to: location) })
    }
}
