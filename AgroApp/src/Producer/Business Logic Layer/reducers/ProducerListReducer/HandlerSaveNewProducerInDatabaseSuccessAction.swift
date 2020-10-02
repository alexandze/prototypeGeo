//
//  HandlerSaveNewProducerInDatabaseSuccessAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension ProducerListHandler {
    class HandlerSaveNewProducerInDatabaseSuccessAction: HandlerReducer {
        func handle(
            action: ProducerListAction.SaveNewProducerInDatabaseSuccessAction,
            _ state: ProducerListState
        ) -> ProducerListState {
            let util = UtilHandlerSaveNewProducerInDatabaseSuccessAction(state: state, newProducer: action.producer)
            
            return (
                addProducerWrapper(util: ) >>>
                    newState(util:)
            )(util) ?? state
        }
        
        private func addProducerWrapper(util: UtilHandlerSaveNewProducerInDatabaseSuccessAction?) -> UtilHandlerSaveNewProducerInDatabaseSuccessAction? {
            guard var newUtil = util else {
                return nil
            }
            
            var producerList = newUtil.state.producerList ?? []
            producerList = addProducer(newUtil.newProducer, inList: producerList)
            newUtil.newProducerList = producerList
            return newUtil
        }
        
        private func addProducer(_ producer: Producer, inList producerList: [Producer]) -> [Producer] {
            [producer] + producerList
        }
        
        private func newState(util: UtilHandlerSaveNewProducerInDatabaseSuccessAction?) -> ProducerListState? {
            guard let newUtil = util,
                let producerList = newUtil.newProducerList else { return nil }
            
            return newUtil.state.changeValue(
                producerList: producerList,
                isEmptyFarmers: false,
                actionResponse: .saveNewProducerInDatabaseSuccessActionResponse
            )
        }
    }
    
    private struct UtilHandlerSaveNewProducerInDatabaseSuccessAction {
        let state: ProducerListState
        let newProducer: Producer
        var newProducerList: [Producer]?
    }
}
