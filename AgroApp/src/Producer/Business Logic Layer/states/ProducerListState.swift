//
//  ProducerListState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct ProducerListState: Equatable {
    static func == (lhs: ProducerListState, rhs: ProducerListState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var producerList: [Producer]?
    var isEmptyFarmers: Bool?
    var actionResponse: ActionResponse?
    
    enum ActionResponse {
        case saveNewProducerInDatabaseSuccessActionResponse
        case getProducerListSuccesActionResponse
        case notActionResponse
    }
    
    func changeValue(
        producerList: [Producer]? = nil,
        isEmptyFarmers: Bool? = nil,
        actionResponse: ActionResponse
    ) -> ProducerListState {
        ProducerListState(
            uuidState: UUID().uuidString,
            producerList: producerList ?? self.producerList,
            isEmptyFarmers: isEmptyFarmers ?? self.isEmptyFarmers,
            actionResponse: actionResponse
        )
    }
    
    func reset() -> ProducerListState {
        ProducerListState(
            uuidState: UUID().uuidString,
            producerList: nil,
            isEmptyFarmers: nil,
            actionResponse: .notActionResponse
        )
    }
}
