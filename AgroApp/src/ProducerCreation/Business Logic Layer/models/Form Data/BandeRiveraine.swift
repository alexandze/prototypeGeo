//
//  BandeRiveraine.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum BandeRiveraine: Int, SelectValue, Codable {
    case empty
    case pasApplique
    case inferieura1M
    case de1A3M
    case de4MEtPlus

    func getTupleValues() -> [(Int, String)] {
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
    
    func getValues() -> [String] {
        [
            NSLocalizedString("Ne s'applique pas", comment: "Bande riveraine ne s'applique pas"),
            NSLocalizedString("Inférieur à 1m", comment: "Bande riveraine Inférieur à 1m"),
            NSLocalizedString("1 à 3m", comment: "Bande riveraine1 à 3m"),
            NSLocalizedString("4m et plus", comment: "Bande riveraine 4m et plus")
        ]
    }

    func getTitle() -> String {
        NSLocalizedString("Bande riveraine", comment: "Titre bande riveraine")
    }

    func getValue() -> String? {
        switch self {
        case .pasApplique:
            return NSLocalizedString("Ne s'applique pas", comment: "Bande riveraine ne s'applique pas")
        case .inferieura1M:
            return NSLocalizedString("Inférieur à 1m", comment: "Bande riveraine Inférieur à 1m")
        case .de1A3M:
            return NSLocalizedString("1 à 3m", comment: "Bande riveraine 1 à 3m")
        case .de4MEtPlus:
            return NSLocalizedString("4m et plus", comment: "Bande riveraine 4m et plus")
        case .empty:
            return nil
        }
    }

    func getUnitType() -> String? {
        return nil
    }
    
    func isRequired() -> Bool {
        true
    }
    
    func getTypeValue() -> String {
        "BandeRiveraine"
    }
}
