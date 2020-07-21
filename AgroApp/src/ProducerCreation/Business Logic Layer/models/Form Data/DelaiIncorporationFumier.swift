//
//  DelaiIncorporationFumier.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum DelaiIncorporationFumier: Int, CulturalPracticeValueProtocol {
    case incorporeEn48H = 1
    case incorporeEn48HA1Semaine
    case superieureA1Semaine
    case nonIncorpore

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                DelaiIncorporationFumier.incorporeEn48H,
                NSLocalizedString(
                    "Incorporé en 48h",
                    comment: "Delai d'incorporation du fumier Incorporé en 48h"
                )
            ),
            (
                DelaiIncorporationFumier.incorporeEn48HA1Semaine,
                NSLocalizedString(
                    "Incorporé en 48h à 1 semaine",
                    comment: "Delai d'incorporation du fumier Incorporé en 48h à 1 semaine"
                )
            ),
            (
                DelaiIncorporationFumier.superieureA1Semaine,
                NSLocalizedString(
                    "Supérieur à 1 semaine",
                    comment: "Delai d'incorporation du fumier Supérieur à 1 semaine"
                )
            ),
            (
                DelaiIncorporationFumier.nonIncorpore,
                NSLocalizedString(
                    "Non incorporé",
                    comment: "Delai d'incorporation du fumier Non incorporé"
                )
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .incorporeEn48H:
            return NSLocalizedString(
                "Incorporé en 48h",
                comment: "Delai d'incorporation du fumier Incorporé en 48h"
            )
        case .incorporeEn48HA1Semaine:
            return NSLocalizedString(
                "Incorporé en 48h à 1 semaine",
                comment: "Delai d'incorporation du fumier Incorporé en 48h à 1 semaine"
            )
        case .superieureA1Semaine:
            return NSLocalizedString(
                "Supérieur à 1 semaine",
                comment: "Delai d'incorporation du fumier Supérieur à 1 semaine"
            )
        case .nonIncorpore:
            return NSLocalizedString(
                "Non incorporé",
                comment: "Delai d'incorporation du fumier Non incorporé"
            )
        }
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Délai d'incorporation du fumier",
            comment: "Title délai d'incorporation du fumier"
        )
    }

    static func getCulturalPracticeElement(id: Int, culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        let count = culturalPractice?.delaiIncorporationFumier?.count ?? -1
        let delaiIncorporationFumier = count > id
            ? culturalPractice?.delaiIncorporationFumier?[id]
            : nil

        return CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: getTitle(),
            tupleCulturalTypeValue: getValues()!,
            value: delaiIncorporationFumier,
            index: id
        )
    }

    func getUnitType() -> UnitType? {
        nil
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        nil
    }

    static func getRegularExpression() -> String? {
        nil
    }

    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice {
        var newCulturalPractice = culturalPractice

        if let index = index {
            newCulturalPractice.delaiIncorporationFumier?[index] = self
        }

        return newCulturalPractice
    }
}
