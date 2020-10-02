//
//  HandlerGetProducerListActionMiddleware.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift
import ReSwift

extension ProducerListMiddleware {
    class HandlerGetProducerListActionMiddleware: HanderMiddlewareAsync {
        func handle(
            _ action: ProducerListAction.GetProducerListAction,
            _ state: ProducerListState
        ) -> Single<Action> {
            let util = UtilHandlerGetProducerListActionMiddleware(state: state)
            
            return getProducerListWrapper(util)
                .map { self.makeAction($0) }
                .subscribeOn(Util.getSchedulerBackgroundForRequestServer())
                .observeOn(Util.getSchedulerBackgroundForReSwift())
        }
        
        private func getProducerListWrapper(_ util: UtilHandlerGetProducerListActionMiddleware) -> Single<UtilHandlerGetProducerListActionMiddleware> {
            Single.create { event in
                var newUtil = util
                newUtil.producerList = newUtil.state.producerList
                event(.success(newUtil))
                return Disposables.create()
            }
        }
        
        private func makeAction(_ util: UtilHandlerGetProducerListActionMiddleware) -> Action {
            guard let producerList = util.producerList else {
                return ProducerListAction.GetProducerListFailureAction()
            }
            
            return ProducerListAction.GetProducerListSuccesAction(producerList: producerList)
        }
        
        enum GetProducerListError: Error {
            case errorGetProducerInDabase
        }
    }
    
    private struct UtilHandlerGetProducerListActionMiddleware {
        let state: ProducerListState
        var producerList: [Producer]?
    }
}
