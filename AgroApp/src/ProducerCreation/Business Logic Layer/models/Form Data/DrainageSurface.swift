//
//  DrainageSurface.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum DrainageSurface: Int, CulturalPracticeValueProtocol, Codable {
    case bon = 1
    case moyen
    case mauvais

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                DrainageSurface.bon,
                NSLocalizedString("Bon", comment: "Drainage de surface Bon")
            ),
            (
                DrainageSurface.moyen,
                NSLocalizedString("Moyen", comment: "Drainage de surface Moyen")
            ),
            (
                DrainageSurface.mauvais,
                NSLocalizedString("Mauvais", comment: "Drainage de surface Mauvais")
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .bon:
            return NSLocalizedString("Bon", comment: "Drainage de surface Bon")
        case .moyen:
            return NSLocalizedString("Moyen", comment: "Drainage de surface Moyen")
        case .mauvais:
            return NSLocalizedString("Mauvais", comment: "Drainage de surface Mauvais")
        }
    }

    static func getTitle() -> String {
        NSLocalizedString("Drainage de surface", comment: "Titre Drainage de surface")
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: getTitle(),
            tupleCulturalTypeValue: getValues()!,
            value: culturalPractice?.drainageSurface
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
        newCulturalPractice.drainageSurface = self
        return newCulturalPractice
    }
}
