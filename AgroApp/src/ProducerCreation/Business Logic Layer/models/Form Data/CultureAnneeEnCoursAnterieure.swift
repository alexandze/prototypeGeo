//
//  CultureAnneeEnCoursAnterieure.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum CultureAnneeEnCoursAnterieure: String, CulturalPracticeValueProtocol, Codable {
    case auc = "AUC"
    case avo = "AVO"
    case ble = "BLE"
    case cnl = "CNL"
    case foi = "FOI"
    case mai = "MAI"
    case mix = "MIX"
    case non = "NON"
    case org = "ORG"
    case ptf = "PFT"
    case soy = "SOY"

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                CultureAnneeEnCoursAnterieure.auc,
                NSLocalizedString("Autres céréales", comment: "Autres céréales")
            ),
            (
                CultureAnneeEnCoursAnterieure.avo,
                NSLocalizedString("Avoine", comment: "Avoine")
            ),
            (
                CultureAnneeEnCoursAnterieure.ble,
                NSLocalizedString("Blé", comment: "Blé")
            ),
            (
                CultureAnneeEnCoursAnterieure.cnl,
                NSLocalizedString("Canola", comment: "Canola")
            ),
            (
                CultureAnneeEnCoursAnterieure.foi,
                NSLocalizedString("Foin", comment: "Foin")
            ),
            (
                CultureAnneeEnCoursAnterieure.mai,
                NSLocalizedString("Maï", comment: "Maï")
            ),
            (
                CultureAnneeEnCoursAnterieure.mix,
                NSLocalizedString("Mixte", comment: "Mixte")
            ),
            (
                CultureAnneeEnCoursAnterieure.non,
                NSLocalizedString(
                    "Pas d'info, traité comme si c'était du foin",
                    comment: "Pas d'info, traité comme si c'était du foin"
                )
            ),
            (
                CultureAnneeEnCoursAnterieure.org,
                NSLocalizedString("Orge", comment: "Orge")
            ),
            (
                CultureAnneeEnCoursAnterieure.ptf,
                NSLocalizedString("Petits fruits", comment: "Petits fruits")
            ),
            (
                CultureAnneeEnCoursAnterieure.soy,
                NSLocalizedString("Soya", comment: "Soya")
            )
        ]
    }

    // swiftlint:disable all
    func getValue() -> String {
        switch self {
        case .auc:
            return NSLocalizedString("Autres céréales", comment: "Autres céréales")
        case .avo:
            return NSLocalizedString("Avoine", comment: "Avoine")
        case .ble:
            return NSLocalizedString("Blé", comment: "Blé")
        case .cnl:
            return NSLocalizedString("Canola", comment: "Canola")
        case .foi:
            return NSLocalizedString("Foin", comment: "Foin")
        case .mai:
            return NSLocalizedString("Maï", comment: "Maï")
        case .mix:
            return NSLocalizedString("Mixte", comment: "Mixte")
        case .non:
            return NSLocalizedString(
                "Pas d'info, traité comme si c'était du foin",
                comment: "Pas d'info, traité comme si c'était du foin"
            )
        case .org:
            return NSLocalizedString("Orge", comment: "Orge")
        case .ptf:
            return NSLocalizedString("Petits fruits", comment: "Petits fruits")
        case .soy:
            return NSLocalizedString("Soya", comment: "Soya")
        }
    }
    
    static func getTitle() -> String {
        NSLocalizedString(
            "Culture de l'année en cours et antérieure",
            comment: "Titre Culture de l'année en cours et antérieure"
        )
    }
    
    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: getTitle(),
            tupleCulturalTypeValue: getValues()!,
            value: culturalPractice?.cultureAnneeEnCoursAnterieure
        )
    }
    
    func getUnitType() -> UnitType? {
        nil
    }
    
    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice {
        var newCulturalPractice = culturalPractice
        newCulturalPractice.cultureAnneeEnCoursAnterieure = self
        return newCulturalPractice
    }
    
    static func create(value: String) -> CulturalPracticeValueProtocol? {
        nil
    }
    
    static func getRegularExpression() -> String? {
        nil
    }
}
