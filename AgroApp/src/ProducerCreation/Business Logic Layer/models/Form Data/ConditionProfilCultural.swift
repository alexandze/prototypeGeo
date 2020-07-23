//
//  ConditionProfilCultural.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum ConditionProfilCultural: Int, CulturalPracticeValueProtocol, Codable {
    case bonne = 1
    case presenceZoneRisques
    case dominanceZoneRisque

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                ConditionProfilCultural.bonne,
                NSLocalizedString(
                    "Bonne",
                    comment: "Condition du profil cultural Bonne"
                )
            ),
            (
                ConditionProfilCultural.presenceZoneRisques,
                NSLocalizedString(
                    "Présence de zone à risque",
                    comment: "Condition du profil cultural Présence de zone à risque"
                )
            ),
            (
                ConditionProfilCultural.dominanceZoneRisque,
                NSLocalizedString(
                    "Dominance de zone à risque",
                    comment: "Condition du profil cultural Dominance de zone à risque"
                )
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .bonne:
            return NSLocalizedString(
                "Bonne",
                comment: "Condition du profil cultural Bonne"
            )
        case .presenceZoneRisques:
            return NSLocalizedString(
                "Présence de zone à risque",
                comment: "Condition du profil cultural Présence de zone à risque"
            )
        case .dominanceZoneRisque:
            return NSLocalizedString(
                "Dominance de zone à risque",
                comment: "Condition du profil cultural Dominance de zone à risque"
            )
        }
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Condition du profil cultural",
            comment: "Condition du profil cultural"
        )
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: getTitle(),
            tupleCulturalTypeValue: getValues()!,
            value: culturalPractice?.conditionProfilCultural
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
        newCulturalPractice.conditionProfilCultural = self
        return newCulturalPractice
    }
}
