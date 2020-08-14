//
//  HandlerGetListElementUIDataWihoutValue.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-09.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
extension AddProducerFormReducerHandler {
    class HandlerGetListElementUIDataWihoutValue: HandlerReducer {
        let addProducerFormFactory: AddProducerFormFactory

        init(addProducerFormFactory: AddProducerFormFactory = AddProducerFormFactoryImpl()) {
            self.addProducerFormFactory = addProducerFormFactory
        }

        func handle(
            action: AddProducerFormAction.GetListElementUIDataWithoutValueAction,
            _ state: AddProducerFormState
        ) -> AddProducerFormState {
            let util = UtilHandlerGetListElementUIData(
                addProducerFormFactory: addProducerFormFactory,
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

            guard newUtil.state.utilElementUIDataSwiftUI == nil ||
                newUtil.state.utilElementUIDataSwiftUI!.isEmpty
                else {
                    return newUtil
            }

            newUtil.utilElementUIDataSwiftUI = newUtil.addProducerFormFactory.makeElementsUIData()
            return newUtil
        }

        private func newState(
            util: UtilHandlerGetListElementUIData?
        ) -> AddProducerFormState? {

            guard let newUtil = util
                else { return nil }

            return newUtil.state.changeValues(
                utilElementUIDataSwiftUI: newUtil.utilElementUIDataSwiftUI,
                responseAction: .getListElementUIDataWihoutValueResponse
            )
        }
    }

    private struct UtilHandlerGetListElementUIData {
        var addProducerFormFactory: AddProducerFormFactory
        var state: AddProducerFormState
        var utilElementUIDataSwiftUI: [UtilElementUIDataSwiftUI] = []
    }
}
