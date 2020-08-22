//
//  CouvertureAssociee.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum CouvertureAssociee: Int, SelectValue, Codable {
    case vrai = 1
    case faux = 0

    static func getTupleValues() -> [(Int, String)] {
        [
            (
                CouvertureAssociee.vrai.rawValue,
                getValues()[0]
            ),
            (
                CouvertureAssociee.faux.rawValue,
                getValues()[1]
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .vrai:
            return CouvertureAssociee.getValues()[0]
        case .faux:
            return CouvertureAssociee.getValues()[1]
        }
    }
    
    static func getValues() -> [String] {
        [
            NSLocalizedString("Vrai", comment: "Couverture associée vrai"),
             NSLocalizedString("Faux", comment: "Couverture associée faux")
        ]
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Couverture associée",
            comment: "Title couverture associée"
        )
    }
    
    static func getTypeValue() -> String {
        "couvertureAssociee"
    }
}
