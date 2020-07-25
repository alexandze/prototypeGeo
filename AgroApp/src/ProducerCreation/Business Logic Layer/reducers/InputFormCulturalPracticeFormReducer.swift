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
            return InputFormCulturalPracticeReducerHandler()
                .handle(inputElementSelectedOnListAction: action, state)
        case let action as InputFormCulturalPracticeAction.CloseInputFormWithSaveAction:
            return InputFormCulturalPracticeReducerHandler().handle(
                closeInputFormWithSaveAction: action,
                state
            )
        case let action as InputFormCulturalPracticeAction.CloseInputFormWithoutSaveAction:
            return InputFormCulturalPracticeReducerHandler().handle(
                closeInputFormWithoutSaveAction: action,
                state
            )
        default:
            return state
        }
    }
}

class InputFormCulturalPracticeReducerHandler {
    func handle(
        inputElementSelectedOnListAction: InputFormCulturalPracticeAction.InputElementSelectedOnListAction,
        _ state: InputFormCulturalPracticeState
    ) -> InputFormCulturalPracticeState {
        state.changeValue(
            inputElement: inputElementSelectedOnListAction.culturalPracticeInputElement,
            field: inputElementSelectedOnListAction.field,
            inputFormSubAction: inputElementSelectedOnListAction.subAction,
            isDirty: false
        )
    }

    func handle(
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

    func handle(
        closeInputFormWithoutSaveAction: InputFormCulturalPracticeAction.CloseInputFormWithoutSaveAction,
        _ state: InputFormCulturalPracticeState
    ) -> InputFormCulturalPracticeState {
        state.changeValue(inputFormSubAction: .closeWithoutSave)
    }
}
