//
//  PMehlich3.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum PMehlich3: CulturalPracticeValueProtocol {
    case taux(KilogramPerHectare)

    static func getTitle() -> String {
        NSLocalizedString(
            "P Mehlich-3",
            comment: "Titre P Mehlich-3"
        )
    }

    func getValue() -> String {
        switch self {
        case .taux(let kilogramPerHectare):
            return String(kilogramPerHectare)
        }
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeInputElement(
            key: UUID().uuidString,
            title: getTitle(),
            valueEmpty: PMehlich3.taux(0),
            value: culturalPractice?.pMehlich3
        )
    }

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        nil
    }

    func getUnitType() -> UnitType? {
        .kgHa
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        guard let tauxValue = Double(value) else { return nil }
        return PMehlich3.taux(tauxValue)
    }

    static func getRegularExpression() -> String? {
        "^\\d*\\.?\\d*$"
    }

    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice {
        var newCulturalPractice = culturalPractice
        newCulturalPractice.pMehlich3 = self
        return newCulturalPractice
    }
}
