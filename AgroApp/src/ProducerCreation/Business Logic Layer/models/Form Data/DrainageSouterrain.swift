//
//  DrainageSouterrain.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum DrainageSouterrain: Int, CulturalPracticeValueProtocol {
    case systematique = 1
    case partiel
    case absent

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                DrainageSouterrain.systematique,
                NSLocalizedString("Systématique", comment: "Drainage souterrain Systématique")
            ),
            (
                DrainageSouterrain.partiel,
                NSLocalizedString("Partiel", comment: "Drainage souterrain Partiel")
            ),
            (
                DrainageSouterrain.absent,
                NSLocalizedString("Absent", comment: "Drainage souterrain absent")
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .systematique:
            return NSLocalizedString("Systématique", comment: "Drainage souterrain Systématique")
        case .partiel:
            return NSLocalizedString("Partiel", comment: "Drainage souterrain Partiel")
        case .absent:
            return NSLocalizedString("Absent", comment: "Drainage souterrain absent")
        }
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Drainage souterrain",
            comment: "Title Drainage souterrain"
        )
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: getTitle(),
            tupleCulturalTypeValue: getValues()!,
            value: culturalPractice?.drainageSouterrain
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
        newCulturalPractice.drainageSouterrain = self
        return newCulturalPractice
    }
}
