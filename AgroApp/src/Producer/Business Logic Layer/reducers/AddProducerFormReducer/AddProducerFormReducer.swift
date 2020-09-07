//
//  AddProducerFormReducer.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-06.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    static func addProducerFormReducer(action: Action, state: AddProducerFormState?) -> AddProducerFormState {
        let state = state ?? AddProducerFormState(uuidState: UUID().uuidString)

        switch action {
        case let getAllElementUIDataWithoutValueAction as AddProducerFormAction.GetAllElementUIDataWithoutValueAction:
            return AddProducerFormReducerHandler
                .HandlerGetAllElementUIDataWihoutValue().handle(action: getAllElementUIDataWithoutValueAction, state)
        case let checkIfInputElemenIsValidAction as AddProducerFormAction.CheckIfInputElemenIsValidAction:
            return AddProducerFormReducerHandler
                .HandlerCheckIfInputElemenIsValidAction().handle(action: checkIfInputElemenIsValidAction, state)
        case let checkIfAllInputElementIsValidAction as AddProducerFormAction.CheckIfAllInputElementIsValidAction:
            return AddProducerFormReducerHandler
                .HandlerCheckIfAllInputElementIsValidAction().handle(action: checkIfAllInputElementIsValidAction, state)
        case let addNimInputElementAction as AddProducerFormAction.AddNimInputElementAction:
            return AddProducerFormReducerHandler
                .HandlerAddNimInputElementAction().handle(action: addNimInputElementAction, state)
        case let removeNimInputElementAction as AddProducerFormAction.RemoveNimInputElementAction:
            return AddProducerFormReducerHandler.HandlerRemoveNimInputElementAction().handle(action: removeNimInputElementAction, state)
        case let validateFormAction as AddProducerFormAction.ValidateFormAction:
            return AddProducerFormReducerHandler.HandlerValidateFormAction().handle(action: validateFormAction, state)
        case _ as AddProducerFormAction.NotResponseAction:
            return state.changeValues(responseAction: .notResponse)
        default:
            return state
        }
    }
}

class AddProducerFormReducerHandler { }
