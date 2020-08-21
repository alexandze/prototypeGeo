//
//  PeriodeApplicationFumier.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum PeriodeApplicationFumier: Int, SelectValue, Codable {
    case empty
    case preSemi
    case postLevee
    case automneHatif
    case automneTardif

    func getTupleValues() -> [(Int, String)]? {
        [
            (
                PeriodeApplicationFumier.preSemi.rawValue,
                getValues()[0]
            ),
            (
                PeriodeApplicationFumier.postLevee.rawValue,
                getValues()[1]
            ),
            (
                PeriodeApplicationFumier.automneHatif.rawValue,
                getValues()[2]
            ),
            (
                PeriodeApplicationFumier.automneTardif.rawValue,
                getValues()[3]
            )
        ]
    }
    
    func getValues() -> [String] {
        [
            NSLocalizedString(
                "Pré-semi",
                comment: "Periode d'application du fumier Pré-semi"
            ),
            NSLocalizedString(
                "Post-levée",
                comment: "Periode d'application du fumier Post-levée"
            ),
            NSLocalizedString(
                "Automne hâtif",
                comment: "Periode d'application du fumier Automne hâtif"
            ),
            NSLocalizedString(
                "Automne tardif",
                comment: "Periode d'application du fumier Automne tardif"
            )
        ]
    }

    func getValue() -> String? {
        switch self {
        case .preSemi:
            return NSLocalizedString(
                "Pré-semi",
                comment: "Periode d'application du fumier Pré-semi"
            )
        case .postLevee:
            return NSLocalizedString(
                "Post-levée",
                comment: "Periode d'application du fumier Post-levée"
            )
        case .automneHatif:
            return NSLocalizedString(
                "Automne hâtif",
                comment: "Periode d'application du fumier Automne hâtif"
            )
        case .automneTardif:
            return NSLocalizedString(
                "Automne tardif",
                comment: "Periode d'application du fumier Automne tardif"
            )
        case .empty:
            return nil
        }
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Période d'application du fumier",
            comment: "Titre Période d'application du fumier"
        )
    }

    func getUnitType() -> UnitType? {
        nil
    }
}
