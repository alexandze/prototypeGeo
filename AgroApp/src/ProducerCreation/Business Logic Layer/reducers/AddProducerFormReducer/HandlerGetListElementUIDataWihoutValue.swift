//
//  HandlerGetListElementUIDataWihoutValue.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-09.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class HandlerGetListElementUIDataWihoutValue: HandlerReducerProtocol {
    func handle(
        action: AddProducerFormAction.GetListElementUIDataWithoutValueAction,
        _ state: AddProducerFormState
    ) -> AddProducerFormState {
        let util = UtilHandlerGetListElementUIData(state: state)

        return (
            createListElementUIData(util:) >>>
                createListValueValid(util:) >>>
                newState(util:)
            )(util) ?? state
    }

    private func createListElementUIData(util: UtilHandlerGetListElementUIData?) -> UtilHandlerGetListElementUIData? {
        guard var newUtil = util else { return nil }

        newUtil.listElementUIData = [
            InputElement(id: UUID().uuidString, title: "Nom", value: "", isValid: false),
            InputElement(id: UUID().uuidString, title: "Prenom", value: "", isValid: false),
            InputElement(id: UUID().uuidString, title: "Email", value: "", isValid: false),
            InputElement(id: UUID().uuidString, title: "NIM", value: "", isValid: false),
            ButtonElement(id: UUID().uuidString, title: "Ajouter NIM", isEnabled: true)
        ]

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
    var state: AddProducerFormState
    var listElementUIData: [ElementUIData] = []
    var listElementValue = [String]()
    var listElementValid = [Bool]()
}
