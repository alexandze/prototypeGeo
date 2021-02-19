//
//  ProducerListReducer.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func producerListReducer(action: Action, state: ProducerListState?) -> ProducerListState {
        let state = state ?? ProducerListState(uuidState: UUID().uuidString)

        switch action {
        case let getProducerListSuccessAction as ProducerListAction.GetProducerListSuccesAction:
            return ProducerListHandler
                .HandlerGetProducerListSuccesAction().handle(action: getProducerListSuccessAction, state)
        case let saveNewProducerInDatabaseSuccessAction as ProducerListAction.SaveNewProducerInDatabaseSuccessAction:
            return ProducerListHandler
                .HandlerSaveNewProducerInDatabaseSuccessAction().handle(action: saveNewProducerInDatabaseSuccessAction, state)
        default:
            break
        }
        
        return state
    }
}

class ProducerListHandler { }
