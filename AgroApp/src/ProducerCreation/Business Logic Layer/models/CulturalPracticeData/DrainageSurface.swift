//
//  DrainageSurface.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum DrainageSurface: Int, SelectValue, Codable {
    case bon = 1
    case moyen
    case mauvais

    func getValue() -> String {
        switch self {
        case .bon:
            return DrainageSurface.getValues()[0]
        case .moyen:
            return DrainageSurface.getValues()[1]
        case .mauvais:
            return DrainageSurface.getValues()[2]
        }
    }

    func getRawValue() -> Int {
        self.rawValue
    }

    static func getTupleValues() -> [(Int, String)] {
        [
            (
                DrainageSurface.bon.rawValue,
                getValues()[0]
            ),
            (
                DrainageSurface.moyen.rawValue,
                getValues()[1]
            ),
            (
                DrainageSurface.mauvais.rawValue,
                getValues()[2]
            )
        ]
    }

    static func getValues() -> [String] {
        [
            NSLocalizedString("Bon", comment: "Drainage de surface Bon"),
            NSLocalizedString("Moyen", comment: "Drainage de surface Moyen"),
            NSLocalizedString("Mauvais", comment: "Drainage de surface Mauvais")
        ]
    }

    static func getTitle() -> String {
        NSLocalizedString("Drainage de surface", comment: "Titre Drainage de surface")
    }

    static func getTypeValue() -> String {
        "drainageSurface"
    }

    static func make(rawValue: Int) -> SelectValue? {
        self.init(rawValue: rawValue)
    }
}
