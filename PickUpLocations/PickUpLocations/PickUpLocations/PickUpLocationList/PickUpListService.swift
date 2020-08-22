//
//  PickUpListService.swift
//  PickUpLocations
//
//  Created by Ravi Vora on 19/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation
import SwiftyJSON

final class PickUpListService {
    
    /*
     This method will fetch pickup locations from Webservice.
     */
    
    func fetchPickUpList(request: PickUpListModel.Request,
                         success: @escaping (JSON) -> (),
                         fail: @escaping (_ httpStatus: Int?, _ errorCode: String?) -> ()) {
        
        if Tools.shared.hasConnectivity() == false {
            Tools.shared.alert(sMessage: internetMsg, handler: nil)
            Tools.shared.hideProgressHUD()
        }
        
        let params: [String: Any?] = [
            "shop_id": request.shopID,
        ]
        
        let api = APIManager.init(endpoint: .fetchPickUpLocations)
        
        api.call(parameters: params as [String:AnyObject], headersAdditional: nil, encoding: nil, fail: { (status, code) in
            fail(status, code)
        }) { (json) in
            success(json)
        }
    }
}
