//
//  TauxApplicationPhosphoreVolee.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum TauxApplicationPhosphoreVolee: CulturalPracticeValueProtocol {

    case taux(KilogramPerHectare)

    static func getTitle() -> String {
        NSLocalizedString(
            "Taux d'application de phosphore (engrais minéraux à la volée)",
            comment: "Titre Taux d'application de phosphore (engrais minéraux à la volée)"
        )
    }

    func getValue() -> String {
        switch self {
        case .taux(let kilogramPerHectare):
            return String(kilogramPerHectare)
        }
    }

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        nil
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeInputElement(
            key: UUID().uuidString,
            title: getTitle(),
            valueEmpty: TauxApplicationPhosphoreVolee.taux(0),
            value: culturalPractice?.tauxApplicationPhosphoreVolee
        )
    }

    func getUnitType() -> UnitType? {
        .kgHa
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        guard let tauxValue = Double(value) else { return nil }
        return TauxApplicationPhosphoreVolee.taux(tauxValue)
    }

    static func getRegularExpression() -> String? {
        "^\\d*\\.?\\d*$"
    }

    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice {
        var newCulturalPractice = culturalPractice
        newCulturalPractice.tauxApplicationPhosphoreVolee = self
        return newCulturalPractice
    }
}
