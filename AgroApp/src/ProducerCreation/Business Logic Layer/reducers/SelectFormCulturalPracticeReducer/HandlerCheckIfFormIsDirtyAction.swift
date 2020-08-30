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
                getRawValueByIndexSelected(util: ) >>>
                isFormDirty(util: ) >>>
                    newState(util:)
            )(util) ?? state
        }
        
        private func getRawValueByIndexSelected(util: UtilHandlerCheckIfFormIsDirtyAction?) -> UtilHandlerCheckIfFormIsDirtyAction? {
            guard var newUtil = util,
                let values = newUtil.state.selectElement?.values,
                Util.hasIndexInArray(values, index: newUtil.indexSelected) else { return nil }
            
            newUtil.rawValueFind = values[newUtil.indexSelected].0
            return newUtil
        }
        
        private func isFormDirty(util: UtilHandlerCheckIfFormIsDirtyAction?) -> UtilHandlerCheckIfFormIsDirtyAction? {
            guard var newUtil = util,
                let selectElement = newUtil.state.selectElement,
                let rawValueFind = newUtil.rawValueFind else {
                return nil
            }
            
            newUtil.isFormDirty = selectElement.rawValue != rawValueFind
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
        var rawValueFind: Int?
    }
}
