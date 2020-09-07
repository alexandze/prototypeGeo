//
//  HandlerCheckIfInputValueIsValidAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-25.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension InputFormCulturalPracticeReducerHandler {
    class HandlerCheckIfInputValueIsValidAction: HandlerReducer {

        func handle(
            action: InputFormCulturalPracticeAction.CheckIfInputValueIsValidAction,
            _ state: InputFormCulturalPracticeState
        ) -> InputFormCulturalPracticeState {
            let util = UtilHandlerCheckIfInputValueIsValidAction(
                state: state,
                inputValueForCheck: action.inputValue
            )

            return (
                checkIfInputValueIsValid(util: ) >>>
                    isFormDirty(util: ) >>>
                    newState(util: )
            )(util) ?? state
        }

        private func checkIfInputValueIsValid(util: UtilHandlerCheckIfInputValueIsValidAction?) -> UtilHandlerCheckIfInputValueIsValidAction? {
            guard var newUtil = util,
                let inputElementObservable = newUtil.state.inputElementObservable else {
                return nil
            }

            inputElementObservable.isValid = inputElementObservable.isInputValid()
            newUtil.newInputElementObservable = inputElementObservable
            return newUtil
        }

        private func isFormDirty(util: UtilHandlerCheckIfInputValueIsValidAction?) -> UtilHandlerCheckIfInputValueIsValidAction? {
            guard var newUtil = util,
            let inputElementObservable = newUtil.state.inputElementObservable,
                let section = newUtil.state.sectionInputElement,
                Util.hasIndexInArray(section.rowData, index: 0),
                let inputElement = section.rowData[0] as? InputElement else { return nil }

            newUtil.isFormDirty = inputElement.value != inputElementObservable.value
            return newUtil
        }

        private func newState(util: UtilHandlerCheckIfInputValueIsValidAction?) -> InputFormCulturalPracticeState? {
            guard let newUtil = util,
                let newInputElementObservable = newUtil.newInputElementObservable,
                let isFormDirty = newUtil.isFormDirty else {
                return nil
            }

            return newUtil.state.changeValue(
                inputElementObservable: newInputElementObservable,
                isDirty: isFormDirty,
                actionResponse: .checkIfInputValueIsValidActionResponse
            )
        }
    }

    private struct UtilHandlerCheckIfInputValueIsValidAction {
        let state: InputFormCulturalPracticeState
        let inputValueForCheck: String
        var isFormDirty: Bool?
        var newInputElementObservable: InputElementObservable?
    }
}
