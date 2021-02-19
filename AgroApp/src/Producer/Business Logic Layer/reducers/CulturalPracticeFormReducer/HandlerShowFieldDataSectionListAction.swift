//
//  HandlerShowFieldDataSectionListAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-31.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension CulturalPracticeFormReducerHandler {
    class HandlerShowFieldDataSectionListAction: HandlerReducer {
        func handle(
            action: CulturalPracticeFormAction.ShowFieldDataSectionListAction,
            _ state: CulturalPracticeFormState
        ) -> CulturalPracticeFormState {
            let util = UtilHandlerShowFieldDataSectionListAction(state: state)
            
            return (
               makeIndexPathRemove(util: ) >>>
                    makeIndexPathAdd(util:) >>>
                    newState(util:)
            )(util) ?? state
        }
        
        private func makeIndexPathRemove(util: UtilHandlerShowFieldDataSectionListAction?) -> UtilHandlerShowFieldDataSectionListAction? {
            guard var newUtil = util,
                let currentSectionList = util?.state.sections else {
                    return nil
            }
            
            newUtil.indexPathRemoveList = (0..<currentSectionList.count).map { IndexPath(row: 0, section: $0) }
            return newUtil
        }
        
        private func makeIndexPathAdd(util: UtilHandlerShowFieldDataSectionListAction?) -> UtilHandlerShowFieldDataSectionListAction? {
            guard var newUtil = util,
                let fieldSectionList = newUtil.state.fieldElementSectionList else {
                return nil
            }
            
            newUtil.indexPathAddList = (0..<fieldSectionList.count).map { IndexPath(row: 0, section: $0) }
            return newUtil
        }
        
        private func newState(util: UtilHandlerShowFieldDataSectionListAction?) -> CulturalPracticeFormState? {
            guard let newUtil =  util,
                let fieldSectionList = newUtil.state.fieldElementSectionList,
                let indexPathAddList = newUtil.indexPathAddList,
                let indexPathRemove = newUtil.indexPathRemoveList
            else {
                return nil
            }
            
            return newUtil.state.changeValues(
                sections: fieldSectionList,
                responseAction: .showFieldDataSectionListActionResponse(
                    indexPathRemove: indexPathRemove,
                    indexPathAdd: indexPathAddList
                )
            )
        }
    }
    
    private struct UtilHandlerShowFieldDataSectionListAction {
        var state: CulturalPracticeFormState
        var indexPathRemoveList: [IndexPath]?
        var indexPathAddList: [IndexPath]?
    }
}
