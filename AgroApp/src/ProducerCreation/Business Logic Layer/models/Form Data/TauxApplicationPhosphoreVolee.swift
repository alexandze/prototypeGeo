//
//  TauxApplicationPhosphoreVolee.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct TauxApplicationPhosphoreVolee: InputValue {
    var value: KilogramPerHectare
    
    func getValue() -> String {
        String(value)
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Taux d'application de phosphore (engrais minéraux à la volée)",
            comment: "Titre Taux d'application de phosphore (engrais minéraux à la volée)"
        )
    }
    
    static func getUnitType() -> String {
        UnitType.kgHa.convertToString()
    }

    static func getRegexPattern() -> String {
        "^\\d*\\.?\\d*$"
    }
    
    static func getTypeValue() -> String {
        "tauxApplicationPhosphoreVolee"
    }
    
    static func make(value: String) -> InputValue? {
        guard let value = Double(value) else {
            return nil
        }
        
        return TauxApplicationPhosphoreVolee(value: value)
    }
}
