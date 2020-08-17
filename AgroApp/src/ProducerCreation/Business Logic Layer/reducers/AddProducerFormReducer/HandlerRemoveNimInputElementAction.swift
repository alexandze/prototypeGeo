//
//  HandlerRemoveNimInputElementAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-16.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension AddProducerFormReducerHandler {
    class HandlerRemoveNimInputElementAction: HandlerReducer {

        let addProducerFormService: AddProducerFormService

        init(addProducerFormService: AddProducerFormService = AddProducerFormServiceImpl()) {
            self.addProducerFormService = addProducerFormService
        }

        func handle(action: AddProducerFormAction.RemoveNimInputElementAction, _ state: AddProducerFormState) -> AddProducerFormState {
            let util = UtilHandlerRemoveNimInputElementAction(
                state: state,
                idOfRemoveNimInputElement: action.id,
                addProducerFormService: addProducerFormService
            )

            return (
                findInputElementWithRemoveButtonByUUID(util:) >>>
                    removeElementUIDataByIndex(util:) >>>
                    resetAllNumberInputElementWhoHaveNumber(util:) >>>
                    createNewAddButton(util: ) >>>
                    newState(util:)
                )(util) ?? state
        }

        private func findInputElementWithRemoveButtonByUUID(util: UtilHandlerRemoveNimInputElementAction?) -> UtilHandlerRemoveNimInputElementAction? {
            guard var newUtil = util,
                let elementUIDataList = newUtil.state.elementUIDataObservableList else {
                    return nil
            }

            let indexFindOp = elementUIDataList.firstIndex { $0.id == newUtil.idOfRemoveNimInputElement }

            guard let indexFind = indexFindOp else {
                return nil
            }

            newUtil.indexForRemoveElement = indexFind
            return newUtil
        }

        private func removeElementUIDataByIndex(util: UtilHandlerRemoveNimInputElementAction?) -> UtilHandlerRemoveNimInputElementAction? {
            guard var newUtil = util,
                var elementUIDataList = newUtil.state.elementUIDataObservableList,
                let indexFind = newUtil.indexForRemoveElement else {
                    return nil
            }

            elementUIDataList.remove(at: indexFind)
            newUtil.newElementUIDataList = elementUIDataList
            return newUtil
        }

        private func resetAllNumberInputElementWhoHaveNumber(util: UtilHandlerRemoveNimInputElementAction?) -> UtilHandlerRemoveNimInputElementAction? {
            guard var newUtil = util,
                var newElementUIDataList = newUtil.newElementUIDataList else {
                    return nil
            }

            var numberInit = 1
            newUtil.updateIndexInputElement = newUtil.updateIndexInputElement ?? []

            (0..<newElementUIDataList.count).forEach { index in
                guard let inputElementDataObservable = newElementUIDataList[index] as? InputElementDataObservable,
                    inputElementDataObservable.number != nil else {
                        return
                }

                inputElementDataObservable.number = numberInit
                newElementUIDataList[index] = inputElementDataObservable
                newUtil.updateIndexInputElement?.append(index)
                numberInit += 1
            }

            newUtil.newElementUIDataList = newElementUIDataList
            return newUtil
        }

        private func createNewAddButton(util: UtilHandlerRemoveNimInputElementAction?) -> UtilHandlerRemoveNimInputElementAction? {
            guard var newUtil = util else {
                return nil
            }

            newUtil.newAddNimButtonElement = newUtil.addProducerFormService.getAddButtonElementObservable(isEnabled: true)
            return newUtil
        }

        private func newState(util: UtilHandlerRemoveNimInputElementAction?) -> AddProducerFormState? {
            guard let newElementUIDataList = util?.newElementUIDataList,
                let newAddNimButtonElement = util?.newAddNimButtonElement,
                let indexForRemoveElement = util?.indexForRemoveElement,
                let updateIndexInputElement = util?.updateIndexInputElement else {
                    return nil
            }

            return util?.state.changeValues(
                elementUIDataObservableList: newElementUIDataList,
                addButtonElementObservable: newAddNimButtonElement,
                responseAction: .removeNimInputElementActionResponse(
                    indexInputElementRemoved: indexForRemoveElement,
                    indexInputElementUpdateList: updateIndexInputElement
                )
            )
        }
    }

    private struct UtilHandlerRemoveNimInputElementAction {
        var state: AddProducerFormState
        var idOfRemoveNimInputElement: UUID
        var addProducerFormService: AddProducerFormService
        var indexForRemoveElement: Int?
        var newElementUIDataList: [ElementUIDataObservable]?
        var newAddNimButtonElement: ButtonElementObservable?
        var updateIndexInputElement: [Int]?
    }
}
