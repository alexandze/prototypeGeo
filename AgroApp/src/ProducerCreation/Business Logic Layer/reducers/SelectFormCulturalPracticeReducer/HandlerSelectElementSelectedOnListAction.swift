//
//  HandlerSelectElementSelectedOnListAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-25.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension SelectFormCulturalPracticeHandlerReducer {
    class HandlerSelectElementSelectedOnListAction: HandlerReducer {
        func handle(
            action: SelectFormCulturalPracticeAction.SelectElementSelectedOnListAction,
            _ state: SelectFormCulturalPracticeState
        ) -> SelectFormCulturalPracticeState {
            let util = UtilHandlerSelectElementSelectedOnListAction(
                state: state,
                sectionSelected: action.section,
                fieldSelected: action.field
            )
            
            return (
                initSelectElement(util: ) >>>
                    newState(util:)
            )(util) ?? state
        }
        
        private func initSelectElement(
            util: UtilHandlerSelectElementSelectedOnListAction?
        ) -> UtilHandlerSelectElementSelectedOnListAction? {
            guard var newUtil = util,
                Util.hasIndexInArray(newUtil.sectionSelected.rowData, index: 0),
                let selectElement = newUtil.sectionSelected.rowData[0] as? SelectElement else {
                return nil
            }
            
            newUtil.newSelectElement = selectElement
            return newUtil
        }
        
        private func newState(util: UtilHandlerSelectElementSelectedOnListAction?) -> SelectFormCulturalPracticeState? {
            guard let newUtil = util,
                let newSelectElement = newUtil.newSelectElement
            else {
                return nil
            }
            
            return newUtil.state.changeValue(
                selectElement: newSelectElement,
                section: newUtil.sectionSelected,
                field: newUtil.fieldSelected,
                isDirty: false,
                actionResponse: .selectElementSelectedOnListActionResponse
            )
        }
    }
    
    private struct UtilHandlerSelectElementSelectedOnListAction {
        var state: SelectFormCulturalPracticeState
        var sectionSelected: Section<ElementUIData>
        var fieldSelected: Field
        var newSelectElement: SelectElement?
    }
}
