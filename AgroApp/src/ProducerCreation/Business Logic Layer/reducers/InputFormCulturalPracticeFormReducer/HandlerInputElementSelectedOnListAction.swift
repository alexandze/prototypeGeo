//
//  HandlerInputElementSelectedOnListAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-24.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension InputFormCulturalPracticeReducerHandler {

    class HandlerInputElementSelectedOnListAction: HandlerReducer {
        func handle(
            action: InputFormCulturalPracticeAction.InputElementSelectedOnListAction,
            _ state: InputFormCulturalPracticeState
        ) -> InputFormCulturalPracticeState {
            let util = UtilInputElementSelectedOnListAction(
                state: state, sectionInputElement: action.sectionInputElement,
                field: action.field
            )

            return (
                makeSubTitle(util: ) >>>
                    makeInputElementObservable(util: ) >>>
                    checkIfInputElementIsValid(util: ) >>>
                    newState(util:)
                )(util) ?? state
        }

        private func makeSubTitle(util: UtilInputElementSelectedOnListAction?) -> UtilInputElementSelectedOnListAction? {
            guard var newUtil = util,
                Util.hasIndexInArray(newUtil.sectionInputElement.rowData, index: 0),
                var inputElement = newUtil.sectionInputElement.rowData[0] as? InputElement else {
                    return nil
            }

            inputElement.subtitle = "Veuillez saisir une valeur pour la parcelle \(newUtil.field.id)"
            newUtil.newInputElement = inputElement
            return newUtil
        }

        private func makeInputElementObservable(util: UtilInputElementSelectedOnListAction?) -> UtilInputElementSelectedOnListAction? {
            guard var newUtil = util,
                let inputElement = newUtil.newInputElement else {
                    return nil
            }

            newUtil.inputElementObservable = inputElement.toInputElementObservable()
            return newUtil
        }

        private func checkIfInputElementIsValid(util: UtilInputElementSelectedOnListAction?) -> UtilInputElementSelectedOnListAction? {
            guard var newUtil = util,
                let inputElementObservalble = newUtil.inputElementObservable else {
                    return nil
            }

            inputElementObservalble.isValid = inputElementObservalble.isInputValid()
            newUtil.inputElementObservable = inputElementObservalble
            return newUtil
        }

        private func newState(util: UtilInputElementSelectedOnListAction?) -> InputFormCulturalPracticeState? {
            guard let newUtil = util,
                let inputElementObservable = newUtil.inputElementObservable else {
                    return nil
            }

            return newUtil.state.changeValue(
                sectionInputElement: newUtil.sectionInputElement,
                inputElementObservable: inputElementObservable,
                field: newUtil.field,
                isDirty: false,
                actionResponse: .inputElementSelectedOnListActionResponse
            )
        }
    }

    private struct UtilInputElementSelectedOnListAction {
        let state: InputFormCulturalPracticeState
        let sectionInputElement: Section<ElementUIData>
        let field: Field
        var inputElementObservable: InputElementObservable?
        var newInputElement: InputElement?
    }
}
