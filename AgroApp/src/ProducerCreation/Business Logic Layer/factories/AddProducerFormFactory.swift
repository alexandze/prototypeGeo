//
//  AddProducerFormFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-11.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class AddProducerFormFactoryImpl: AddProducerFormFactory {
    
    let firstNameTitle = "Prénom"
    let lastNameTitle = "Nom"
    let emailTitle = "Email"
    let nimTitle = "NIM"
    let addButtonTitle = "+"
    
    let firstNamePattern = "*"
    let lastNamePattern = "*"
    let emailPattern = "*"
    let nimPattern = "*"
    
    func makeElementsUIData() -> [ElementUIData] {
        [
            self.makeFirstNameInputElement(),
            self.makeLastNameInputElement(),
            self.makeEmailInputElement(),
            self.makeNimInputElement(),
            self.makeAddNimButtonElement()
        ]
    }
    
    func makeAddNimButtonElement() -> ElementUIData {
        ButtonElement(
            id: UUID().uuidString,
            title: addButtonTitle,
            isEnabled: true,
            action: .add
        )
    }
    
    func makeFirstNameInputElement(value: String? = nil) -> ElementUIData {
        makeInputElement(title: firstNameTitle, value: value, regexPattern: firstNamePattern)
    }
    
    func makeLastNameInputElement(value: String? = nil) -> ElementUIData {
        makeInputElement(title: lastNameTitle, value: value, regexPattern: lastNamePattern)
    }
    
    func makeEmailInputElement(value: String? = nil) -> ElementUIData {
        makeInputElement(title: self.emailTitle, value: value, regexPattern: emailPattern)
    }
    
    func makeNimInputElement(value: String? = nil) -> ElementUIData {
        makeInputElement(title: self.nimTitle, value: value, regexPattern: nimPattern)
    }
    
    func makeInputElement(title: String, value: String? = nil, regexPattern: String? = nil) -> ElementUIData {
        let regularExpression = self.makeRegularExpression(regexPattern)
        
        return InputElement(
            id: UUID().uuidString,
            title: title,
            value: value ?? "",
            isValid: isInputValueValid(value, regularExpression),
            isRequired: true,
            regex: regularExpression
        )
    }
    
    private func makeRegularExpression(_ regexPattern: String?) -> NSRegularExpression? {
        guard let regexPattern = regexPattern else {
            return try? NSRegularExpression(pattern: "*", options: [])
        }
        
        return try? NSRegularExpression(pattern: regexPattern, options: [])
    }
    
    private func isInputValueValid(_ value: String?, _ regularExpression: NSRegularExpression?) -> Bool {
        guard let value = value,
            let regularExpression = regularExpression,
            !value.isEmpty
            else { return false }
        
        return regularExpression.matches(in: value, range: NSRange(location: 0, length: value.count)).count == 1
    }
}

protocol AddProducerFormFactory {
    func makeElementsUIData() -> [ElementUIData]
}
