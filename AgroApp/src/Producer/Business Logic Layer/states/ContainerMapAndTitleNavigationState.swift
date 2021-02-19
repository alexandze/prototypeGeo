//
//  ContainerMapAndTitleNavigationState.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-13.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct ContainerMapAndTitleNavigationState: Equatable {
    static func == (lhs: ContainerMapAndTitleNavigationState, rhs: ContainerMapAndTitleNavigationState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }
    
    var uuidState: String
    var actionResponse: ActionResponse?
    
    enum ActionResponse {
        case hideValidateButtonActionResponse
        case showValidateButtonActionResponse
        case closeContainerActionResponse
        case makeProducerSuccessActionResponse(producer: Producer)
        case notActionResponse
    }
    
    func changeValues(
        actionResponse: ActionResponse?
    ) -> ContainerMapAndTitleNavigationState {
        ContainerMapAndTitleNavigationState(
            uuidState: UUID().uuidString,
            actionResponse: actionResponse ?? self.actionResponse
        )
    }
    
    func reset() -> ContainerMapAndTitleNavigationState {
        ContainerMapAndTitleNavigationState(
            uuidState: UUID().uuidString,
            actionResponse: .notActionResponse
        )
    }
}
