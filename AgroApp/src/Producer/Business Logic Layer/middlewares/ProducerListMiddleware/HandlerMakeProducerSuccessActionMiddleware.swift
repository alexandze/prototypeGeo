//
//  HandlerMakeProducerSuccessActionMiddleware.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift
import ReSwift

extension ProducerListMiddleware {
    class HandlerMakeProducerSuccessActionMiddleware: HanderMiddlewareAsync {
        func handle(
            _ action: ContainerMapAndTitleNavigationAction.MakeProducerSuccessAction,
            _ state: ProducerListState
        ) -> Single<Action> {
            let util = UtilHandlerMakeProducerSuccessActionMiddleware(state: state, newProducer: action.producer)
            
            return saveProducerInDatabaseWrapper(util: util)
                .flatMap { self.makeSaveNewProducerInDabaseActionWrapper(util: $0) }
                .subscribeOn(Util.getSchedulerBackgroundForRequestServer())
                .observeOn(Util.getSchedulerBackgroundForReSwift())
        }
        
        
        private func saveProducerInDatabaseWrapper(util: UtilHandlerMakeProducerSuccessActionMiddleware) -> Single<UtilHandlerMakeProducerSuccessActionMiddleware> {
            saveProducerInDatabase(util.newProducer)
                .map { producer in
                    var copyUtil = util
                    copyUtil.newProducerFromDatabase = producer
                    return copyUtil
            }
        }
        
        func saveProducerInDatabase(_ producer: Producer) -> Single<Producer> {
            Single.create { even in
                even(.success(producer))
                return Disposables.create()
            }
        }
        
        private func makeSaveNewProducerInDabaseActionWrapper(util: UtilHandlerMakeProducerSuccessActionMiddleware) -> Single<Action> {
            Single.create { event in
                if let saveNewProducerInDatabaseAction = self.makeSaveNewProducerInDabaseAction(util: util) {
                    event(.success(saveNewProducerInDatabaseAction))
                    return Disposables.create()
                }
                
                event(.success(ProducerListAction.SaveNewProducerInDatabaseErrorAction()))
                return Disposables.create()
            }
        }
         
        private func makeSaveNewProducerInDabaseAction(util: UtilHandlerMakeProducerSuccessActionMiddleware) -> ProducerListAction.SaveNewProducerInDatabaseSuccessAction? {
            guard let newProducerFromDatabase = util.newProducerFromDatabase else { return nil }
            return ProducerListAction.SaveNewProducerInDatabaseSuccessAction(producer: newProducerFromDatabase)
        }
    }
    
    private struct UtilHandlerMakeProducerSuccessActionMiddleware {
        let state: ProducerListState
        let newProducer: Producer
        var newProducerFromDatabase: Producer?
    }
}
