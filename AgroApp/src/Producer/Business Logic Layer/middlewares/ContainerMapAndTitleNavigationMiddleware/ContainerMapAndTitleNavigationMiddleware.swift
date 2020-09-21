//
//  ContainerMapAndTitleNavigationMiddleware.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-13.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

class ContainerMapAndTitleNavigationMiddleware {
    var middleware: Middleware<AppState> = { dispatch, getState in
        return { next in
            return { action in
                
                switch action {
                case let makeProducer as ContainerMapAndTitleNavigationAction.MakeProducerAction:
                    ContainerMapAndTitleNavigationMiddleware().handleMakeProducerAction(makeProducer, getState, dispatch)
                default:
                    break
                }
                
                return next(action)
            }
        }
    }
    
    private func handleMakeProducerAction(
        _ action: ContainerMapAndTitleNavigationAction.MakeProducerAction,
        _ getState: @escaping () -> AppState?,
        _ dispatch: @escaping DispatchFunction
    ) {
        guard let appState = getState() else {
            let action = ContainerMapAndTitleNavigationAction.MakeProducerFailureAction()
            return dispatch(action)
        }
        
        let action = HandlerMakeProducerActionMiddleware().handle(action, appState)
        dispatch(action)
    }
}
