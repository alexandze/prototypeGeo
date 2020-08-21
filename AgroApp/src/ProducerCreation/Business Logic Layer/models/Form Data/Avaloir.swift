//
//  Avaloir.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum Avaloir: Int, CulturalPracticeValueProtocol, Codable {
    case absente = 1
    case captagePartiel
    case captageSystematique

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                Avaloir.absente,
                NSLocalizedString("Absente", comment: "Avaloir absente")
            ),
            (
                Avaloir.captagePartiel,
                NSLocalizedString("Captage Partiel", comment: "Avaloir captage partiel")
            ),
            (
                Avaloir.captageSystematique,
                NSLocalizedString("Captage systématique", comment: "Avaloir Captage systématique")
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .absente:
            return NSLocalizedString("Absente", comment: "Avaloir absente")
        case .captagePartiel:
            return NSLocalizedString("Captage Partiel", comment: "Avaloir captage partiel")
        case .captageSystematique:
            return NSLocalizedString("Captage systématique", comment: "Avaloir Captage systématique")
        }
    }

    static func getTitle() -> String {
        NSLocalizedString("Avaloir", comment: "Titre avaloir")
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: Avaloir.getTitle(),
            tupleCulturalTypeValue: Avaloir.getValues()!,
            value: culturalPractice?.avaloir
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
        newCulturalPractice.avaloir = self
        return newCulturalPractice
    }
}

/*
enum Avaloir: Int, CulturalPracticeValue1, Codable {
    case absente = 1
    case captagePartiel
    case captageSystematique

    static func getTupleValues() -> [(Int, String)] {
        [
            (
                Avaloir.absente.rawValue,
                NSLocalizedString("Absente", comment: "Avaloir absente")
            ),
            (
                Avaloir.captagePartiel.rawValue,
                NSLocalizedString("Captage Partiel", comment: "Avaloir captage partiel")
            ),
            (
                Avaloir.captageSystematique.rawValue,
                NSLocalizedString("Captage systématique", comment: "Avaloir Captage systématique")
            )
        ]
    }
    
    static func getValues() -> [String] {
        return [
            NSLocalizedString("Absente", comment: "Avaloir absente"),
            NSLocalizedString("Captage Partiel", comment: "Avaloir captage partiel"),
            NSLocalizedString("Captage systématique", comment: "Avaloir Captage systématique")
        ]
    }

    func getValue() -> String {
        switch self {
        case .absente:
            return NSLocalizedString("Absente", comment: "Avaloir absente")
        case .captagePartiel:
            return NSLocalizedString("Captage Partiel", comment: "Avaloir captage partiel")
        case .captageSystematique:
            return NSLocalizedString("Captage systématique", comment: "Avaloir Captage systématique")
        }
    }

    static func getTitle() -> String {
        NSLocalizedString("Avaloir", comment: "Titre avaloir")
    }

    static func getElementUIDataByCulturalPractice(_ culturalPractice: CulturalPractice?) -> ElementUIData {
        SelectElement(
            title: Avaloir.getTitle(),
            value: culturalPractice?.avaloir?.getValue(),
            isValid: true,
            isRequired: true,
            values: Avaloir.getValues()
        )
    }
    
    static func getCulturalPracticeValueByElementUIData(_ elementUIData: ElementUIData) -> CulturalPracticeValue1? {
        guard let selectElement = elementUIData as? SelectElement,
            selectElement.title == getTitle() else {
                return nil
        }
        
        let indexFindOp = getTupleValues().firstIndex { tuple in
            tuple.1 == selectElement.value
        }
        
        guard let indexFind = indexFindOp else { return nil }
        let rawValue = getTupleValues()[indexFind].0
        return self.init(rawValue: rawValue)
    }

    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice {
        var newCulturalPractice = culturalPractice
        newCulturalPractice.avaloir = self
        return newCulturalPractice
    }
}
*/
