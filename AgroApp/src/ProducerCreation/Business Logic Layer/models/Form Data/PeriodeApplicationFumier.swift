//
//  PeriodeApplicationFumier.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum PeriodeApplicationFumier: Int, CulturalPracticeValueProtocol {
    case preSemi = 1
    case postLevee
    case automneHatif
    case automneTardif

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                PeriodeApplicationFumier.preSemi,
                NSLocalizedString(
                    "Pré-semi",
                    comment: "Periode d'application du fumier Pré-semi"
                )
            ),
            (
                PeriodeApplicationFumier.postLevee,
                NSLocalizedString(
                    "Post-levée",
                    comment: "Periode d'application du fumier Post-levée"
                )
            ),
            (
                PeriodeApplicationFumier.automneHatif,
                NSLocalizedString(
                    "Automne hâtif",
                    comment: "Periode d'application du fumier Automne hâtif"
                )
            ),
            (
                PeriodeApplicationFumier.automneTardif,
                NSLocalizedString(
                    "Automne tardif",
                    comment: "Periode d'application du fumier Automne tardif"
                )
            )
        ]
    }

    func getValue() -> String {
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
        }
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Période d'application du fumier",
            comment: "Titre Période d'application du fumier"
        )
    }

    static func getCulturalPracticeElement(id: Int, culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        let count = culturalPractice?.periodeApplicationFumier?.count ?? -1
        let periodeApplicationFumier = count > id
            ? culturalPractice!.periodeApplicationFumier![id]
            : nil

        return CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: getTitle(),
            tupleCulturalTypeValue: getValues()!,
            value: periodeApplicationFumier,
            index: id
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

        if let index = index {
            newCulturalPractice.periodeApplicationFumier?[index] = self
        }

        return newCulturalPractice
    }
}
