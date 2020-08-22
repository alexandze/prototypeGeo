//
//  AlMehlich3.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct AlMehlich3: InputValue {
    var value: Percentage
    
    func getValue() -> String {
        String(value)
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "AL Mehlich-3",
            comment: "AL Mehlich-3"
        )
    }
    
    static func getUnitType() -> String {
        UnitType.percentage.convertToString()
    }

    static func getRegexPattern() -> String {
        "^\\d*\\.?\\d*$"
    }
    
    static func getTypeValue() -> String {
        "alMehlich3"
    }
    
    static func make(value: String) -> InputValue? {
        guard let value = Percentage(value) else {
            return nil
        }
        
        return AlMehlich3(value: value)
    }
}
