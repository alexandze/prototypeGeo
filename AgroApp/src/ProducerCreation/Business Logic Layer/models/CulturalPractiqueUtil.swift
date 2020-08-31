//
//  CulturalPractiqueUtil.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum UnitType {
    case kgHa
    case percentage
    case quantity

    func convertToString() -> String {
        switch self {
        case .kgHa:
            return "kg/ha"
        case .percentage:
            return "%"
        case .quantity:
            return "quantité"
        }
    }
}

typealias KilogramPerHectare = Double
typealias Percentage = Double










