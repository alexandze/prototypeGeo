//
//  HandlerCheckIfFormIsDirtyAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-26.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension SelectFormCulturalPracticeHandlerReducer {
    class HandlerCheckIfFormIsDirtyAction: HandlerReducer {
        func handle(
            action: SelectFormCulturalPracticeAction.CheckIfFormIsDirtyAction,
            _ state: SelectFormCulturalPracticeState
        ) -> SelectFormCulturalPracticeState {
            let util = UtilHandlerCheckIfFormIsDirtyAction(state: state, indexSelected: action.indexSelected)
            
            return (
                isFormDirty(util: ) >>>
                    newState(util:)
            )(util) ?? state
        }
        
        private func isFormDirty(util: UtilHandlerCheckIfFormIsDirtyAction?) -> UtilHandlerCheckIfFormIsDirtyAction? {
            guard var newUtil = util,
                let selectElement = newUtil.state.selectElement else {
                return nil
            }
            
            newUtil.isFormDirty = selectElement.rawValue != newUtil.indexSelected
            return newUtil
        }
        
        private func newState(util: UtilHandlerCheckIfFormIsDirtyAction?) -> SelectFormCulturalPracticeState? {
            guard let newUtil = util,
                let isDirty = newUtil.isFormDirty else {
                return nil
            }
            
            return newUtil.state.changeValue(actionResponse: .checkIfFormIsDirtyActionResponse(isDirty: isDirty))
        }
        
    }
    
    private struct UtilHandlerCheckIfFormIsDirtyAction {
        let state: SelectFormCulturalPracticeState
        let indexSelected: Int
        var isFormDirty: Bool?
    }
}
