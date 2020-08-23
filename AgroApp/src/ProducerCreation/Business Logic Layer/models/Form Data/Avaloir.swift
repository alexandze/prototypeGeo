//
//  Avaloir.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum Avaloir: Int, SelectValue, Codable {
    case absente = 1
    case captagePartiel
    case captageSystematique
    
    func getValue() -> String {
        switch self {
        case .absente:
            return Avaloir.getValues()[0]
        case .captagePartiel:
            return Avaloir.getValues()[1]
        case .captageSystematique:
            return Avaloir.getValues()[2]
        }
    }
    
    func getRawValue() -> Int {
        rawValue
    }
    
    static func getTupleValues() -> [(Int, String)] {
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
    
    static func getValues() -> [String] {
        return [
            NSLocalizedString("Absente", comment: "Avaloir absente"),
            NSLocalizedString("Captage Partiel", comment: "Avaloir captage partiel"),
            NSLocalizedString("Captage systématique", comment: "Avaloir Captage systématique")
        ]
    }
    
    static func getTitle() -> String {
        NSLocalizedString("Avaloir", comment: "Titre avaloir")
    }
    
    static func getTypeValue() -> String {
        "avaloir"
    }
    
    static func make(rawValue: Int) -> SelectValue? {
        self.init(rawValue: rawValue)
    }
}

