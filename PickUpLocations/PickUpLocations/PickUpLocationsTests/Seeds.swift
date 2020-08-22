//
//  Seeds.swift
//  PickUpLocationsTests
//
//  Created by Ravi Vora on 20/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation
@testable import PickUpLocations

struct Seeds {
    
    struct Pickups {
        static let pickup1 = PickUpListModel.Response.PickUp("Bandung Street Children Program", "Jakarta Barat", "Jl. Lodaya No. 65 Bandung", -6.9310196, 107.621932)
        
        static let pickup2 = PickUpListModel.Response.PickUp("Clothes for Charity", "Jakarta Selatan", "Jl. Jatipadang Utara No. 2 Pasar Minggu", -6.285531, 106.828669)

        static let pickup3 = PickUpListModel.Response.PickUp("Pijar Renjana", "Jakarta Timur", "Jl. Kesatrian III No. 36, RT 006/003 Matraman", -6.208239, 106.856754)
        
        static let pickup4 = PickUpListModel.Response.PickUp("Sahabat Anak", "Java Barat", "Jl. Tambak 2 No. 23, RT.6 / RW.5, RT.9 / RW.5, Pegangsaan, Menteng Central Jakarta Municipality, Special Capital Region of Jakarta", -6.203699, 106.847345)

        static let pickup5 = PickUpListModel.Response.PickUp("Yayasan Rumah Impian ", "Yogyakarta", "JJuwangen, Purwomartani, Kalasan Sleman Regency, Special Region of Yogyakarta", -7.778439, 110.44603)
        
        static let pickup6 = PickUpListModel.Response.PickUp("YCAB", "Jakarta Barat", "Jl. Surya Mandala I no 8D Kedoya, Special Region of Yogyakarta", -6.176629, 106.76204)

        static let all = [pickup1,pickup2,pickup3,pickup4,pickup5,pickup6]
    }
}
