//
//  HandlerMakeProducerSuccessAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension ContainerMapAndTitleNavigationHandler {
    class HandlerMakeProducerSuccessAction: HandlerReducer {
        func handle(
            action: ContainerMapAndTitleNavigationAction.MakeProducerSuccessAction,
            _ state: ContainerMapAndTitleNavigationState
        ) -> ContainerMapAndTitleNavigationState {
            let util = UtilHandlerMakeProducerSuccessAction(state: state, producer: action.producer)
            return newState(util: util) ?? state
        }
        
        private func newState(util: UtilHandlerMakeProducerSuccessAction?) -> ContainerMapAndTitleNavigationState? {
            guard let newUtil = util else {
                return nil
            }
            
            return newUtil.state.changeValues(
                actionResponse: .makeProducerSuccessActionResponse(producer: newUtil.producer)
            )
        }
    }
    
    private struct UtilHandlerMakeProducerSuccessAction {
        let state: ContainerMapAndTitleNavigationState
        let producer: Producer
    }
}
