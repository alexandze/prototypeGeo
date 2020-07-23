//
//  CouvertureAssociee.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum CouvertureAssociee: Int, CulturalPracticeValueProtocol, Codable {
    case vrai = 1
    case faux = 0

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                CouvertureAssociee.vrai,
                NSLocalizedString("Vrai", comment: "Couverture associée vrai")
            ),
            (
                CouvertureAssociee.faux,
                NSLocalizedString("Faux", comment: "Couverture associée faux")
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .vrai:
            return NSLocalizedString("Vrai", comment: "Couverture associée vrai")
        case .faux:
            return NSLocalizedString("Faux", comment: "Couverture associée faux")
        }
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Couverture associée",
            comment: "Title couverture associée"
        )
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        let couvertureAssociee = culturalPractice?.couvertureAssociee != nil
            ? culturalPractice!.couvertureAssociee!
            : nil

        return
            CulturalPracticeMultiSelectElement(
                key: UUID().uuidString,
                title: getTitle(),
                tupleCulturalTypeValue: getValues()!,
                value: couvertureAssociee
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
        newCulturalPractice.couvertureAssociee = self
        return newCulturalPractice
    }
}
