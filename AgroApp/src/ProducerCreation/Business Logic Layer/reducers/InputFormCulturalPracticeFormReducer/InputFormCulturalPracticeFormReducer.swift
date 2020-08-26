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
        case let inputElementSelectedOnListAction as InputFormCulturalPracticeAction.InputElementSelectedOnListAction:
            return InputFormCulturalPracticeReducerHandler
                .HandlerInputElementSelectedOnListAction().handle(action: inputElementSelectedOnListAction , state)
        case let closeInputFormWithSaveAction as InputFormCulturalPracticeAction.CloseInputFormWithSaveAction:
            return InputFormCulturalPracticeReducerHandler
                .HandlerCloseInputFormWithSaveAction().handle(action: closeInputFormWithSaveAction, state)
        case let action as InputFormCulturalPracticeAction.CloseInputFormWithoutSaveAction:
            return InputFormCulturalPracticeReducerHandler
                .HandlerCloseInputFormWithoutSaveAction().handle(action: action, state)
        case let checkIfInputValueIsValidAction as InputFormCulturalPracticeAction.CheckIfInputValueIsValidAction:
            return InputFormCulturalPracticeReducerHandler
                .HandlerCheckIfInputValueIsValidAction().handle(action: checkIfInputValueIsValidAction, state)
        case let checkIfFormIsValidAndDirtyForPrintAlertAction as InputFormCulturalPracticeAction.CheckIfFormIsValidAndDirtyForPrintAlertAction:
            return InputFormCulturalPracticeReducerHandler
                .HandlerCheckIfFormIsValidAndDirtyForPrintAlertAction().handle(action: checkIfFormIsValidAndDirtyForPrintAlertAction, state)
        default:
            return state
        }
    }
}

class InputFormCulturalPracticeReducerHandler { }
