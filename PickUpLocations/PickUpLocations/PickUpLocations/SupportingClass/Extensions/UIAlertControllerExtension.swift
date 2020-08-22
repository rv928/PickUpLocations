//
//  UIAlertControllerExtension.swift


import Foundation
import UIKit

extension UIAlertController {
    private static var _aletrWindow: UIWindow?
    private static var aletrWindow: UIWindow {
        if let window = _aletrWindow {
            return window
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = UIViewController()
            window.windowLevel = UIWindow.Level.alert + 1
            window.backgroundColor = .clear
            _aletrWindow = window
            return window
        }
    }

    func presentGlobally(animated: Bool, completion: (() -> Void)? = nil) {
        UIAlertController.aletrWindow.makeKeyAndVisible()
        UIAlertController.aletrWindow.rootViewController?.present(self, animated: animated, completion: completion)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIAlertController.aletrWindow.isHidden = true
    }

}
