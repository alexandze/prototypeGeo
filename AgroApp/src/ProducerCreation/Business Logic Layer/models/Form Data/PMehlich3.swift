//
//  PMehlich3.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct PMehlich3: InputValue {
    var value: KilogramPerHectare
    
    func getValue() -> String {
        String(value)
    }
    
    static func getTitle() -> String {
        NSLocalizedString(
            "P Mehlich-3",
            comment: "Titre P Mehlich-3"
        )
    }
    
    static func getUnitType() -> String {
        UnitType.kgHa.convertToString()
    }
    
    static func getRegexPattern() -> String {
        "^\\d*\\.?\\d*$"
    }
    
    static func getTypeValue() -> String {
        "pMehlich3"
    }
    
    static func make(value: String) -> InputValue? {
        guard let value = KilogramPerHectare(value) else {
            return nil
        }
        
        return PMehlich3(value: value)
    }
}
