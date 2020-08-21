//
//  DoseFumier.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct ç: InputValue {
    var dose: Int?

    func getTitle() -> String {
        NSLocalizedString(
            "Dose du fumier (quantité)",
            comment: "Dose du fumier (quantité)"
        )
    }

    func getValue() -> String? {
        dose != nil ? String(dose!) : nil
    }

    func getUnitType() -> UnitType? {
        .quantity
    }
    
    func isRequired() -> Bool {
        true
    }
    
    func getRegexPattern() -> String {
        // TODO les doses fumiers doivent etre superieure a zero
        "^\\d*$"
    }
    
    func getUnitType() -> String? {
        UnitType.quantity.convertToString()
    }
    
    func getTypeValue() -> String {
        "BandeRiveraine"
    }
}
