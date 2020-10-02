//
//  HandlerGetProducerListSuccesAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension ProducerListHandler {
    class HandlerGetProducerListSuccesAction: HandlerReducer {
        func handle(
            action: ProducerListAction.GetProducerListSuccesAction,
            _ state: ProducerListState
        ) -> ProducerListState {
            let util = UtilHandlerGetProducerListSuccesAction(state: state, newProducerList: action.producerList)
            return newState(util: util) ?? state
        }
        
        private func newState(util: UtilHandlerGetProducerListSuccesAction?) -> ProducerListState? {
            guard let newUtil = util else { return nil }
            return newUtil.state.changeValue(
                producerList: newUtil.newProducerList,
                isEmptyFarmers: newUtil.newProducerList.isEmpty,
                actionResponse: .getProducerListSuccesActionResponse
            )
        }
        
    }
    
    private struct UtilHandlerGetProducerListSuccesAction {
        let state: ProducerListState
        var newProducerList: [Producer]
    }
}
