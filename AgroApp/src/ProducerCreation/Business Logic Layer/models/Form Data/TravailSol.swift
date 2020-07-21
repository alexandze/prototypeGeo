//
//  TravailSol.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum TravailSol: Int, CulturalPracticeValueProtocol {
    case labourAutomneTravailSecondairePrintemps = 1
    case chiselPulverisateurAutomneTravailSecondairePrintemps
    case dechaumageAuPrintempsTravailSecondairePrintemps
    case semiDirectOuBilons

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                TravailSol.labourAutomneTravailSecondairePrintemps,
                NSLocalizedString(
                    "Labour à l'automne, travail secondaire au printemps",
                    comment: "Travail du sol Labour à l'automne"
                )
            ),
            (
                TravailSol.chiselPulverisateurAutomneTravailSecondairePrintemps,
                NSLocalizedString(
                    "Chisel ou pulvérisateur à l'automne, travail secondaire au printemps",
                    comment: "Travail du sol Chisel ou pulvérisateur à l'automne, travail secondaire au printemps"
                )
            ),
            (
                TravailSol.dechaumageAuPrintempsTravailSecondairePrintemps,
                NSLocalizedString(
                    "Déchaumage au printemps et travail secondaire au printemps",
                    comment: "Travail du sol Déchaumage au printemps et travail secondaire au printemps"
                )
            ),
            (
                TravailSol.semiDirectOuBilons,
                NSLocalizedString(
                    "Semi direct ou bilons",
                    comment: "Travail du sol Semi direct ou bilons"
                )
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .labourAutomneTravailSecondairePrintemps:
            return NSLocalizedString(
                "Labour à l'automne, travail secondaire au printemps",
                comment: "Travail du sol Labour à l'automne"
            )
        case .chiselPulverisateurAutomneTravailSecondairePrintemps:
            return NSLocalizedString(
                "Chisel ou pulvérisateur à l'automne, travail secondaire au printemps",
                comment: "Travail du sol Chisel ou pulvérisateur à l'automne, travail secondaire au printemps"
            )
        case .dechaumageAuPrintempsTravailSecondairePrintemps:
            return NSLocalizedString(
                "Déchaumage au printemps et travail secondaire au printemps",
                comment: "Travail du sol Déchaumage au printemps et travail secondaire au printemps"
            )
        case .semiDirectOuBilons:
            return NSLocalizedString(
                "Semi direct ou bilons",
                comment: "Travail du sol Semi direct ou bilons"
            )
        }
    }

    static func getTitle() -> String {
        NSLocalizedString("Travail du sol", comment: "Title travail du sol")
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        let travailSol = culturalPractice?.travailSol != nil
            ? culturalPractice!.travailSol!
            : nil

        return CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: TravailSol.getTitle(),
            tupleCulturalTypeValue: getValues()!,
            value: travailSol
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
        newCulturalPractice.travailSol = self
        return newCulturalPractice
    }
}
