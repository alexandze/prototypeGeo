//
//  FormUtil.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-08.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - ElementUIData

protocol ElementUIData {
    var id: UUID {get set }
    var type: String {get set}
    var title: String {get set}
}

class ElementUIDataObservable: ObservableObject, Identifiable {
    var id = UUID()
    var type: String
    var title: String

    init(id: UUID? = nil, type: String, title: String) {
        self.type = type
        self.title = title
        id.map { self.id = $0 }
    }
}

// MARK: - ImputElementData

protocol InputElementData: ElementUIData {
    var type: String {get set}
    var title: String {get set}
    var value: String? {get set}
    var isValid: Bool {get set}
    var isRequired: Bool {get set}
    var regexPattern: String {get set}
    var keyboardType: KeyboardType { get set}
}

class InputElementDataObservable: ElementUIDataObservable {
    @Published var value: String
    var isValid: Bool
    var isRequired: Bool
    var regexPattern: String
    var keyboardType: KeyboardType
    var regex: NSRegularExpression?
    var number: Int?
    var unitType: String?
    var typeValue: String?
    

    init(
        id: UUID? = nil,
        type: String,
        title: String,
        value: String,
        isValid: Bool,
        isRequired: Bool,
        regexPattern: String,
        keyboardType: KeyboardType = .normal,
        regex: NSRegularExpression? = nil,
        number: Int? = nil,
        unitType: String? = nil,
        typeValue: String? = nil
    ) {
        self.value = value
        self.isValid = isValid
        self.isRequired = isRequired
        self.regexPattern = regexPattern
        self.keyboardType = keyboardType
        self.regex = regex
        self.number = number
        self.unitType = unitType
        self.typeValue = typeValue
        
        if let id = id {
            super.init(id: id, type: type, title: title)
            return
        }
        
        super.init(type: type, title: title)
    }

    func isInputValid() -> Bool {
        guard let regex = self.regex else {
            return true
        }

        guard !self.value.isEmpty else {
            return false
        }

        let valueTrim = self.value.trimmingCharacters(in: .whitespacesAndNewlines)
        return regex.matches(in: valueTrim, range: NSRange(location: 0, length: valueTrim.count)).count == 1
    }
}

// MARK: - ImputElement

struct InputElement: InputElementData {
    static let TYPE_ELEMENT = "INPUT_ELEMENT"
    var id: UUID = UUID()
    var type: String = InputElement.TYPE_ELEMENT
    var title: String
    var value: String?
    var isValid: Bool
    var isRequired: Bool
    var regexPattern: String
    var keyboardType: KeyboardType = .normal
    var unitType: String?
    var typeValue: String?
    var regex: NSRegularExpression?
    
    func toInputElementObservable() -> InputElementObservable {
        InputElementObservable(
            id: id,
            type: type,
            title: title,
            value: value ?? "",
            isValid: isValid,
            isRequired: isRequired,
            regexPattern: regexPattern,
            keyboardType: keyboardType,
            regex: regex,
            unitType: unitType,
            typeValue: typeValue
        )
    }
}

class InputElementObservable: InputElementDataObservable {
    static let TYPE_ELEMENT = "INPUT_ELEMENT"

    override init(
        id: UUID? = nil,
        type: String? = nil,
        title: String,
        value: String,
        isValid: Bool,
        isRequired: Bool,
        regexPattern: String,
        keyboardType: KeyboardType = .normal,
        regex: NSRegularExpression? = nil,
        number: Int? = nil,
        unitType: String? = nil,
        typeValue: String? = nil
    ) {
        super.init(
            id: id,
            type: type ?? InputElementObservable.TYPE_ELEMENT,
            title: title,
            value: value,
            isValid: isValid,
            isRequired: isRequired,
            regexPattern: regexPattern,
            keyboardType: keyboardType,
            regex: regex,
            number: number,
            unitType: unitType,
            typeValue: typeValue
        )
    }
    
    func toInputElement() -> InputElement {
        InputElement(
            id: id,
            type: type,
            title: title,
            value: value,
            isValid: isValid,
            isRequired: isRequired,
            regexPattern: regexPattern,
            keyboardType: keyboardType,
            unitType: unitType,
            typeValue: typeValue,
            regex: regex
        )
    }

    static func makeDefault() -> InputElementObservable {
        InputElementObservable(title: "", value: "", isValid: false, isRequired: true, regexPattern: ".+?$")
    }
}

// MARK: - InputElementWithRemoveButton

struct InputElementWithRemoveButton: InputElementData {
    static let TYPE_ELEMENT = "INPUT_ELEMENT_REMOVE_BUTTON"
    var id: UUID = UUID()
    var type: String = InputElementWithRemoveButton.TYPE_ELEMENT
    var title: String
    var value: String?
    var isValid: Bool
    var isRequired: Bool
    var action: String
    var regexPattern: String
    var keyboardType: KeyboardType = .normal
}

class InputElementWithRemoveButtonObservable: InputElementDataObservable {
    static let TYPE_ELEMENT = "INPUT_ELEMENT_REMOVE_BUTTON"
    var action: String

    init(
        title: String,
        value: String,
        isValid: Bool,
        isRequired: Bool,
        action: String,
        regexPattern: String,
        keyboardType: KeyboardType = .normal,
        regex: NSRegularExpression? = nil,
        number: Int? = nil
    ) {
        self.action = action

        super.init(
            type: InputElementWithRemoveButtonObservable.TYPE_ELEMENT,
            title: title,
            value: value,
            isValid: isValid,
            isRequired: isRequired,
            regexPattern: regexPattern,
            keyboardType: keyboardType,
            regex: regex,
            number: number
        )
    }

    static func makeDefault() -> InputElementWithRemoveButtonObservable {
        InputElementWithRemoveButtonObservable(title: "", value: "", isValid: false, isRequired: true, action: ElementFormAction.remove.rawValue, regexPattern: ".+?$")
    }
}

// MARK: - ButtonElement

struct ButtonElement: ElementUIData {
    static let TYPE_ELEMENT = "BUTTON"
    var id = UUID()
    var type: String = ButtonElement.TYPE_ELEMENT
    var title: String
    var isEnabled: Bool
    var action: String
    var backgroundColor: String?
    var unitType: String?
}

class ButtonElementObservable: ElementUIDataObservable {
    static let TYPE_ELEMENT = "BUTTON"
    var isEnabled: Bool
    var action: String

    init(
        title: String,
        isEnabled: Bool,
        action: String
    ) {
        self.isEnabled = isEnabled
        self.action = action
        super.init(type: ButtonElementObservable.TYPE_ELEMENT, title: title)
    }

    static func makeDefault() -> ButtonElementObservable {
        ButtonElementObservable(title: "", isEnabled: false, action: ElementFormAction.add.rawValue)
    }
}

// MARK: - SelectElement

struct SelectElement: ElementUIData {
    static let TYPE_ELEMENT = "SELECT_ELEMENT"
    var id: UUID = UUID()
    var type: String = SelectElement.TYPE_ELEMENT
    var title: String
    var value: String?
    var isValid: Bool
    var isRequired: Bool
    var values: [String]
    var typeValue: String
    var rawValue: Int?
}

enum ElementFormAction: String {
    case add
    case remove
}

enum BackgroundColor: String {
    case gray
}

enum KeyboardType: String {
    case normal
    case email

    func getUIKeyboardType() -> UIKeyboardType {
        switch self {
        case .normal:
            return .default
        case .email:
            return .emailAddress
        }
    }
}


struct RowWithButton: ElementUIData {
    static let TYPE_ELEMENT = "ROW_WITH_BUTTON"
    var id: UUID = UUID()
    var type: String = "ROW"
    var title: String
    var subTitle: String?
    var action: String
}

struct ElementUIListData: ElementUIData {
    static let TYPE_ELEMENT = "ELEMENT_UI_LIST_DATA"
    var id: UUID = UUID()
    var type: String = ElementUIListData.TYPE_ELEMENT
    var title: String
    var elements: [ElementUIData]
    var index: Int
}
