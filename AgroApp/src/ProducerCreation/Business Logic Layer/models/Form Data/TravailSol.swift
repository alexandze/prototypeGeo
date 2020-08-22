//
//  TravailSol.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum TravailSol: Int, SelectValue, Codable {
    case labourAutomneTravailSecondairePrintemps = 1
    case chiselPulverisateurAutomneTravailSecondairePrintemps
    case dechaumageAuPrintempsTravailSecondairePrintemps
    case semiDirectOuBilons
    
    func getValue() -> String {
        switch self {
        case .labourAutomneTravailSecondairePrintemps:
            return TravailSol.getValues()[0]
        case .chiselPulverisateurAutomneTravailSecondairePrintemps:
            return TravailSol.getValues()[1]
        case .dechaumageAuPrintempsTravailSecondairePrintemps:
            return TravailSol.getValues()[2]
        case .semiDirectOuBilons:
            return TravailSol.getValues()[3]
        }
    }

    static func getTupleValues() -> [(Int, String)] {
        [
            (
                TravailSol.labourAutomneTravailSecondairePrintemps.rawValue,
                getValues()[0]
            ),
            (
                TravailSol.chiselPulverisateurAutomneTravailSecondairePrintemps.rawValue,
                getValues()[1]
            ),
            (
                TravailSol.dechaumageAuPrintempsTravailSecondairePrintemps.rawValue,
                getValues()[2]
            ),
            (
                TravailSol.semiDirectOuBilons.rawValue,
                getValues()[3]
            )
        ]
    }
    
    static func getValues() -> [String] {
        [
            NSLocalizedString(
                "Labour à l'automne, travail secondaire au printemps",
                comment: "Travail du sol Labour à l'automne"
            ),
            NSLocalizedString(
                "Chisel ou pulvérisateur à l'automne, travail secondaire au printemps",
                comment: "Travail du sol Chisel ou pulvérisateur à l'automne, travail secondaire au printemps"
            ),
            NSLocalizedString(
                "Déchaumage au printemps et travail secondaire au printemps",
                comment: "Travail du sol Déchaumage au printemps et travail secondaire au printemps"
            ),
            NSLocalizedString(
                "Semi direct ou bilons",
                comment: "Travail du sol Semi direct ou bilons"
            )
        ]
    }

    static func getTitle() -> String {
        NSLocalizedString("Travail du sol", comment: "Title travail du sol")
    }
    
    static func getTypeValue() -> String {
        "travailSol"
    }
}
