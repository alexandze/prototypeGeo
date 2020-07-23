//
//  AlMehlich3.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum AlMehlich3: CulturalPracticeValueProtocol {

    case taux(Percentage)

    static func getTitle() -> String {
        NSLocalizedString(
            "AL Mehlich-3",
            comment: "AL Mehlich-3"
        )
    }

    func getValue() -> String {
        switch self {
        case .taux(let percentage):
            return String(percentage)
        }
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeInputElement(
            key: UUID().uuidString,
            title: getTitle(),
            valueEmpty: AlMehlich3.taux(0),
            value: culturalPractice?.alMehlich3
        )
    }

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        nil
    }

    func getUnitType() -> UnitType? {
        .percentage
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        guard let tauxValue = Double(value) else { return nil }
        return AlMehlich3.taux(tauxValue)
    }

    static func getRegularExpression() -> String? {
        "^\\d*\\.?\\d*$"
    }

    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice {
        var newCulturalPractice = culturalPractice
        newCulturalPractice.alMehlich3 = self
        return newCulturalPractice
    }
}
