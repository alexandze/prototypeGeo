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
        case let getListElementUIDataWithoutValueAction as AddProducerFormAction.GetListElementUIDataWithoutValueAction:
            return AddProducerFormReducerHandler
                .HandlerGetListElementUIDataWihoutValue().handle(action: getListElementUIDataWithoutValueAction, state)
        case let checkIfInputElemenIsValidAction as AddProducerFormAction.CheckIfInputElemenIsValidAction:
            return AddProducerFormReducerHandler
                .HandlerCheckIfInputElemenIsValidAction().handle(action: checkIfInputElemenIsValidAction, state)
        case let checkIfAllInputElementIsValidAction as AddProducerFormAction.CheckIfAllInputElementIsValidAction:
            return state
        default:
            return state
        }
    }
}

class AddProducerFormReducerHandler { }
