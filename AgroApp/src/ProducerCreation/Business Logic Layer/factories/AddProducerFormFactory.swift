//
//  AddProducerFormFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-11.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import SwiftUI

class AddProducerFormFactoryImpl: AddProducerFormFactory {

    private let firstNameTitle = "Prénom"
    private let lastNameTitle = "Nom"
    private let emailTitle = "Email"
    private let nimTitle = "NIM"
    private let addButtonTitle = "+"
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
            self.makeNimInputElementObservable(),
            self.makeAddNimButtonElementObservable()
        ]
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

    private func makeNimInputElementObservable(value: String? = nil) -> ElementUIDataObservable {
        makeInputElementObservable(
            title: self.nimTitle,
            value: value,
            regexPattern: nimPattern
        )
    }

    private func makeAddNimButtonElementObservable(isEnabled: Bool? = nil) -> ElementUIDataObservable {
        ButtonElementObservable(
            title: addButtonTitle,
            isEnabled: isEnabled ?? true,
            action: ElementFormAction.add.rawValue
        )
    }

    private func makeNimInputElementWithRemoveButton(numberNim: Int, value: String? = nil) -> InputElementWithRemoveButtonObservable {
        makeInputElementWithRemoveButtonObservable(
            title: "\(self.nimTitle) \(numberNim)",
            value: value ?? "",
            regexPattern: self.nimPattern,
            isRequired: true,
            keyboardType: .normal
        )
    }

    private func makeInputElementWithRemoveButtonObservable(
        title: String,
        value: String? = nil,
        regexPattern: String? = nil,
        isRequired: Bool? = nil,
        keyboardType: KeyboardType = .normal
    ) -> InputElementWithRemoveButtonObservable {
        let inputElementWithRemoveButton = InputElementWithRemoveButtonObservable(
            title: title,
            value: value ?? "",
            isValid: false,
            isRequired: isRequired ?? true,
            action: ElementFormAction.remove.rawValue,
            regexPattern: regexPattern ?? self.defaultPattern
        )

        inputElementWithRemoveButton.isValid = inputElementWithRemoveButton.isInputValid()
        return inputElementWithRemoveButton
    }

    private func makeInputElementObservable(
        title: String,
        value: String? = nil,
        regexPattern: String? = nil,
        isRequired: Bool? = nil,
        keyboardType: KeyboardType = .normal
    ) -> InputElementObservable {
        let inputElement = InputElementObservable(
            title: title,
            value: value ?? "",
            isValid: false,
            isRequired: isRequired ?? true,
            regexPattern: regexPattern ?? self.defaultPattern,
            keyboardType: keyboardType,
            regex: self.makeRegularExpression(regexPattern)
        )

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

protocol AddProducerFormFactory {
    func makeElementUIDataObservableList() -> [ElementUIDataObservable]
}

class UtilElementUIDataSwiftUI: ObservableObject, Identifiable {
    var uuid = UUID()
    var elementUIData: ElementUIData
    @Published var valueState = ""
    var regularExpression: NSRegularExpression?

    init(
        elementUIData: ElementUIData,
        valueState: String? = nil,
        regularExpression: NSRegularExpression? = nil
    ) {
        self.elementUIData = elementUIData

        if let valueState = valueState {
            self.valueState = valueState
        }

        self.regularExpression = regularExpression
    }
}
