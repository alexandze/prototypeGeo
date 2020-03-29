//
//  Util.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import UIKit

class Util {
    static func getOppositeColorBlackOrWhite() -> UIColor {
        UIColor {(trait: UITraitCollection) -> UIColor in
            switch trait.userInterfaceStyle {
            case .dark:
                return .white
            default:
                return .black
            }
        }
    }

    static func getColorBlackOrWhite() -> UIColor {
        UIColor {(trait: UITraitCollection) -> UIColor in
            switch trait.userInterfaceStyle {
            case .dark:
                return .darkText
            default:
                return .white
            }
        }
    }
    
    static func getBackgroundColor() -> UIColor {
        .systemGray6
    }
    
    static func getAlphaValue() -> CGFloat {
        0.95
    }
}
