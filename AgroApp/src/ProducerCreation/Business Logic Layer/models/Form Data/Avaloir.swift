//
//  Avaloir.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum Avaloir: Int, SelectValue, Codable {
    case empty
    case absente
    case captagePartiel
    case captageSystematique

    func getTupleValues() -> [(Int, String)] {
        [
            (
                Avaloir.absente.rawValue,
                getValues()[0]
            ),
            (
                Avaloir.captagePartiel.rawValue,
                getValues()[1]
            ),
            (
                Avaloir.captageSystematique.rawValue,
                getValues()[2]
            )
        ]
    }
    
    func getValues() -> [String] {
        return [
            NSLocalizedString("Absente", comment: "Avaloir absente"),
            NSLocalizedString("Captage Partiel", comment: "Avaloir captage partiel"),
            NSLocalizedString("Captage systématique", comment: "Avaloir Captage systématique")
        ]
    }

    func getValue() -> String? {
        switch self {
        case .absente:
            return NSLocalizedString("Absente", comment: "Avaloir absente")
        case .captagePartiel:
            return NSLocalizedString("Captage Partiel", comment: "Avaloir captage partiel")
        case .captageSystematique:
            return NSLocalizedString("Captage systématique", comment: "Avaloir Captage systématique")
        case .empty:
            return nil
        }
    }

    func getTitle() -> String {
        NSLocalizedString("Avaloir", comment: "Titre avaloir")
    }
    
    func isRequired() -> Bool {
        true
    }
    
    func getUnitType() -> String? {
        nil
    }
    
    func getTypeValue() -> String {
        return "Avaloir"
    }
}

