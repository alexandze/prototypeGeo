//
//  DelaiIncorporationFumier.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum DelaiIncorporationFumier: Int, SelectValue, Codable {
    case incorporeEn48H = 1
    case incorporeEn48HA1Semaine
    case superieureA1Semaine
    case nonIncorpore

    func getValue() -> String {
        switch self {
        case .incorporeEn48H:
            return DelaiIncorporationFumier.getValues()[0]
        case .incorporeEn48HA1Semaine:
            return DelaiIncorporationFumier.getValues()[1]
        case .superieureA1Semaine:
            return DelaiIncorporationFumier.getValues()[2]
        case .nonIncorpore:
            return DelaiIncorporationFumier.getValues()[3]
        }
    }

    func getRawValue() -> Int {
        self.rawValue
    }

    static func getTupleValues() -> [(Int, String)] {
        [
            (
                DelaiIncorporationFumier.incorporeEn48H.rawValue,
                getValues()[0]
            ),
            (
                DelaiIncorporationFumier.incorporeEn48HA1Semaine.rawValue,
                getValues()[1]
            ),
            (
                DelaiIncorporationFumier.superieureA1Semaine.rawValue,
                getValues()[2]
            ),
            (
                DelaiIncorporationFumier.nonIncorpore.rawValue,
                getValues()[3]
            )
        ]
    }

    static func getValues() -> [String] {
        [
            NSLocalizedString(
                "Incorporé en 48h",
                comment: "Delai d'incorporation du fumier Incorporé en 48h"
            ),
            NSLocalizedString(
                "Incorporé en 48h à 1 semaine",
                comment: "Delai d'incorporation du fumier Incorporé en 48h à 1 semaine"
            ),
            NSLocalizedString(
                "Supérieur à 1 semaine",
                comment: "Delai d'incorporation du fumier Supérieur à 1 semaine"
            ),
            NSLocalizedString(
                "Non incorporé",
                comment: "Delai d'incorporation du fumier Non incorporé"
            )
        ]
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Délai d'incorporation du fumier",
            comment: "Title délai d'incorporation du fumier"
        )
    }

    static func getTypeValue() -> String {
        "delaiIncorporationFumier"
    }

    static func make(rawValue: Int) -> SelectValue? {
        self.init(rawValue: rawValue)
    }
}
