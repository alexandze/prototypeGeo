//
//  PasswordInputValue.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-07.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct PasswordInputValue: InputValue {
    var value: String
    
    static func getRegexPattern() -> String {
        // Minimum eight characters, at least one letter and one number
        "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
    }
    
    static func getUnitType() -> String {
        ""
    }
    
    static func make(value: String) -> InputValue? {
        PasswordInputValue(value: value)
    }
    
    func getValue() -> String {
        value
    }
    
    static func getTypeValue() -> String {
        "password"
    }
    
    static func getTitle() -> String {
        "Mot de passe"
    }
}
