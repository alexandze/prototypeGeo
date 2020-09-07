//
//  HandlerCheckIfInputElemenIsValidAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-12.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension AddProducerFormReducerHandler {
    class HandlerCheckIfInputElemenIsValidAction: HandlerReducer {

        func handle(
            action: AddProducerFormAction.CheckIfInputElemenIsValidAction,
            _ state: AddProducerFormState
        ) -> AddProducerFormState {
            let util =  UtilCheckIfInputElemenIsValidAction(
                id: action.id,
                value: action.value,
                state: state
            )

            return (
                findIndexInputElementByUUID(util:) >>>
                    checkIfInputElementIsValid(util:) >>>
                    updateElementUIDataWithIsValid(util:) >>>
                    newState(util:)

                )(util) ?? state
        }

        private func findIndexInputElementByUUID(
            util: UtilCheckIfInputElemenIsValidAction?
        ) -> UtilCheckIfInputElemenIsValidAction? {
            guard var newUtil = util,
                let elementUIDataObservableList = newUtil.state.elementUIDataObservableList
                else { return nil }

            let indexFindOfInputElement = elementUIDataObservableList.firstIndex { elementUIData in
                elementUIData.id == newUtil.id
            }

            guard let indexFind = indexFindOfInputElement else { return nil }
            newUtil.indexFind = indexFind
            return newUtil
        }

        private func checkIfInputElementIsValid(
            util: UtilCheckIfInputElemenIsValidAction?
        ) -> UtilCheckIfInputElemenIsValidAction? {
            guard var newUtil = util,
                let indexFind = newUtil.indexFind,
                let elementUIDataObservable = (newUtil.state.elementUIDataObservableList?[indexFind] as? InputElementDataObservable)
                else { return nil }

            newUtil.isValid = elementUIDataObservable.isInputValid()
            return newUtil
        }

        private func updateElementUIDataWithIsValid(
            util: UtilCheckIfInputElemenIsValidAction?
        ) -> UtilCheckIfInputElemenIsValidAction? {
            guard var newUtil = util,
                let indexFind = newUtil.indexFind,
                let isValid = newUtil.isValid,
                let inputElement = (newUtil.state.elementUIDataObservableList?[indexFind] as? InputElementDataObservable),
                var elementUIDataObservableList = newUtil.state.elementUIDataObservableList
                else {
                    return nil
            }

            inputElement.isValid = isValid
            elementUIDataObservableList[indexFind] = inputElement
            newUtil.elementUIDataObservableList = elementUIDataObservableList
            return newUtil
        }

        private func newState(
            util: UtilCheckIfInputElemenIsValidAction?
        ) -> AddProducerFormState? {
            guard let indexFind = util?.indexFind,
                let elementUIDataObservableList = util?.elementUIDataObservableList
                else {
                    return nil
            }

            return util?.state.changeValues(
                elementUIDataObservableList: elementUIDataObservableList,
                responseAction: .checkIfInputElemenIsValidActionResponse(
                    index: indexFind
                )
            )
        }
    }

    private struct UtilCheckIfInputElemenIsValidAction {
        var id: UUID
        var value: String
        var state: AddProducerFormState
        var indexFind: Int?
        var isValid: Bool?
        var elementUIDataObservableList: [ElementUIDataObservable]?
    }

}
