//
//  HandlerCheckIfAllInputElementIsValidAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-13.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension AddProducerFormReducerHandler {
    class HandlerCheckIfAllInputElementIsValidAction: HandlerReducer {
        func handle(
            action: AddProducerFormAction.CheckIfAllInputElementIsValidAction,
            _ state: AddProducerFormState
        ) -> AddProducerFormState {
            let util = UtilHandlerCheckIfAllInputElementIsValidAction(state: state)

            return (
                filterElementUIDataRequired(util:) >>>
                    checkIfAllInputElementIsValid(util:) >>>
                    newState(util:)
            )(util) ?? state
        }

        private func filterElementUIDataRequired(
            util: UtilHandlerCheckIfAllInputElementIsValidAction?
        ) -> UtilHandlerCheckIfAllInputElementIsValidAction? {
            guard var newUtil = util else { return nil }

            guard let elementUIDataList = newUtil.state.elementUIDataObservableList else {
                newUtil.isAllInputElementIsValid = false
                return newUtil
            }

            newUtil.elementUIDataRequiredList = elementUIDataList.filter { elementUIData in
                (elementUIData as? InputElementDataObservable)?.isRequired ?? false
            }

            return newUtil
        }

        private func checkIfAllInputElementIsValid(
            util: UtilHandlerCheckIfAllInputElementIsValidAction?
        ) -> UtilHandlerCheckIfAllInputElementIsValidAction? {
            guard var newUtil = util else { return nil }

            guard let elementUIDataRequiredList = newUtil.elementUIDataRequiredList, !elementUIDataRequiredList.isEmpty else {
                newUtil.isAllInputElementIsValid = false
                return newUtil
            }

            let firstIndexInvalidValue = elementUIDataRequiredList.firstIndex { elementUIData in
                guard let isValid = (elementUIData as? InputElementDataObservable)?.isInputValid() else {
                    return true
                }

                return !isValid
            }

            newUtil.isAllInputElementIsValid = !(firstIndexInvalidValue != nil)
            return newUtil
        }

        private func newState(
            util: UtilHandlerCheckIfAllInputElementIsValidAction?
        ) -> AddProducerFormState? {
            guard let newUtil = util,
                let isAllInputElementIsValid = newUtil.isAllInputElementIsValid else {
                return nil
            }

            return newUtil.state
                .changeValues(
                    responseAction: .checkIfAllInputElementIsValidActionResponse(
                        isAllInputValid: isAllInputElementIsValid
                    )
            )
        }
    }

    private struct UtilHandlerCheckIfAllInputElementIsValidAction {
        var state: AddProducerFormState
        var elementUIDataRequiredList: [ElementUIDataObservable]?
        var isAllInputElementIsValid: Bool?
    }
}
