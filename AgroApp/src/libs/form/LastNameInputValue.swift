//
//  LastNameInputValue.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-07.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct LastNameInputValue: InputValue {
    var value: String
    
    static func getRegexPattern() -> String {
        "^[A-Za-z àáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð,.'-]{2,50}$"
    }
    
    static func getUnitType() -> String {
        ""
    }
    
    static func make(value: String) -> InputValue? {
        LastNameInputValue(value: value)
    }
    
    func getValue() -> String {
        value
    }
    
    static func getTypeValue() -> String {
        "lastName"
    }
    
    static func getTitle() -> String {
        "Nom"
    }
}
