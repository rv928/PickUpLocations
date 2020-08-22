//
//  PickUpListModels.swift
//  PickUpLocations
//
//  Created by Ravi Vora on 19/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

struct PickUpListModel {
    
    // Data struct sent to Interactor
    struct Request {
        var shopID: Int?
    }
    
    // Data struct sent to Presenter
    struct Response {
        
        public class PickUpList {
            
            var pickUp: [PickUp]?
            
            init(json: JSON) {
                let pickups = json["pickup"].arrayValue
                self.pickUp = []
                for pickup in pickups {
                    self.pickUp?.append(PickUp(json: pickup))
                }
            }
            
            init(pickups: [PickUp]) {
                self.pickUp = pickups
            }
        }
        
        class PickUp {
            
            var name: String?
            var city: String?
            var address: String?
            var latitude: Double?
            var longitude: Double?
            
            init(json: JSON) {
                self.name  = json["alias"].string
                self.city = json["city"].string
                self.address = (json["address1"].string ?? "") + " " + (json["address2"].string ?? "")
                self.latitude = json["latitude"].double
                self.longitude = json["longitude"].double
            }
            
            init(_ name: String, _ city: String, _ address: String, _ latitude: Double, _ longitude: Double) {
                self.name = name
                self.city = city
                self.address = address
                self.latitude = latitude
                self.longitude = longitude
            }
        }
    }
    
    // Data struct sent to ViewController
    class ViewModel {
        var name: String = ""
        var city: String = ""
        var address: String = ""
        var latitude: Double = 0.0
        var longitude: Double = 0.0
        var distanceValue: Double = 0.0
        var isSelected: Bool = false
        
        init(name: String, city: String, address: String, latitude: Double, longitude: Double, distanceValue: Double,isSelected: Bool) {
            self.name = name
            self.city = city
            self.address = address
            self.latitude = latitude
            self.longitude = longitude
            self.distanceValue = distanceValue
            self.isSelected = isSelected
        }
        
        var location: CLLocation {
            return CLLocation(latitude: self.latitude, longitude: self.longitude)
        }

        func distance(to location: CLLocation) -> CLLocationDistance {
            self.distanceValue = location.distance(from: self.location).inKilometers()
            return location.distance(from: self.location)
        }
    }
}
