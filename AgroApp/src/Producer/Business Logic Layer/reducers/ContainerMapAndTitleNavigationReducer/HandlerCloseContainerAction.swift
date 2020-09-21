//
//  HandlerCloseContainerAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension ContainerMapAndTitleNavigationHandler {
    class HandlerCloseContainerAction: HandlerReducer {
        func handle(
            action: ContainerMapAndTitleNavigationAction.CloseContainerAction,
            _ state: ContainerMapAndTitleNavigationState
        ) -> ContainerMapAndTitleNavigationState {
            let util = UtilHandlerCloseContainerAction(state: state)
            return newState(util: util) ?? state
        }
        
        private func newState(util: UtilHandlerCloseContainerAction?) -> ContainerMapAndTitleNavigationState? {
            guard let newUtil = util else { return nil }
            return newUtil.state.changeValues(actionResponse: .closeContainerActionResponse)
        }
    }
    
    
    
    private struct UtilHandlerCloseContainerAction {
        let state: ContainerMapAndTitleNavigationState
    }
}
