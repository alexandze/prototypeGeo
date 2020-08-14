//
//  AddProducerFormFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-11.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import SwiftUI

class AddProducerFormFactoryImpl: AddProducerFormFactory {

    let firstNameTitle = "Prénom"
    let lastNameTitle = "Nom"
    let emailTitle = "Email"
    let nimTitle = "NIM"
    let addButtonTitle = "+"
    let firstNamePattern = "[A-Za-z àáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð,.'-]{2,50}"
    let lastNamePattern = "[A-Za-z àáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð,.'-]{2,50}"
    let emailPattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
    let nimPattern = "^[A-Z0-9]{2,}$"
    let defaultPattern = ".+?$"

    func makeElementsUIData() -> [UtilElementUIDataSwiftUI] {
        [
            self.makeFirstNameInputUtilElementUIDataSwiftUI(),
            self.makeLastNameInputUtilElementUIDataSwiftUI(),
            self.makeEmailInputUtilElementUIDataSwiftUI(),
            self.makeNimInputUtilElementUIDataSwiftUI(),
            self.makeAddNimButtonUtilElementUIDataSwiftUI()
        ]
    }

    func makeFirstNameInputUtilElementUIDataSwiftUI(value: String? = nil) -> UtilElementUIDataSwiftUI {
        let inputElement = makeInputElement(
            title: firstNameTitle,
            value: value,
            regexPattern: firstNamePattern
        )

        return makeUtilElementUIDataSwiftUI(inputElement: inputElement)
    }

    func makeLastNameInputUtilElementUIDataSwiftUI(value: String? = nil) -> UtilElementUIDataSwiftUI {
        let inputElement = makeInputElement(
            title: lastNameTitle,
            value: value,
            regexPattern: lastNamePattern
        )

        return makeUtilElementUIDataSwiftUI(inputElement: inputElement)
    }

    func makeEmailInputUtilElementUIDataSwiftUI(value: String? = nil) -> UtilElementUIDataSwiftUI {
        let inputElement = makeInputElement(
            title: self.emailTitle,
            value: value,
            regexPattern: emailPattern,
            isRequired: false,
            keyboardType: .email
        )

        return makeUtilElementUIDataSwiftUI(inputElement: inputElement)
    }

    func makeNimInputUtilElementUIDataSwiftUI(value: String? = nil) -> UtilElementUIDataSwiftUI {
        let inputElement = makeInputElement(
            title: self.nimTitle,
            value: value,
            regexPattern: nimPattern
        )

        return makeUtilElementUIDataSwiftUI(inputElement: inputElement)
    }

    func makeAddNimButtonUtilElementUIDataSwiftUI(isEnabled: Bool? = nil) -> UtilElementUIDataSwiftUI {
        let button = ButtonElement(
            title: addButtonTitle,
            isEnabled: isEnabled ?? true,
            action: ElementFormAction.add.rawValue
        )

        return UtilElementUIDataSwiftUI(elementUIData: button)
    }

    func makeInputElement(
        title: String,
        value: String? = nil,
        regexPattern: String? = nil,
        isRequired: Bool? = nil,
        keyboardType: KeyboardType = .normal
    ) -> InputElement {
        InputElement(
            title: title,
            value: value ?? "",
            isValid: false,
            isRequired: isRequired ?? true,
            regexPattern: regexPattern ?? self.defaultPattern,
            keyboardType: keyboardType
        )
    }

    func makeUtilElementUIDataSwiftUI(inputElement: InputElement) -> UtilElementUIDataSwiftUI {
        let regularExpression = self.makeRegularExpression(inputElement.regexPattern)
        var copyInputElement = inputElement
        copyInputElement.isValid = self.isInputValueValid(copyInputElement.value, regularExpression)

        return UtilElementUIDataSwiftUI(
            elementUIData: copyInputElement,
            regularExpression: regularExpression
        )
    }

    private func makeRegularExpression(_ regexPattern: String?) -> NSRegularExpression? {
        guard let regexPattern = regexPattern else {
            return try? NSRegularExpression(pattern: self.defaultPattern, options: [.caseInsensitive])
        }

        return try? NSRegularExpression(pattern: regexPattern, options: [.caseInsensitive])
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
    func makeElementsUIData() -> [UtilElementUIDataSwiftUI]
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
