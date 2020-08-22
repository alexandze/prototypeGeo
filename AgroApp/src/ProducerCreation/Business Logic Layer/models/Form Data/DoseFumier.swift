//
//  DoseFumier.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct DoseFumier: InputValue {
    var value: Int
    
    func getValue() -> String {
        String(value)
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Dose du fumier (quantité)",
            comment: "Dose du fumier (quantité)"
        )
    }
    
    static func getUnitType() -> String {
        UnitType.quantity.convertToString()
    }
    
    static func getRegexPattern() -> String {
        // TODO les doses fumiers doivent etre superieure a zero
        "^\\d*$"
    }
    
    static func getTypeValue() -> String {
        "doseFumier"
    }
    
    static func make(value: String) -> InputValue? {
        guard let value = Int(value) else {
            return nil
        }
        
        return DoseFumier(value: value)
    }
}
