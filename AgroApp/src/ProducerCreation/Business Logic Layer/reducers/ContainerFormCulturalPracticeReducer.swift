//
//  ContainerFormCulturalPracticeReducer.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-09.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func containerFormCulturalPracticeReducer(action: Action, state: ContainerFormCulturalPracticeState?) -> ContainerFormCulturalPracticeState {
        let state = state ?? ContainerFormCulturalPracticeState(uuidState: UUID().uuidString)

        switch action {
        case let action as ContainerFormCulturalPracticeAction.ContainerElementSelectedOnListAction:
            return ContainerFormCulturalPracticeHandler.handle(containerElementSelectedOnListAction: action, state)
        case let action as ContainerFormCulturalPracticeAction.CheckIfFormIsDirtyAndValidAction:
            return ContainerFormCulturalPracticeHandler.handle(checkIfFormIsDirtyAction: action, state)
        default:
            return state
        }
    }
}

class ContainerFormCulturalPracticeHandler {
    static func handle(
        containerElementSelectedOnListAction: ContainerFormCulturalPracticeAction.ContainerElementSelectedOnListAction,
        _ state: ContainerFormCulturalPracticeState
    ) -> ContainerFormCulturalPracticeState {
        let containerElement = containerElementSelectedOnListAction.containerElement
        let fieldType = containerElementSelectedOnListAction.field
        let subAction = containerElementSelectedOnListAction.subAction

        let inputElements = convertArrayOfElementProtocolToArrayOfInputElement(
            containerElement.culturalInputElement
        )

        let selectElements = converArrayOfElementProtocolToArrayOfSelectElement(
            containerElement.culturalPracticeMultiSelectElement
        )

        let inputValues = createInputValues(for: inputElements)
        let selectValues = createSelectValues(for: selectElements)
        let inputRegularExpressions = createInputRegularExpression(inputElements: inputElements)

        return state.changeValue(
            containerElement: containerElement,
            fieldType: fieldType,
            subAction: subAction,
            inputElements: inputElements,
            selectElements: selectElements,
            inputValues: inputValues,
            selectValues: selectValues,
            previousInputValues: inputValues,
            previousSelectValues: selectValues,
            inputRegularExpressions: inputRegularExpressions
        )
    }

    static func handle(
        checkIfFormIsDirtyAction: ContainerFormCulturalPracticeAction.CheckIfFormIsDirtyAndValidAction,
        _ state: ContainerFormCulturalPracticeState
    ) -> ContainerFormCulturalPracticeState {
        let currentInputValue = checkIfFormIsDirtyAction.inputValues
        let currentSelectValue = checkIfFormIsDirtyAction.selectValue

        let isInputValueDirty = isInputValuesDirty(
            previousInputValue: state.previousInputValues!,
            currentInputValue: currentInputValue
        )

        let isSelectValueDirty = isSelectValuesDirty(
        previousSelectValue: state.previousSelectValues!,
        currentSelectValue: currentSelectValue
        )

        let isDirty = (isInputValueDirty  || isSelectValueDirty)

        let isFormValid = isInputValuesValid(
            currentInputValues: currentInputValue,
            inputRegularExpression: state.inputRegularExpressions!
        )

        return state.changeValue(
            isDirty: isDirty,
            subAction: .newIsDirtyAndIsFormValidValue,
            isFormValid: isFormValid
        )
    }

    private static func isInputValuesValid(
        currentInputValues: [String],
        inputRegularExpression: [NSRegularExpression]
    ) -> Bool {
        var isValid = true
        var inputValue = ""

        (0..<currentInputValues.count).forEach { index in
            inputValue = currentInputValues[index].trimmingCharacters(in: .whitespacesAndNewlines)

            guard !inputValue.isEmpty &&
                inputRegularExpression[index].matches(in: inputValue, range: NSRange(location: 0, length: inputValue.count)).count == 1
                else {
                isValid = false
                return
            }
        }

        return isValid
    }

    private static func createInputRegularExpression(inputElements: [CulturalPracticeInputElement]) -> [NSRegularExpression] {
        inputElements.map { inputElement in
            let regex = type(of: inputElement.valueEmpty).getRegularExpression()
            return try! NSRegularExpression(pattern: regex!, options: [])
        }
    }

    private static func convertArrayOfElementProtocolToArrayOfInputElement(_ elementProtocols: [CulturalPracticeElementProtocol]) -> [CulturalPracticeInputElement] {
        var inputElements = [CulturalPracticeInputElement]()

        elementProtocols.forEach { elementProtocol in
            if let inputElement = elementProtocol as? CulturalPracticeInputElement {
                inputElements.append(inputElement)
            }
        }

        return inputElements
    }

    private static func isInputValuesDirty(
        previousInputValue: [String],
        currentInputValue: [String]
    ) -> Bool {
        var isDirty = false

        (0..<currentInputValue.count).forEach { index in
            if previousInputValue.indices.contains(index) &&
                currentInputValue[index] != previousInputValue[index] {
                isDirty = true
                return
            }
        }

        return isDirty
    }

    private static func isSelectValuesDirty(
        previousSelectValue: [Int],
        currentSelectValue: [Int]
    ) -> Bool {
        var isDirty = false

        (0..<currentSelectValue.count).forEach { index in
            if previousSelectValue.indices.contains(index) &&
                previousSelectValue[index] != currentSelectValue[index] {
                isDirty = true
                return
            }
        }

        return isDirty
    }

    private static func converArrayOfElementProtocolToArrayOfSelectElement(_ elementProtocols: [CulturalPracticeElementProtocol]) -> [CulturalPracticeMultiSelectElement] {
        var selectElements = [CulturalPracticeMultiSelectElement]()

        elementProtocols.forEach { elementProtocol in
            if let selectElement = elementProtocol as? CulturalPracticeMultiSelectElement {
                selectElements.append(selectElement)
            }
        }

        return selectElements
    }

    private static func createInputValues(for inputElements: [CulturalPracticeInputElement]) -> [String] {
        var inputValues = [String]()
        inputElements.forEach { inputElement in inputValues.append(inputElement.value?.getValue() ?? "") }
        return inputValues
    }

    private static func createSelectValues(for selectElements: [CulturalPracticeMultiSelectElement]) -> [Int] {
        var selectValues = [Int]()

        selectElements.forEach { selectElement in
            selectValues.append(getSelectedIndex(of: selectElement))
        }

        return selectValues
    }

    private static func getSelectedIndex(of selectElement: CulturalPracticeMultiSelectElement) -> Int {
        guard let valueSelectedProtocol = selectElement.value else { return 0 }
        let valueSelected = valueSelectedProtocol.getValue()

        return selectElement.tupleCulturalTypeValue.firstIndex { tupleValueProtocolAndValueString in
            tupleValueProtocolAndValueString.1 == valueSelected
            } ?? 0
    }
}
