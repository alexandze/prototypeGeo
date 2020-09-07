//
//  Producer.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-15.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct Producer {
    var uuid = UUID()
    var firstName: FirstNameInputValue?
    var lastName: LastNameInputValue?
    var email: EmailInputValue?
    var enterprises: [Enterprise] = []
}

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
