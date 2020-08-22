//
//  LocationButton.swift
//
//  Created by Ravi Vora on 5/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation
import UIKit

public class LocationButton: UIButton {

    override public var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.4 : 1
        }
    }
}
