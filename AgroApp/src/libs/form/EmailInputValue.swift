//
//  EmailInputValue.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-07.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct EmailInputValue: InputValue {
    var value: String
    
    static func getRegexPattern() -> String {
        "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
    }
    
    static func getUnitType() -> String {
        ""
    }
    
    static func make(value: String) -> InputValue? {
        EmailInputValue(value: value)
    }
    
    func getValue() -> String {
        value
    }
    
    static func getTypeValue() -> String {
        "email"
    }
    
    static func getTitle() -> String {
        "Email"
    }
}
