//
//  ConditionProfilCultural.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum ConditionProfilCultural: Int, SelectValue, Codable {
    case bonne = 1
    case presenceZoneRisques
    case dominanceZoneRisque
    
    func getValue() -> String {
        switch self {
        case .bonne:
            return ConditionProfilCultural.getValues()[0]
        case .presenceZoneRisques:
            return ConditionProfilCultural.getValues()[1]
        case .dominanceZoneRisque:
            return ConditionProfilCultural.getValues()[2]
        }
    }
    
    static func getTupleValues() -> [(Int, String)] {
        [
            (
                ConditionProfilCultural.bonne.rawValue,
                getValues()[0]
            ),
            (
                ConditionProfilCultural.presenceZoneRisques.rawValue,
                getValues()[1]
            ),
            (
                ConditionProfilCultural.dominanceZoneRisque.rawValue,
                getValues()[2]
            )
        ]
    }
    
    static func getValues() -> [String] {
        [
            NSLocalizedString(
                "Bonne",
                comment: "Condition du profil cultural Bonne"
            ),
            NSLocalizedString(
                "Présence de zone à risque",
                comment: "Condition du profil cultural Présence de zone à risque"
            ),
            NSLocalizedString(
                "Dominance de zone à risque",
                comment: "Condition du profil cultural Dominance de zone à risque"
            )
        ]
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Condition du profil cultural",
            comment: "Condition du profil cultural"
        )
    }
    
    static func getTypeValue() -> String {
        "conditionProfilCultural"
    }
}
