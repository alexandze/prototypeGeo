//
//  HandlerValidateFormAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-17.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension AddProducerFormReducerHandler {
    class HandlerValidateFormAction: HandlerReducer {

        let helperAddProducerFormHandler: HelperAddProducerFormReducerHandler

        init(helperAddProducerFormHandler: HelperAddProducerFormReducerHandler = HelperAddProducerFormReducerHandlerImpl()) {
            self.helperAddProducerFormHandler = helperAddProducerFormHandler
        }

        func handle(action: AddProducerFormAction.ValidateFormAction, _ state: AddProducerFormState) -> AddProducerFormState {
            let util = UtilHandlerValidateFormAction(state: state, helperAddProducerFormHandler: helperAddProducerFormHandler)

            return (
                filterElementUIDataRequired(util:) >>>
                    checkIfAllInputElementIsValid(util:) >>>
                    newState(util:)
            )(util) ?? state
        }

        private func filterElementUIDataRequired(
            util: UtilHandlerValidateFormAction?
        ) -> UtilHandlerValidateFormAction? {
            guard var newUtil = util else { return nil }

            guard let elementUIDataList = newUtil.state.elementUIDataObservableList else {
                newUtil.isAllInputElementIsValid = false
                return newUtil
            }

            newUtil.elementUIDataRequiredList = newUtil.helperAddProducerFormHandler
                .filterElementUIDataRequired(elementUIDataList: elementUIDataList)

            return newUtil
        }

        private func checkIfAllInputElementIsValid(
            util: UtilHandlerValidateFormAction?
        ) -> UtilHandlerValidateFormAction? {
            guard var newUtil = util else { return nil }

            guard let elementUIDataRequiredList = newUtil.elementUIDataRequiredList, !elementUIDataRequiredList.isEmpty else {
                newUtil.isAllInputElementIsValid = false
                return newUtil
            }

            newUtil.isAllInputElementIsValid = newUtil.helperAddProducerFormHandler
                .checkIfAllInputElementRequiredIsValid(elementUIDataRequiredList: elementUIDataRequiredList)

            return newUtil
        }

        private func newState(util: UtilHandlerValidateFormAction?) -> AddProducerFormState? {
            guard let newUtil = util,
                let isAllInputElementIsValid = newUtil.isAllInputElementIsValid else {
                return nil
            }

            return newUtil.state
                .changeValues(responseAction: .validateFormActionResponse(isAllInputElementRequiredIsValid: isAllInputElementIsValid))
        }

    }

    private struct UtilHandlerValidateFormAction {
        var state: AddProducerFormState
        var helperAddProducerFormHandler: HelperAddProducerFormReducerHandler
        var elementUIDataRequiredList: [ElementUIDataObservable]?
        var isAllInputElementIsValid: Bool?
    }
}
