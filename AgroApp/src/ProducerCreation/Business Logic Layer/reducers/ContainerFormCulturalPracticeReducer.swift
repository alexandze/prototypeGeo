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

        return state.changeValue(
            containerElement: containerElement,
            fieldType: fieldType,
            subAction: subAction,
            inputElements: inputElements,
            selectElements: selectElements,
            inputValues: inputValues,
            selectValues: selectValues
        )
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
