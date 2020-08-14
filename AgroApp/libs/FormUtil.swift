//
//  FormUtil.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-08.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import SwiftUI

protocol ElementUIData {
    var type: String {get set}
    var title: String {get set}
}

protocol InputElementData: ElementUIData {
    var type: String {get set}
    var title: String {get set}
    var value: String {get set}
    var isValid: Bool {get set}
    var isRequired: Bool {get set}
    var regexPattern: String {get set}
    var keyboardType: KeyboardType { get set}
}

struct InputElement: InputElementData {
    static let TYPE_ELEMENT = "INPUT_ELEMENT"
    var type: String = InputElement.TYPE_ELEMENT
    var title: String
    var value: String
    var isValid: Bool
    var isRequired: Bool
    var regexPattern: String
    var keyboardType: KeyboardType = .normal
}

struct InputElementWithRemoveButton: InputElementData {
    static let TYPE_ELEMENT = "INPUT_ELEMENT_REMOVE_BUTTON"
    var type: String = InputElementWithRemoveButton.TYPE_ELEMENT
    var title: String
    var value: String
    var isValid: Bool
    var isRequired: Bool
    var action: String
    var regexPattern: String
    var keyboardType: KeyboardType = .normal
}

struct ButtonElement: ElementUIData {
    static let TYPE = "BUTTON"
    var type: String = ButtonElement.TYPE
    var title: String
    var isEnabled: Bool
    var action: String
}

enum ElementFormAction: String {
    case add
    case remove
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
