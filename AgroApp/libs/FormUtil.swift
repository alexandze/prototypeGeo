//
//  FormUtil.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-08.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

protocol ElementUIData {
    var type: String {get set}
    var title: String {get set}
}

struct InputElement: ElementUIData {
    static let TYPE = "INPUT_ELEMENT"
    var id: String
    var type: String = InputElement.TYPE
    var title: String
    var value: String
    var isValid: Bool
    var isRequired: Bool
    var regex: NSRegularExpression?
}

struct InputElementWithRemoveButton: ElementUIData {
    static let TYPE = "INPUT_ELEMENT_REMOVE_BUTTON"
    var id: String
    var type: String
    var title: String
    var isValid: Bool
    var isRequired: Bool
    var action: ElementFormAction
    var regex: NSRegularExpression?
}

struct ButtonElement: ElementUIData {
    static let TYPE = "BUTTON"
    var id: String
    var type: String = ButtonElement.TYPE
    var title: String
    var isEnabled: Bool
    var action: ElementFormAction
}

enum ElementFormAction {
    case add
    case remove
}
