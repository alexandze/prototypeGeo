//
//  DoseFumier.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum DoseFumier: CulturalPracticeValueProtocol {

    case dose(quantite: Int)

    static func getTitle() -> String {
        NSLocalizedString(
            "Dose du fumier (quantité)",
            comment: "Dose du fumier (quantité)"
        )
    }

    func getValue() -> String {
        switch self {
        case .dose(quantite: let quantite):
            return String(quantite)
        }
    }

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        return nil
    }

    static func getCulturalPracticeElement(id: Int, culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        let count = culturalPractice?.doseFumier?.count ?? -1

        let doseFumier = count > id
            ? culturalPractice!.doseFumier![id]
            : nil

        return CulturalPracticeInputElement(
            key: UUID().uuidString,
            title: getTitle(),
            valueEmpty: DoseFumier.dose(quantite: 0),
            value: doseFumier,
            index: id
        )
    }

    func getUnitType() -> UnitType? {
        .quantity
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        guard let quantityValue = Int(value) else { return nil }
        return DoseFumier.dose(quantite: quantityValue)
    }

    static func getRegularExpression() -> String? {
        // TODO les doses fumiers doivent etre superieure a zero
        "^\\d*$"
    }

    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice {
        var newCulturalPractice = culturalPractice

        if let index = index {
            newCulturalPractice.doseFumier?[index] = self
        }

        return newCulturalPractice
    }
}
