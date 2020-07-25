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
    var field: Field?
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
    var isPrintMessageErrorInputValues: [Bool]?

    enum SubAction {
        case containerElementSelectedOnListActionSuccess
        case checkIfFormIsDirtyActionSuccess
        case checkIfInputValueIsValidActionSuccess
        case updateContainerElementActionSuccess
    }

    func changeValue(
        containerElement: CulturalPracticeContainerElement? = nil,
        field: Field? = nil,
        isDirty: Bool? = nil,
        subAction: SubAction? = nil,
        inputElements: [CulturalPracticeInputElement]? = nil,
        selectElements: [CulturalPracticeMultiSelectElement]? = nil,
        inputValues: [String]? = nil,
        selectValues: [Int]? = nil,
        previousInputValues: [String]? = nil,
        previousSelectValues: [Int]? = nil,
        isFormValid: Bool? = nil,
        inputRegularExpressions: [NSRegularExpression]? = nil,
        isPrintMessageErrorInputValues: [Bool]? = nil
    ) -> ContainerFormCulturalPracticeState {
        ContainerFormCulturalPracticeState(
            uuidState: UUID().uuidString,
            containerElement: containerElement ?? self.containerElement,
            field: field ?? self.field,
            isDirty: isDirty ?? self.isDirty,
            subAction: subAction ?? self.subAction,
            inputElements: inputElements ?? self.inputElements,
            selectElements: selectElements ?? self.selectElements,
            inputValues: inputValues ?? self.inputValues,
            selectValues: selectValues ?? self.selectValues,
            previousInputValues: previousInputValues ?? self.previousInputValues,
            previousSelectValues: previousSelectValues ?? self.previousSelectValues,
            isFormValid: isFormValid ?? self.isFormValid,
            inputRegularExpressions: inputRegularExpressions ?? self.inputRegularExpressions,
            isPrintMessageErrorInputValues: isPrintMessageErrorInputValues ?? self.isPrintMessageErrorInputValues
        )
    }
}
