//
//  inputFormCulturalPracticeFormReducer.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func inputFormCulturalPracticeReducer(action: Action, state: InputFormCulturalPracticeState?) -> InputFormCulturalPracticeState {
        let state = state ?? InputFormCulturalPracticeState(uuidState: UUID().uuidString)

        switch action {
        case let action as InputFormCulturalPracticeAction.InputElementSelectedOnListAction:
            return InputFormCulturalPracticeReducerHandler
                .handle(inputElementSelectedOnListAction: action, state)
        case let action as InputFormCulturalPracticeAction.CloseInputFormWithSaveAction:
            return InputFormCulturalPracticeReducerHandler.handle(
                closeInputFormWithSaveAction: action,
                state
            )
        default:
            break
        }

        return state
    }
}

class InputFormCulturalPracticeReducerHandler {
    static func handle(
        inputElementSelectedOnListAction: InputFormCulturalPracticeAction.InputElementSelectedOnListAction,
        _ state: InputFormCulturalPracticeState
    ) -> InputFormCulturalPracticeState {
        state.changeValue(
            inputElement: inputElementSelectedOnListAction.culturalPracticeInputElement,
            fieldType: inputElementSelectedOnListAction.fieldType,
            inputFormSubAction: inputElementSelectedOnListAction.subAction,
            isDirty: false
        )
    }

    static func handle(
        closeInputFormWithSaveAction: InputFormCulturalPracticeAction.CloseInputFormWithSaveAction,
        _ state: InputFormCulturalPracticeState
    ) -> InputFormCulturalPracticeState {
        let newInputValue = closeInputFormWithSaveAction.inputValue
        let emptyValue = state.inputElement!.valueEmpty
        let culturalPracticeValue = type(of: emptyValue).create(value: newInputValue)
        var inputElement = state.inputElement!
        inputElement.value = culturalPracticeValue

        return state.changeValue(
            inputElement: inputElement,
            inputFormSubAction: closeInputFormWithSaveAction.subAction
        )
    }
}
