//
//  FirstNameInputValue.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-07.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct FirstNameInputValue: InputValue {
    var value: String
    
    static func getRegexPattern() -> String {
        "^[A-Za-z àáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð,.'-]{2,50}$"
    }
    
    static func getUnitType() -> String {
        ""
    }
    
    static func make(value: String) -> InputValue? {
        FirstNameInputValue(value: value)
    }
    
    func getValue() -> String {
        value
    }
    
    static func getTypeValue() -> String {
        "firstName"
    }
    
    static func getTitle() -> String {
        "Prénom"
    }
}
