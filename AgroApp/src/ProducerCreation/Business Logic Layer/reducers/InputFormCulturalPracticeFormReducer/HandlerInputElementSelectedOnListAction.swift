//
//  HandlerInputElementSelectedOnListAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-24.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension InputFormCulturalPracticeReducerHandler {
    
    class HandlerInputElementSelectedOnListAction: HandlerReducer {
        func handle(
            action: InputFormCulturalPracticeAction.InputElementSelectedOnListAction,
            _ state: InputFormCulturalPracticeState
        ) -> InputFormCulturalPracticeState {
            let util = UtilInputElementSelectedOnListAction(
                state: state, sectionInputElement: action.sectionInputElement,
                field: action.field
            )
            
            return newState(util: util) ?? state
        }
        
        private func newState(util: UtilInputElementSelectedOnListAction?) -> InputFormCulturalPracticeState? {
            guard let newUtil = util else {
                return nil
            }
            
            return newUtil.state.changeValue(
                sectionInputElement: newUtil.sectionInputElement,
                field: newUtil.field,
                inputFormCulturalPracticeActionResponse: .inputElementSelectedOnListActionResponse,
                isDirty: false
            )
        }
    }
    
    private struct UtilInputElementSelectedOnListAction {
        let state: InputFormCulturalPracticeState
        let sectionInputElement: Section<ElementUIData>
        let field: Field
    }
}
