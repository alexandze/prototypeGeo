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
        UIColor {(tr: UITraitCollection) -> UIColor in
            switch tr.userInterfaceStyle {
            case .dark:
                return .white
            default:
                return .black
            }
        }
    }
    
    static func getColorBlackOrWhite() -> UIColor {
        UIColor {(tr: UITraitCollection) -> UIColor in
            switch tr.userInterfaceStyle {
            case .dark:
                return .darkGray
            default:
                return .white
            }
        }
    }
}
