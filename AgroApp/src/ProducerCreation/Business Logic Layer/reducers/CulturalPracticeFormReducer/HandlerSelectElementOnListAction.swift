//
//  HandlerSelectElementOnListAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-23.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension CulturalPracticeFormReducerHandler {
    class HandlerSelectElementOnListAction: HandlerReducer {
        func handle(action: CulturalPracticeFormAction.SelectElementOnListAction, _ state: CulturalPracticeFormState) -> CulturalPracticeFormState {
            let util = UtilSelectElementOnListAction(state: state, selectIndexPath: action.indexPath)
            
            return (
                checkIfCanSelectElement(util: ) >>>
                    getSectionSelected(util: ) >>>
                    newState(util: )
            )(util) ?? state
        }
        
        private func checkIfCanSelectElement(util: UtilSelectElementOnListAction?) -> UtilSelectElementOnListAction? {
            guard let newUtil = util,
                let sectionList = newUtil.state.sections,
                Util.hasIndexInArray(sectionList, index: newUtil.selectIndexPath.section)
                else { return nil }
            
            let section = sectionList[newUtil.selectIndexPath.section]
            
            let isCanSelectSection = (section.typeSection == SelectElement.TYPE_ELEMENT ||
                section.typeSection == InputElement.TYPE_ELEMENT ||
                section.typeSection == ElementUIListData.TYPE_ELEMENT)
            
            guard isCanSelectSection else {
                return nil
            }
            
            return newUtil
        }
        
        private func getSectionSelected(util: UtilSelectElementOnListAction?) -> UtilSelectElementOnListAction? {
            guard var newUtil = util,
                let sectionList = newUtil.state.sections
                else { return nil }
            
            newUtil.sectionSelected = sectionList[newUtil.selectIndexPath.section]
            return newUtil
        }
        
        private func newState(util: UtilSelectElementOnListAction?) -> CulturalPracticeFormState? {
            guard let newUtil = util,
                let sectionSelected = newUtil.sectionSelected
                else { return nil }
            
            return newUtil.state.changeValues(
                responseAction: .selectElementOnListResponse(section: sectionSelected)
            )
        }
    }
    
    private struct UtilSelectElementOnListAction {
        var state: CulturalPracticeFormState
        var selectIndexPath: IndexPath
        var sectionSelected: Section<ElementUIData>?
    }
    
}

