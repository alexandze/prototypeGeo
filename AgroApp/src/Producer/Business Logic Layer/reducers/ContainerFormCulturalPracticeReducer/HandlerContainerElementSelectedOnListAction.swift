//
//  HandlerContainerElementSelectedOnListAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension ContainerFormCulturalPracticeHandler {
    class HandlerContainerElementSelectedOnListAction: HandlerReducer {
        func handle(
            action: ContainerFormCulturalPracticeAction.ContainerElementSelectedOnListAction,
            _ state: ContainerFormCulturalPracticeState
        ) -> ContainerFormCulturalPracticeState {
            let util = UtilHandlerContainerElementSelectedOnListAction(
                state: state,
                section: action.section,
                field: action.field
            )

            return (
                makeElementUIDataObservableList(util: ) >>>
                    setInputElementIsValid(util:) >>>
                    checkIfFormIsValid(util: ) >>>
                    newState(util: )
            )(util) ?? state
        }

        private func makeElementUIDataObservableList(
            util: UtilHandlerContainerElementSelectedOnListAction?
        ) -> UtilHandlerContainerElementSelectedOnListAction? {
            guard var newUtil = util else {
                return nil
            }

            newUtil.newElementUIDataListObservable = newUtil.section.rowData
                .map(self.mapElementUIDataToElementUIDataObservable(_:))
                .filter { $0 != nil }
                .map { $0! }

            return newUtil
        }

        private func setInputElementIsValid(util: UtilHandlerContainerElementSelectedOnListAction?) -> UtilHandlerContainerElementSelectedOnListAction? {
            guard var newUtil = util,
                var newElementUIDataObservableList = newUtil.newElementUIDataListObservable else {
                    return nil
            }

            (0..<newElementUIDataObservableList.count).forEach { index in
                if let inputElementObservable = newElementUIDataObservableList[index].toInputElementObservable() {
                    inputElementObservable.isValid = inputElementObservable.isInputValid()
                    newElementUIDataObservableList[index] = inputElementObservable
                }
            }

            newUtil.newElementUIDataListObservable = newElementUIDataObservableList
            return newUtil
        }

        private func checkIfFormIsValid(util: UtilHandlerContainerElementSelectedOnListAction?) -> UtilHandlerContainerElementSelectedOnListAction? {
            guard var newUtil = util,
                let newElementUIDataListObservable = newUtil.newElementUIDataListObservable else {
                    return nil
            }

            let firstIndexInvalidValueOp = newElementUIDataListObservable.firstIndex { elementUIDataObservable in
                if let inputElement = elementUIDataObservable.toInputElementObservable() {
                    return !inputElement.isValid
                }

                return false
            }

            guard firstIndexInvalidValueOp != nil else {
                newUtil.isFormValid = true
                return newUtil
            }

            newUtil.isFormValid = false
            return newUtil
        }

        private func newState(util: UtilHandlerContainerElementSelectedOnListAction?) -> ContainerFormCulturalPracticeState? {
            guard let newUtil = util,
                let newElementUIDataListObservable = newUtil.newElementUIDataListObservable,
                let isFormValid = newUtil.isFormValid else {
                    return nil
            }

            return newUtil.state.changeValue(
                field: newUtil.field,
                section: newUtil.section,
                elementUIDataObservableList: newElementUIDataListObservable,
                isFormValid: isFormValid,
                actionResponse: .containerElementSelectedOnListActionResponse
            )
        }

        private func mapElementUIDataToElementUIDataObservable(_ elementUIData: ElementUIData) -> ElementUIDataObservable? {
            switch elementUIData {
            case let inputElement as InputElement:
                return inputElement.toInputElementObservable()
            case let selectElement as SelectElement:
                return selectElement.toSelectElementObservable()
            default:
                return nil
            }
        }
    }

    private struct UtilHandlerContainerElementSelectedOnListAction {
        let state: ContainerFormCulturalPracticeState
        let section: Section<ElementUIData>
        let field: Field
        var newElementUIDataListObservable: [ElementUIDataObservable]?
        var isFormValid: Bool?
    }
}
