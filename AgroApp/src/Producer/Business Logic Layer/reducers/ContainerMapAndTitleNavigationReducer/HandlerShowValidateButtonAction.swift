//
//  HandlerShowValidateButtonAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-15.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension ContainerMapAndTitleNavigationHandler {
    class HandlerShowValidateButtonAction: HandlerReducer {
        
        func handle(
            action: ContainerMapAndTitleNavigationAction.ShowValidateButtonAction,
            _ state: ContainerMapAndTitleNavigationState
        ) -> ContainerMapAndTitleNavigationState {
            let util = UtilHandlerShowValidateButtonAction(state: state)
            return newState(util: util) ?? state
        }
        
        private func newState(util: UtilHandlerShowValidateButtonAction?) -> ContainerMapAndTitleNavigationState? {
            guard let newUtil = util else { return nil }
            
            return newUtil
                .state
                .changeValues(actionResponse: .showValidateButtonActionResponse)
        }
    }
    
    private struct UtilHandlerShowValidateButtonAction {
        let state: ContainerMapAndTitleNavigationState
    }
}
