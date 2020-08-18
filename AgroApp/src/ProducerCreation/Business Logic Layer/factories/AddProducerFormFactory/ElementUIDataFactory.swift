//
//  ElementUIDataFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-16.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class ElementUIDataFactoryImpl: ElementUIDataFactory {

    let nimTitle = "NIM"
    private let firstNameTitle = "Prénom"
    private let lastNameTitle = "Nom"
    private let emailTitle = "Email"
    private let addButtonTitle = "NIM"
    private let firstNamePattern = "[A-Za-z àáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð,.'-]{2,50}"
    private let lastNamePattern = "[A-Za-z àáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð,.'-]{2,50}"
    private let emailPattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
    private let nimPattern = "^[A-Z0-9]{2,}$"
    private let defaultPattern = ".+?$"

    func makeElementUIDataObservableList() -> [ElementUIDataObservable] {
        [
            self.makeFirstNameInputElementObservable(),
            self.makeLastNameInputElementObservable(),
            self.makeEmailInputElementObservable(),
            self.makeNimInputElementObservable(number: 1)
        ]
    }

    func makeAddNimButtonElementObservable(isEnabled: Bool? = nil) -> ButtonElementObservable {
        ButtonElementObservable(
            title: addButtonTitle,
            isEnabled: isEnabled ?? true,
            action: ElementFormAction.add.rawValue
        )
    }

    func makeNimInputElementWithRemoveButton(value: String? = nil, number: Int? = nil) -> InputElementWithRemoveButtonObservable {
        makeInputElementWithRemoveButtonObservable(
            title: "\(self.nimTitle)",
            value: value ?? "",
            regexPattern: self.nimPattern,
            isRequired: true,
            keyboardType: .normal,
            number: number
        )
    }

    func getMaxNim() -> Int {
        Enterprise.MAX_ENTERPRISE
    }

    func getNimTitle() -> String {
        nimTitle
    }

    private func makeFirstNameInputElementObservable(value: String? = nil) -> ElementUIDataObservable {
        makeInputElementObservable(
            title: firstNameTitle,
            value: value,
            regexPattern: firstNamePattern
        )
    }

    private func makeLastNameInputElementObservable(value: String? = nil) -> ElementUIDataObservable {
        makeInputElementObservable(
            title: lastNameTitle,
            value: value,
            regexPattern: lastNamePattern
        )
    }

    private func makeEmailInputElementObservable(value: String? = nil) -> ElementUIDataObservable {
        makeInputElementObservable(
            title: self.emailTitle,
            value: value,
            regexPattern: emailPattern,
            isRequired: false,
            keyboardType: .email
        )
    }

    private func makeNimInputElementObservable(value: String? = nil, number: Int? = nil) -> ElementUIDataObservable {
        makeInputElementObservable(
            title: self.nimTitle,
            value: value,
            regexPattern: nimPattern,
            number: number
        )
    }

    private func makeInputElementWithRemoveButtonObservable(
        title: String,
        value: String? = nil,
        regexPattern: String? = nil,
        isRequired: Bool? = nil,
        keyboardType: KeyboardType = .normal,
        number: Int? = nil
    ) -> InputElementWithRemoveButtonObservable {
        let inputElementWithRemoveButton = InputElementWithRemoveButtonObservable(
            title: title,
            value: value ?? "",
            isValid: false,
            isRequired: isRequired ?? true,
            action: ElementFormAction.remove.rawValue,
            regexPattern: regexPattern ?? self.defaultPattern,
            number: number
        )

        inputElementWithRemoveButton.regex = self.makeRegularExpression(inputElementWithRemoveButton.regexPattern)
        inputElementWithRemoveButton.isValid = inputElementWithRemoveButton.isInputValid()
        return inputElementWithRemoveButton
    }

    private func makeInputElementObservable(
        title: String,
        value: String? = nil,
        regexPattern: String? = nil,
        isRequired: Bool? = nil,
        keyboardType: KeyboardType = .normal,
        number: Int? = nil
    ) -> InputElementObservable {
        let inputElement = InputElementObservable(
            title: title,
            value: value ?? "",
            isValid: false,
            isRequired: isRequired ?? true,
            regexPattern: regexPattern ?? self.defaultPattern,
            keyboardType: keyboardType,
            number: number
        )

        inputElement.regex =  self.makeRegularExpression(inputElement.regexPattern)
        inputElement.isValid = inputElement.isInputValid()
        return inputElement
    }

    private func makeRegularExpression(_ regexPattern: String?) -> NSRegularExpression? {
        guard let regexPattern = regexPattern else {
            return try? NSRegularExpression(pattern: self.defaultPattern, options: [.caseInsensitive])
        }

        return try? NSRegularExpression(pattern: regexPattern, options: [.caseInsensitive])
    }

}

protocol ElementUIDataFactory {
    func getNimTitle() -> String
    func makeElementUIDataObservableList() -> [ElementUIDataObservable]
    func makeAddNimButtonElementObservable(isEnabled: Bool?) -> ButtonElementObservable
    func getMaxNim() -> Int
    func makeNimInputElementWithRemoveButton(value: String?, number: Int?) -> InputElementWithRemoveButtonObservable
}
