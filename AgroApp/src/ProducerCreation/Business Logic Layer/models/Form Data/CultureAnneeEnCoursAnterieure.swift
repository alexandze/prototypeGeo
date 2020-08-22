//
//  CultureAnneeEnCoursAnterieure.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum CultureAnneeEnCoursAnterieure: String, SelectValue, Codable {
    
    init?(rawValueIndex: Int) {
        let listRawValue = CultureAnneeEnCoursAnterieure.listRawValue()
        
        guard Util.hasIndexInArray(listRawValue, index: rawValueIndex) else {
            return nil
        }
        
        switch listRawValue[rawValueIndex]  {
        case CultureAnneeEnCoursAnterieure.auc.rawValue:
            self = .auc
        case CultureAnneeEnCoursAnterieure.avo.rawValue:
            self = .avo
        case CultureAnneeEnCoursAnterieure.ble.rawValue:
            self = .ble
        case CultureAnneeEnCoursAnterieure.cnl.rawValue:
            self = .cnl
        case CultureAnneeEnCoursAnterieure.foi.rawValue:
            self = .foi
        case CultureAnneeEnCoursAnterieure.mai.rawValue:
            self = .mai
        case CultureAnneeEnCoursAnterieure.mix.rawValue:
            self = .mix
        case CultureAnneeEnCoursAnterieure.non.rawValue:
            self = .non
        case CultureAnneeEnCoursAnterieure.org.rawValue:
            self = .org
        case CultureAnneeEnCoursAnterieure.ptf.rawValue:
            self = .ptf
        case CultureAnneeEnCoursAnterieure.soy.rawValue:
            self = .soy
        default:
            return nil
        }
    }
    
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
    
    
    static func listRawValue() -> [String] {
        [
            "AUC",
            "AVO",
            "BLE",
            "CNL",
            "FOI",
            "MAI",
            "MIX",
            "NON",
            "ORG",
            "PFT",
            "SOY"
        ]
    }
    
    static func getTupleValues() -> [(Int, String)] {
        [
            (
                0,
                getValues()[0]
            ),
            (
                1,
                getValues()[1]
            ),
            (
                2,
                getValues()[2]
            ),
            (
                3,
                getValues()[3]
            ),
            (
                4,
                getValues()[4]
            ),
            (
                5,
                getValues()[5]
            ),
            (
                6,
                getValues()[6]
            ),
            (
                7,
                getValues()[7]
            ),
            (
                8,
                getValues()[8]
            ),
            (
                9,
                getValues()[9]
            ),
            (
                10,
                getValues()[10]
            )
        ]
    }
    
    static func getValues() -> [String] {
        [
            NSLocalizedString("Autres céréales", comment: "Autres céréales"),
            NSLocalizedString("Avoine", comment: "Avoine"),
            NSLocalizedString("Blé", comment: "Blé"),
            NSLocalizedString("Canola", comment: "Canola"),
            NSLocalizedString("Foin", comment: "Foin"),
            NSLocalizedString("Maï", comment: "Maï"),
            NSLocalizedString("Mixte", comment: "Mixte"),
            NSLocalizedString(
                "Pas d'info, traité comme si c'était du foin",
                comment: "Pas d'info, traité comme si c'était du foin"
            ),
            NSLocalizedString("Orge", comment: "Orge"),
            NSLocalizedString("Petits fruits", comment: "Petits fruits"),
            NSLocalizedString("Soya", comment: "Soya")
        ]
    }
    
    
    // swiftlint:disable all
    func getValue() -> String {
        switch self {
        case .auc:
            return CultureAnneeEnCoursAnterieure.getValues()[0]
        case .avo:
            return CultureAnneeEnCoursAnterieure.getValues()[1]
        case .ble:
            return CultureAnneeEnCoursAnterieure.getValues()[2]
        case .cnl:
            return CultureAnneeEnCoursAnterieure.getValues()[3]
        case .foi:
            return CultureAnneeEnCoursAnterieure.getValues()[4]
        case .mai:
            return CultureAnneeEnCoursAnterieure.getValues()[5]
        case .mix:
            return CultureAnneeEnCoursAnterieure.getValues()[6]
        case .non:
            return CultureAnneeEnCoursAnterieure.getValues()[7]
        case .org:
            return CultureAnneeEnCoursAnterieure.getValues()[8]
        case .ptf:
            return CultureAnneeEnCoursAnterieure.getValues()[9]
        case .soy:
            return CultureAnneeEnCoursAnterieure.getValues()[10]
        }
    }
    
    static func getTitle() -> String {
        NSLocalizedString(
            "Culture de l'année en cours et antérieure",
            comment: "Titre Culture de l'année en cours et antérieure"
        )
    }
    
    static func getTypeValue() -> String {
        "cultureAnneeEnCoursAnterieure"
    }
}
