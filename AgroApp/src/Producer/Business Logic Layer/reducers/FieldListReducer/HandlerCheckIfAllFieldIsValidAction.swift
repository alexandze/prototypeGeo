//
//  HandlerCheckIfAllFieldIsValidAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-14.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension FieldListReducerHandler {
    class HandlerCheckIfAllFieldIsValidAction: HandlerReducer {
        func handle(
            action: FieldListAction.CheckIfAllFieldIsValidAction,
            _ state: FieldListState
        ) -> FieldListState {
            let util = UtilHandlerCheckIfAllFieldIsValidAction(state: state)
            
            return (
                checkIfAllFieldIsValidWrapper(util: ) >>>
                    newState(util:)
            )(util) ?? state
        }
        
        private func checkIfAllFieldIsValidWrapper(util: UtilHandlerCheckIfAllFieldIsValidAction?) -> UtilHandlerCheckIfAllFieldIsValidAction? {
            guard var newUtil = util,
                let fieldList = newUtil.state.fieldList
            else {
                return nil
            }
            
            newUtil.isAllFieldValid = checkIfAllFieldIsValid(fieldList)
            return newUtil
        }
        
        private func newState(util: UtilHandlerCheckIfAllFieldIsValidAction?) -> FieldListState? {
            guard let newUtil = util, let isAllFieldValid = newUtil.isAllFieldValid else {
                return nil
            }
            
            return newUtil.state.changeValue(
                subAction: .checkIfAllFieldIsValidActionResponse(isAllFieldValid: isAllFieldValid)
            )
        }
        
        private func checkIfAllFieldIsValid(_ fieldList: [Field]) -> Bool {
            fieldList.first { $0.isValid() && $0.culturalPratice != nil && $0.culturalPratice!.isValid() } != nil
        }
    }
    
    private struct UtilHandlerCheckIfAllFieldIsValidAction {
        var state: FieldListState
        var isAllFieldValid: Bool?
    }
}
