//
//  PeriodeApplicationFumier.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum PeriodeApplicationFumier: Int, SelectValue, Codable {
    case preSemi = 1
    case postLevee
    case automneHatif
    case automneTardif

    func getValue() -> String {
        switch self {
        case .preSemi:
            return PeriodeApplicationFumier.getValues()[0]
        case .postLevee:
            return PeriodeApplicationFumier.getValues()[1]
        case .automneHatif:
            return PeriodeApplicationFumier.getValues()[2]
        case .automneTardif:
            return PeriodeApplicationFumier.getValues()[3]
        }
    }

    func getRawValue() -> Int {
        self.rawValue
    }

    static func getTupleValues() -> [(Int, String)] {
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

    static func getValues() -> [String] {
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

    static func getTitle() -> String {
        NSLocalizedString(
            "Période d'application du fumier",
            comment: "Titre Période d'application du fumier"
        )
    }

    static func getTypeValue() -> String {
        "periodeApplicationFumier"
    }

    static func make(rawValue: Int) -> SelectValue? {
        self.init(rawValue: rawValue)
    }
}
