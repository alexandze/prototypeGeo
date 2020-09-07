//
//  HandlerCheckIfFormIsValidAndDirtyForPrintAlertAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-25.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension InputFormCulturalPracticeReducerHandler {
    class HandlerCheckIfFormIsValidAndDirtyForPrintAlertAction: HandlerReducer {
        func handle(
            action: InputFormCulturalPracticeAction.CheckIfFormIsValidAndDirtyForPrintAlertAction,
            _ state: InputFormCulturalPracticeState
        ) -> InputFormCulturalPracticeState {
            let util = UtilCheckIfFormIsValidAndDirtyForPrintAlertAction(state: state)

            return (
                isPrintAlert(util: ) >>>
                    newState(util:)
            )(util) ?? state
        }

        private func isPrintAlert(
            util: UtilCheckIfFormIsValidAndDirtyForPrintAlertAction?
        ) -> UtilCheckIfFormIsValidAndDirtyForPrintAlertAction? {
            guard var newUtil = util else { return nil }

            if let isDirty = newUtil.state.isDirty, let isValid = newUtil.state.inputElementObservable?.isValid,
                isDirty && isValid {
                newUtil.isPrintAlert = true
                return newUtil
            }

            newUtil.isPrintAlert = false
            return newUtil
        }

        private func newState(util: UtilCheckIfFormIsValidAndDirtyForPrintAlertAction?) -> InputFormCulturalPracticeState? {
            guard let newUtil = util,
            let isPrintAlert = newUtil.isPrintAlert else { return nil }

            return newUtil.state.changeValue(
                actionResponse: .checkIfFormIsValidAndDirtyForPrintAlertActionResponse(isPrintAlert: isPrintAlert)
            )
        }
    }

    private struct UtilCheckIfFormIsValidAndDirtyForPrintAlertAction {
        let state: InputFormCulturalPracticeState
        var isPrintAlert: Bool?
    }
}
