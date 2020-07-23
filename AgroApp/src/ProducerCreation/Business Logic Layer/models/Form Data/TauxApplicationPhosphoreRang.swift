//
//  TauxApplicationPhosphoreRang.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum TauxApplicationPhosphoreRang: CulturalPracticeValueProtocol {
    case taux(KilogramPerHectare)

    static func getTitle() -> String {
        NSLocalizedString(
            "Taux d'application de phosphore (engrais minéraux en rang)",
            comment: "Titre Taux d'application de phosphore (engrais minéraux en rang)"
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
            valueEmpty: TauxApplicationPhosphoreRang.taux(0),
            value: culturalPractice?.tauxApplicationPhosphoreRang
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
        return TauxApplicationPhosphoreRang.taux(tauxValue)
    }

    static func getRegularExpression() -> String? {
        "^\\d*\\.?\\d*$"
    }

    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice {
        var newCulturalPractice = culturalPractice
        newCulturalPractice.tauxApplicationPhosphoreRang = self
        return newCulturalPractice
    }
}
