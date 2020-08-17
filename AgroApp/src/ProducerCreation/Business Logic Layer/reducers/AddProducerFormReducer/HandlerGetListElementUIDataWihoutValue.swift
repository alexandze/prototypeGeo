//
//  HandlerGetListElementUIDataWihoutValue.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-09.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
extension AddProducerFormReducerHandler {
    class HandlerGetAllElementUIDataWihoutValue: HandlerReducer {
        let addProducerFormService: AddProducerFormService

        init(addProducerFormService: AddProducerFormService = AddProducerFormServiceImpl()) {
            self.addProducerFormService = addProducerFormService
        }

        func handle(
            action: AddProducerFormAction.GetAllElementUIDataWithoutValueAction,
            _ state: AddProducerFormState
        ) -> AddProducerFormState {
            let util = UtilHandlerGetListElementUIData(
                addProducerFormService: addProducerFormService,
                state: state
            )

            return (
                createListElementUIDataIfEmpty(util:) >>>
                    // TODO restaurer les elements si pas empty
                    newState(util:)
                )(util) ?? state
        }

        private func createListElementUIDataIfEmpty(util: UtilHandlerGetListElementUIData?) -> UtilHandlerGetListElementUIData? {
            guard var newUtil = util
                else { return nil }

            guard newUtil.state.elementUIDataObservableList == nil ||
                newUtil.state.elementUIDataObservableList!.isEmpty
                else {
                    return newUtil
            }

            newUtil.elementUIDataObservableList = newUtil.addProducerFormService.getElementUIDataObservableList()
            newUtil.addButtonElementObservalble = newUtil.addProducerFormService.getAddButtonElementObservable(isEnabled: true)
            return newUtil
        }

        private func newState(
            util: UtilHandlerGetListElementUIData?
        ) -> AddProducerFormState? {
            guard let newUtil = util,
                let addButtonElementObservable = newUtil.addButtonElementObservalble
                else { return nil }

            return newUtil.state.changeValues(
                elementUIDataObservableList: newUtil.elementUIDataObservableList,
                addButtonElementObservable: addButtonElementObservable,
                responseAction: .getListElementUIDataWihoutValueResponse
            )
        }
    }

    private struct UtilHandlerGetListElementUIData {
        var addProducerFormService: AddProducerFormService
        var state: AddProducerFormState
        var elementUIDataObservableList: [ElementUIDataObservable] = []
        var addButtonElementObservalble: ButtonElementObservable?
    }
}
