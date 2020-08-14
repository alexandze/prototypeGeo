//
//  HandlerCheckIfAllInputElementIsValidAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-13.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension AddProducerFormReducerHandler {
    class HandlerCheckIfAllInputElementIsValidAction: HandlerReducer {
        func handle(
            action: AddProducerFormAction.CheckIfAllInputElementIsValidAction,
            _ state: AddProducerFormState
        ) -> AddProducerFormState {
            let util = UtilHandlerCheckIfAllInputElementIsValidAction(state: state)

            return state
        }
    }

    private struct UtilHandlerCheckIfAllInputElementIsValidAction {
        var state: AddProducerFormState
    }

}
