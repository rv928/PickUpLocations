//
//  PickUpListWorker.swift
//  PickUpLocations
//
//  Created by Ravi Vora on 19/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol PickUpListWorkerInterface {
    func fetchPickUpList(request: PickUpListModel.Request,
                         success: @escaping (PickUpListModel.Response.PickUpList) -> (),
                         fail: @escaping (_ httpStatus: Int?, _ errorCode: String?) -> ())
}

final class PickUpListWorker: PickUpListWorkerInterface {
    
    var service: PickUpListService!
    
    init(with aService: PickUpListService) {
        service = aService
    }
    
    func fetchPickUpList(request: PickUpListModel.Request,
                         success: @escaping (PickUpListModel.Response.PickUpList) -> (),
                         fail: @escaping (_ httpStatus: Int?, _ errorCode: String?) -> ()) {
        
        service.fetchPickUpList(request: request, success: { (json) in
            success(PickUpListModel.Response.PickUpList(json: json))
        }) { (code, error) in
            fail(code,error)
        }
    }
}
