//
//  IdPleineTerre.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-30.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct IdPleineTerre: InputValue {
    let value: String
    
    static func getRegexPattern() -> String {
        "^[A-Z0-9]{2,}$"
    }
    
    static func getUnitType() -> String {
        ""
    }
    
    static func make(value: String) -> InputValue? {
        IdPleineTerre(value: value)
    }
    
    func getValue() -> String {
        value
    }
    // label Field.idPlienTerre
    static func getTypeValue() -> String {
        "idPleinTerre"
    }
    
    static func getTitle() -> String {
        "Id Pleine Terre"
    }
}
