//
//  Tools.swift
//
//  Created by Ravi Vora on 29/7/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import UIKit
import Foundation
import KRProgressHUD

class Tools {
    
    static let shared : Tools = {
        let instance = Tools()
        return instance
    }()
    
    // MARK:- ProgressHUD methods
        
    func showProgressHUD() {
        KRProgressHUD.show(withMessage: "Fetching Locations...")
    }
    
    func hideProgressHUD() {
        KRProgressHUD.dismiss()
    }

    // MARK:- Reachability methods
    
    func hasConnectivity() -> Bool {
        
        if Reachability.isConnectedToNetwork() {
            print("Internet Connection Available!")
            return true
        } else {
            print("Internet Connection not Available!")
            return false
        }
    }
    
    func alert(sTitle: String? = nil, sMessage: String?, sTextBtn: String = "OK", handler: ((UIAlertAction) -> Void)?) {
        DispatchQueue.main.async {
            let oAlertController = UIAlertController(title: sTitle, message: sMessage, preferredStyle: .alert)
            let oAlertAction = UIAlertAction(title: sTextBtn, style: .default, handler: { (alertAction) in
                DispatchQueue.main.async {
                    handler?(alertAction)
                }
            })
            oAlertController.addAction(oAlertAction)
            oAlertController.presentGlobally(animated: true)
        }
    }
}
