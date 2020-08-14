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
                uuid: action.uuid,
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
                let utilElementUIDataList = newUtil.state.utilElementUIDataSwiftUI
                else { return nil }

            let indexFindOfInputElement = utilElementUIDataList.firstIndex { utilElementUIData in
                utilElementUIData.uuid == newUtil.uuid
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
                let utilElementUIDataList = newUtil.state.utilElementUIDataSwiftUI
                else { return nil }

            guard let regularExpression = utilElementUIDataList[indexFind].regularExpression else {
                newUtil.isValid = true
                return newUtil
            }

            let value = utilElementUIDataList[indexFind]
                .valueState.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !value.isEmpty else {
                newUtil.isValid = false
                return newUtil
            }

            let isValid = regularExpression
                .matches(in: value, range: NSRange(location: 0, length: value.count)).count == 1

            newUtil.isValid = isValid
            return newUtil
        }

        private func updateElementUIDataWithIsValid(
            util: UtilCheckIfInputElemenIsValidAction?
        ) -> UtilCheckIfInputElemenIsValidAction? {
            guard var newUtil = util,
                let indexFind = newUtil.indexFind,
                let isValid = newUtil.isValid,
                let utilElementList = newUtil.state.utilElementUIDataSwiftUI,
                var inputElement = (utilElementList[indexFind].elementUIData as? InputElementData)
                else {
                    return nil
            }

            inputElement.isValid = isValid
            utilElementList[indexFind].elementUIData = inputElement
            newUtil.newUtilElementUIDataList = utilElementList
            return newUtil
        }

        private func newState(
            util: UtilCheckIfInputElemenIsValidAction?
        ) -> AddProducerFormState? {
            guard let indexFind = util?.indexFind,
                let newUtilElementList = util?.newUtilElementUIDataList
                else {
                    return nil
            }

            return util?.state.changeValues(
                utilElementUIDataSwiftUI: newUtilElementList,
                responseAction: .checkIfInputElemenIsValidActionResponse(
                    index: indexFind
                )
            )
        }
    }

    private struct UtilCheckIfInputElemenIsValidAction {
        var uuid: UUID
        var value: String
        var state: AddProducerFormState
        var indexFind: Int?
        var isValid: Bool?
        var newUtilElementUIDataList: [UtilElementUIDataSwiftUI]?
    }

}
