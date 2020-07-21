//
//  BandeRiveraine.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum BandeRiveraine: Int, CulturalPracticeValueProtocol, Codable {
    case pasApplique = 1
    case inferieura1M
    case de1A3M
    case de4MEtPlus

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                BandeRiveraine.pasApplique,
                NSLocalizedString("Ne s'applique pas", comment: "Bande riveraine ne s'applique pas")
            ),
            (
                BandeRiveraine.inferieura1M,
                NSLocalizedString("Inférieur à 1m", comment: "Bande riveraine Inférieur à 1m")
            ),
            (
                BandeRiveraine.de1A3M,
                NSLocalizedString("1 à 3m", comment: "Bande riveraine 4m et plus")
            ),
            (
                BandeRiveraine.de4MEtPlus,
                NSLocalizedString("4m et plus", comment: "Bande riveraine 4m et plus")
            )
        ]
    }

    static func getTitle() -> String {
        NSLocalizedString("Bande riveraine", comment: "Titre bande riveraine")
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: BandeRiveraine.getTitle(),
            tupleCulturalTypeValue: BandeRiveraine.getValues()!,
            value: culturalPractice?.bandeRiveraine
        )
    }

    func getValue() -> String {
        switch self {
        case .pasApplique:
            return NSLocalizedString("Ne s'applique pas", comment: "Bande riveraine ne s'applique pas")
        case .inferieura1M:
            return NSLocalizedString("Inférieur à 1m", comment: "Bande riveraine Inférieur à 1m")
        case .de1A3M:
            return NSLocalizedString("1 à 3m", comment: "Bande riveraine 4m et plus")
        case .de4MEtPlus:
            return NSLocalizedString("4m et plus", comment: "Bande riveraine 4m et plus")
        }
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
        newCulturalPractice.bandeRiveraine = self
        return newCulturalPractice
    }
}
