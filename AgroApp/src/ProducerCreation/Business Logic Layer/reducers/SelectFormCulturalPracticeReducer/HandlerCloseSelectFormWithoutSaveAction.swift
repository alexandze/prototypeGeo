//
//  HandlerCloseSelectFormWithoutSaveAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-26.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension SelectFormCulturalPracticeHandlerReducer {
    class HandlerCloseSelectFormWithoutSaveAction: HandlerReducer {
        func handle(action: SelectFormCulturalPracticeAction.CloseSelectFormWithoutSaveAction, _ state: SelectFormCulturalPracticeState) -> SelectFormCulturalPracticeState {
            let util = UtilHandlerCloseSelectFormWithoutSaveAction(state: state)
            return newState(util: util) ?? state
        }
        
        private func newState(util: UtilHandlerCloseSelectFormWithoutSaveAction?) -> SelectFormCulturalPracticeState? {
            guard let newUtil = util else {
                return nil
            }
            
            return newUtil.state.changeValue(actionResponse: .closeSelectFormWithoutSaveAction)
        }
    }
    
    private struct UtilHandlerCloseSelectFormWithoutSaveAction {
        let state: SelectFormCulturalPracticeState
    }
}

