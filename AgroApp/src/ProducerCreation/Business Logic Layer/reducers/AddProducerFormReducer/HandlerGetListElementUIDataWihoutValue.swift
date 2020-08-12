//
//  HandlerGetListElementUIDataWihoutValue.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-09.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class HandlerGetListElementUIDataWihoutValue: HandlerReducerProtocol {
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
                createListValueValid(util:) >>>
                newState(util:)
            )(util) ?? state
    }

    private func createListElementUIDataIfEmpty(util: UtilHandlerGetListElementUIData?) -> UtilHandlerGetListElementUIData? {
        guard var newUtil = util
            else { return nil }
        
        guard newUtil.state.listElementUIData == nil ||
            newUtil.state.listElementUIData!.isEmpty
            else {
                return newUtil
            }
        
        newUtil.listElementUIData = newUtil.addProducerFormFactory.makeElementsUIData()
        return newUtil
    }

    private func createListValueValid(
        util: UtilHandlerGetListElementUIData?
    ) -> UtilHandlerGetListElementUIData? {
        guard var newUtil = util
            else { return nil }

        newUtil.listElementUIData.forEach { elementUIData in
            switch elementUIData {
            case let inputElement as InputElement:
                newUtil.listElementValue.append(inputElement.value)
                newUtil.listElementValid.append(inputElement.isValid)
            case let buttonElement as ButtonElement:
                newUtil.listElementValue.append("")
                newUtil.listElementValid.append(buttonElement.isEnabled)
            default:
                break
            }
        }

        return newUtil
    }

    private func newState(
        util: UtilHandlerGetListElementUIData?
    ) -> AddProducerFormState? {

        guard let newUtil = util
            else { return nil }

        return newUtil.state.changeValues(
            listElementUIData: newUtil.listElementUIData,
            listElementValue: newUtil.listElementValue,
            listElementValid: newUtil.listElementValid,
            responseAction: .getListElementUIDataWihoutValueResponse
        )
    }
}

private struct UtilHandlerGetListElementUIData {
    var addProducerFormFactory: AddProducerFormFactory
    var state: AddProducerFormState
    var listElementUIData: [ElementUIData] = []
    var listElementValue = [String]()
    var listElementValid = [Bool]()
}
