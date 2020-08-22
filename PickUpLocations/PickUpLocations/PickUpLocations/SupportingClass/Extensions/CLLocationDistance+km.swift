//
//  CLLocationDistance+km.swift
//  PickUpLocations
//
//  Created by Ravi Vora on 20/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationDistance {
    func inMiles() -> CLLocationDistance {
        return self*0.00062137
    }

    func inKilometers() -> CLLocationDistance {
        return self/1000
    }
}
