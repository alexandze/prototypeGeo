//
//  InputValue.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-07.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

protocol InputValue: ValueForm {
    static func getRegexPattern() -> String
    static func getUnitType() -> String
    static func make(value: String) -> InputValue?
}
