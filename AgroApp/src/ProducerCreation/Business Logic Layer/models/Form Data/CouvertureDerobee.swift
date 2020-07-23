//
//  CouvertureDerobee.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum CouvertureDerobee: Int, CulturalPracticeValueProtocol, Codable {
    case vrai = 1
    case faux = 0

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                CouvertureDerobee.vrai,
                NSLocalizedString("Vrai", comment: "Couverture dérobée vrai")
            ),
            (
                CouvertureDerobee.faux,
                NSLocalizedString("Faux", comment: "Couverture dérobée faux")
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .vrai:
            return NSLocalizedString("Vrai", comment: "Couverture dérobée vrai")
        case .faux:
            return NSLocalizedString("Faux", comment: "Couverture dérobée faux")
        }
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Couverture dérobée",
            comment: "Title Couverture dérobée"
        )
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: getTitle(),
            tupleCulturalTypeValue: getValues()!,
            value: culturalPractice?.couvertureDerobee
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
        newCulturalPractice.couvertureDerobee = self
        return newCulturalPractice
    }
}
