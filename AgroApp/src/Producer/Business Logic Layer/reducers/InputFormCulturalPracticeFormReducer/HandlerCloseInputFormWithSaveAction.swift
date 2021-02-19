//
//  HandlerCloseInputFormWithSaveAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-23.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension InputFormCulturalPracticeReducerHandler {
    class HandlerCloseInputFormWithSaveAction: HandlerReducer {

        func handle(
            action: InputFormCulturalPracticeAction.CloseInputFormWithSaveAction,
            _ state: InputFormCulturalPracticeState
        ) -> InputFormCulturalPracticeState {
            let util = UtilCloseInputFormWithSaveAction(state: state, inputValue: action.inputValue)

            return (
                checkIfInputValueIsValid(util: ) >>>
                    setSectionWithInputValue(util: ) >>>
                    newState(util:)
                )(util) ?? state
        }

        private func checkIfInputValueIsValid(util: UtilCloseInputFormWithSaveAction?) -> UtilCloseInputFormWithSaveAction? {
            guard let newUtil = util,
                let inputElementObservable = newUtil.state.inputElementObservable,
                inputElementObservable.isInputValid()
                else { return nil }

            return newUtil
        }

        private func setSectionWithInputValue(util: UtilCloseInputFormWithSaveAction?) -> UtilCloseInputFormWithSaveAction? {
            guard var newUtil = util,
                var sectionInputElement = newUtil.state.sectionInputElement,
                Util.hasIndexInArray(sectionInputElement.rowData, index: 0),
                var inputElement = sectionInputElement.rowData[0] as? InputElement,
                let inputElementObservable = newUtil.state.inputElementObservable
                else {
                    return nil
            }

            inputElement.value = inputElementObservable.value
            inputElement.isValid = true
            sectionInputElement.rowData[0] = inputElement
            newUtil.newSectionInputElement = sectionInputElement
            return newUtil
        }

        private func newState(util: UtilCloseInputFormWithSaveAction?) -> InputFormCulturalPracticeState? {
            guard let newUtil = util,
                let newSectionInputElement = newUtil.newSectionInputElement else {
                    return nil
            }

            return newUtil.state.changeValue(
                sectionInputElement: newSectionInputElement,
                actionResponse: .closeInputFormWithSaveActionResponse
            )
        }
    }

    private struct UtilCloseInputFormWithSaveAction {
        var state: InputFormCulturalPracticeState
        var inputValue: String
        var newSectionInputElement: Section<ElementUIData>?
    }
}
