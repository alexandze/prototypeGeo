//
//  DrainageSouterrain.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum DrainageSouterrain: Int, SelectValue, Codable {
    case systematique = 1
    case partiel
    case absent

    static func getTupleValues() -> [(Int, String)] {
        [
            (
                DrainageSouterrain.systematique.rawValue,
                getValues()[0]
            ),
            (
                DrainageSouterrain.partiel.rawValue,
                getValues()[1]
            ),
            (
                DrainageSouterrain.absent.rawValue,
                getValues()[2]
            )
        ]
    }
    
    func getRawValue() -> Int {
        self.rawValue
    }

    func getValue() -> String {
        switch self {
        case .systematique:
            return DrainageSouterrain.getValues()[0]
        case .partiel:
            return DrainageSouterrain.getValues()[1]
        case .absent:
            return DrainageSouterrain.getValues()[2]
        }
    }
    
    static func getValues() -> [String] {
        [
            NSLocalizedString("Systématique", comment: "Drainage souterrain Systématique"),
            NSLocalizedString("Partiel", comment: "Drainage souterrain Partiel"),
            NSLocalizedString("Absent", comment: "Drainage souterrain absent")
        ]
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Drainage souterrain",
            comment: "Title Drainage souterrain"
        )
    }
    
    static func getTypeValue() -> String {
        "drainageSouterrain"
    }
    
    static func make(rawValue: Int) -> SelectValue? {
        self.init(rawValue: rawValue)
    }
}
