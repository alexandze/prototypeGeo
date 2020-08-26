//
//  HandlerCloseInputFormWithoutSaveAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-24.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension InputFormCulturalPracticeReducerHandler {
    class HandlerCloseInputFormWithoutSaveAction: HandlerReducer {
        func handle(
            action: InputFormCulturalPracticeAction.CloseInputFormWithoutSaveAction,
            _ state: InputFormCulturalPracticeState
        ) -> InputFormCulturalPracticeState {
            let util = UtilHandlerCloseInputFormWithoutSaveAction(state: state)
            return newState(util: util) ?? state
        }
        
        private func newState(util: UtilHandlerCloseInputFormWithoutSaveAction?) -> InputFormCulturalPracticeState? {
            guard let newUtil = util else {
                return nil
            }
            
            return newUtil.state.changeValue(
                actionResponse: .closeInputFormWithoutSaveActionResponse
            )
        }
    }
    
    private struct UtilHandlerCloseInputFormWithoutSaveAction {
        var state: InputFormCulturalPracticeState
    }
    
}
