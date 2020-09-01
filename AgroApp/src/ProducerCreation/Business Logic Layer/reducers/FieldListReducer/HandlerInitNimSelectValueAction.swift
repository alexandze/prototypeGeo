//
//  HandlerInitNimSelectValueAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension FieldListReducerHandler {
    class HandlerInitNimSelectValueAction: HandlerReducer {
        func handle(action: FieldListAction.InitNimSelectValueAction, _ state: FieldListState) -> FieldListState {
            let util = UtilHandlerInitNimSelectValueAction(state: state, nimSelectValue: action.nimSelectValue)
            return newState(util: util) ?? state
        }
        
        private func newState(util: UtilHandlerInitNimSelectValueAction?) -> FieldListState? {
            guard let newUtil = util else {
                return nil
            }
            // TODO refactoring
            if let fieldList = newUtil.state.fieldList {
                let newfieldList = fieldList.map { (field: Field) -> Field in
                    var copyField = field
                    copyField.nim = newUtil.nimSelectValue
                    return copyField
                }
                
                return newUtil.state
                    .changeValue(fieldList: newfieldList, subAction: .initNimSelectValueActionResponse, nimSelectValue: newUtil.nimSelectValue)
                
            }
            
            return newUtil.state
                .changeValue(subAction: .initNimSelectValueActionResponse, nimSelectValue: newUtil.nimSelectValue)
        }
    }
    
    private struct UtilHandlerInitNimSelectValueAction {
        let state: FieldListState
        let nimSelectValue: NimSelectValue
    }
}
