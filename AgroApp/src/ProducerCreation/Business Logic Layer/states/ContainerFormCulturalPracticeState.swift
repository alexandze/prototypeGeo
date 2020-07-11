//
//  ContainerFormCulturalPracticeState.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-09.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct ContainerFormCulturalPracticeState: Equatable {
    static func == (lhs: ContainerFormCulturalPracticeState, rhs: ContainerFormCulturalPracticeState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var containerElement: CulturalPracticeContainerElement?
    var fieldType: FieldType?
    var isDirty: Bool?
    var subAction: SubAction?
    var inputElements: [CulturalPracticeInputElement]?
    var selectElements: [CulturalPracticeMultiSelectElement]?
    var inputValues: [String]?
    var selectValues: [Int]?
    var previousInputValues: [String]?
    var previousSelectValues: [Int]?
    var isFormValid: Bool?
    var inputRegularExpressions: [NSRegularExpression]?

    enum SubAction {
        case newFormData
        case newIsDirtyAndIsFormValidValue
    }

    func changeValue(
        containerElement: CulturalPracticeContainerElement? = nil,
        fieldType: FieldType? = nil,
        isDirty: Bool? = nil,
        subAction: SubAction? = nil,
        inputElements: [CulturalPracticeInputElement]? = nil,
        selectElements: [CulturalPracticeMultiSelectElement]? = nil,
        inputValues: [String]? = nil,
        selectValues: [Int]? = nil,
        previousInputValues: [String]? = nil,
        previousSelectValues: [Int]? = nil,
        isFormValid: Bool? = nil,
        inputRegularExpressions: [NSRegularExpression]? = nil
    ) -> ContainerFormCulturalPracticeState {
        ContainerFormCulturalPracticeState(
            uuidState: UUID().uuidString,
            containerElement: containerElement ?? self.containerElement,
            fieldType: fieldType ?? self.fieldType,
            isDirty: isDirty ?? self.isDirty,
            subAction: subAction ?? self.subAction,
            inputElements: inputElements ?? self.inputElements,
            selectElements: selectElements ?? self.selectElements,
            inputValues: inputValues ?? self.inputValues,
            selectValues: selectValues ?? self.selectValues,
            previousInputValues: previousInputValues ?? self.previousInputValues,
            previousSelectValues: previousSelectValues ?? self.previousSelectValues,
            isFormValid: isFormValid ?? self.isFormValid,
            inputRegularExpressions: inputRegularExpressions ?? self.inputRegularExpressions
        )
    }
}
