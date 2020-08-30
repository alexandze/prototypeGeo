//
//  HandlerCloseContainerFormWithoutSaveAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension ContainerFormCulturalPracticeHandler {
    class HandlerCloseContainerFormWithoutSaveAction: HandlerReducer {
        func handle(
            action: ContainerFormCulturalPracticeAction.CloseContainerFormWithoutSaveAction,
            _ state: ContainerFormCulturalPracticeState
        ) -> ContainerFormCulturalPracticeState {
            let util = UtilHandlerCloseContainerFormWithoutSaveAction(state: state)
            return newState(util: util) ?? state
        }
        
        private func newState(util: UtilHandlerCloseContainerFormWithoutSaveAction?) -> ContainerFormCulturalPracticeState? {
            guard let newUtil = util else {
                return nil
            }
            
            return newUtil.state.changeValue(actionResponse: .closeContainerFormWithoutSaveActionResponse)
        }
    }
    
    private struct UtilHandlerCloseContainerFormWithoutSaveAction {
        let state: ContainerFormCulturalPracticeState
    }
}
