//
//  HandlerHideValidateButtonAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-15.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension ContainerMapAndTitleNavigationHandler {
    class HandlerHideValidateButtonAction: HandlerReducer {
        
        func handle(
            action: ContainerMapAndTitleNavigationAction.HideValidateButtonAction,
            _ state: ContainerMapAndTitleNavigationState
        ) -> ContainerMapAndTitleNavigationState {
            let util = UtilHandlerHideValidateButtonAction(state: state)
            return newState(util: util) ?? state
        }
        
        private func newState(util: UtilHandlerHideValidateButtonAction?) -> ContainerMapAndTitleNavigationState? {
            guard let newUtil = util else { return nil }
            
            return newUtil
                .state
                .changeValues(actionResponse: .hideValidateButtonActionResponse)
        }
    }
    
    private struct UtilHandlerHideValidateButtonAction {
        let state: ContainerMapAndTitleNavigationState
    }
}
