//
//  CouvertureDerobee.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum CouvertureDerobee: Int, SelectValue, Codable {
    case vrai = 1
    case faux = 0

    static func getTupleValues() -> [(Int, String)] {
        [
            (
                CouvertureDerobee.vrai.rawValue,
                getValues()[0]
            ),
            (
                CouvertureDerobee.faux.rawValue,
                getValues()[1]
            )
        ]
    }
    
    func getRawValue() -> Int {
        self.rawValue
    }
    
    static func getValues() -> [String] {
        [
            NSLocalizedString("Vrai", comment: "Couverture dérobée vrai"),
            NSLocalizedString("Faux", comment: "Couverture dérobée faux")
        ]
    }

    func getValue() -> String {
        switch self {
        case .vrai:
            return CouvertureDerobee.getValues()[0]
        case .faux:
            return CouvertureDerobee.getValues()[1]
        }
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Couverture dérobée",
            comment: "Title Couverture dérobée"
        )
    }
    
    static func getTypeValue() -> String {
        "couvertureDerobee"
    }
    
    static func make(rawValue: Int) -> SelectValue? {
        self.init(rawValue: rawValue)
    }
}
