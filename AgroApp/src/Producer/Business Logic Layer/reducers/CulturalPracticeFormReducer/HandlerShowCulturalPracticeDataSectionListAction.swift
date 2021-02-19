//
//  HandlerShowCulturalPracticeDataSectionListAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-31.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension CulturalPracticeFormReducerHandler {
    class HandlerShowCulturalPracticeDataSectionListAction: HandlerReducer {
        func handle(
            action: CulturalPracticeFormAction.ShowCulturalPracticeDataSectionListAction,
            _ state: CulturalPracticeFormState
        ) -> CulturalPracticeFormState {
            let util = UtilHandlerShowCulturalPracticeDataSectionListAction(state: state)
            
            return (
               makeIndexPathRemove(util: ) >>>
                    makeIndexPathAdd(util:) >>>
                    newState(util:)
            )(util) ?? state
        }
        
        // TODO duplicate
        private func makeIndexPathRemove(util: UtilHandlerShowCulturalPracticeDataSectionListAction?) -> UtilHandlerShowCulturalPracticeDataSectionListAction? {
            guard var newUtil = util,
                let currentSectionList = util?.state.sections else {
                    return nil
            }
            
            newUtil.indexPathRemoveList = (0..<currentSectionList.count).map { IndexPath(row: 0, section: $0) }
            return newUtil
        }
        
        //TODO duplicate
        private func makeIndexPathAdd(util: UtilHandlerShowCulturalPracticeDataSectionListAction?) -> UtilHandlerShowCulturalPracticeDataSectionListAction? {
            guard var newUtil = util,
                let culturalPracticeSectionList = newUtil.state.culturalPracticeElementSectionList else {
                return nil
            }
            
            newUtil.indexPathAddList = (0..<culturalPracticeSectionList.count).map { IndexPath(row: 0, section: $0) }
            return newUtil
        }
        
        private func newState(util: UtilHandlerShowCulturalPracticeDataSectionListAction?) -> CulturalPracticeFormState? {
            guard let newUtil =  util,
                let culturalPracticeElementSectionList = newUtil.state.culturalPracticeElementSectionList,
                let indexPathAddList = newUtil.indexPathAddList,
                let indexPathRemove = newUtil.indexPathRemoveList
            else {
                return nil
            }
            
            return newUtil.state.changeValues(
                sections: culturalPracticeElementSectionList,
                responseAction: .showCulturalPracticeDataSectionListActionResponse(
                    indexPathRemove: indexPathRemove,
                    indexPathAdd: indexPathAddList
                )
            )
        }
    }
    
    private struct UtilHandlerShowCulturalPracticeDataSectionListAction {
        var state: CulturalPracticeFormState
        var indexPathRemoveList: [IndexPath]?
        var indexPathAddList: [IndexPath]?
    }
}
