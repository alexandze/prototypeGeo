//
//  ProducerListMiddleware.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift

class ProducerListMiddleware {
    var middleware: Middleware<AppState> = { dispatch, getState in
        return { next in
            return { action in
                
                switch action {
                case let makeProducerAction as ContainerMapAndTitleNavigationAction.MakeProducerSuccessAction:
                    ProducerListMiddleware().makeProducerSuccessAction(makeProducerAction, getState, dispatch)
                default:
                    break
                }
                
                return next(action)
            }
        }
    }
    
    private func makeProducerSuccessAction(
        _ action: ContainerMapAndTitleNavigationAction.MakeProducerSuccessAction,
        _ getState: @escaping () -> AppState?,
        _ dispatch: @escaping DispatchFunction
    ) {
        guard let producerListState = getState()?.producerListState else {
            let action = ProducerListAction.SaveNewProducerInDatabaseErrorAction()
            return dispatch(action)
        }
        
        _ = HandlerMakeProducerSuccessActionMiddleware()
            .handle(action, producerListState)
            .subscribe { element in
                switch element {
                case .success(let newAction):
                    dispatch(newAction)
                case .error(_):
                    dispatch(ProducerListAction.SaveNewProducerInDatabaseErrorAction())
                }
        }
    }
}
