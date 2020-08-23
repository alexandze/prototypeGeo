//
//  BandeRiveraine.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum BandeRiveraine: Int, SelectValue, Codable {
    case pasApplique
    case inferieura1M
    case de1A3M
    case de4MEtPlus
    
    func getValue() -> String {
        switch self {
        case .pasApplique:
            return BandeRiveraine.getValues()[0]
        case .inferieura1M:
            return BandeRiveraine.getValues()[1]
        case .de1A3M:
            return BandeRiveraine.getValues()[2]
        case .de4MEtPlus:
            return BandeRiveraine.getValues()[3]
        }
    }
    
    func getRawValue() -> Int {
        self.rawValue
    }
    
    static func getTupleValues() -> [(Int, String)] {
        [
            (
                BandeRiveraine.pasApplique.rawValue,
                getValues()[0]
            ),
            (
                BandeRiveraine.inferieura1M.rawValue,
                getValues()[1]
            ),
            (
                BandeRiveraine.de1A3M.rawValue,
                getValues()[2]
            ),
            (
                BandeRiveraine.de4MEtPlus.rawValue,
                getValues()[3]
            )
        ]
    }
    
    static func getValues() -> [String] {
        [
            NSLocalizedString("Ne s'applique pas", comment: "Bande riveraine ne s'applique pas"),
            NSLocalizedString("Inférieur à 1m", comment: "Bande riveraine Inférieur à 1m"),
            NSLocalizedString("1 à 3m", comment: "Bande riveraine1 à 3m"),
            NSLocalizedString("4m et plus", comment: "Bande riveraine 4m et plus")
        ]
    }

    static func getTitle() -> String {
        NSLocalizedString("Bande riveraine", comment: "Titre bande riveraine")
    }
    
    static func getTypeValue() -> String {
        "bandeRiveraine"
    }
    
    static func make(rawValue: Int) -> SelectValue? {
        self.init(rawValue: rawValue)
    }
}
