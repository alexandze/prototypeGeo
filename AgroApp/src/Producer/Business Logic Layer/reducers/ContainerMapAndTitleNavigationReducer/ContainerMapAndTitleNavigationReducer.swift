//
//  ContainerMapAndTitleNavigationReducer.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-13.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func containerMapAndTitleNavigationReducer(
        action: Action,
        state: ContainerMapAndTitleNavigationState?
    ) -> ContainerMapAndTitleNavigationState {
        let state = state ?? ContainerMapAndTitleNavigationState(uuidState: UUID().uuidString)
        
        switch action {
        case let hideValidateButtonAction as ContainerMapAndTitleNavigationAction.HideValidateButtonAction:
            return ContainerMapAndTitleNavigationHandler
                .HandlerHideValidateButtonAction().handle(action: hideValidateButtonAction, state)
        case let showValidateButtonAction as ContainerMapAndTitleNavigationAction.ShowValidateButtonAction:
            return ContainerMapAndTitleNavigationHandler
                .HandlerShowValidateButtonAction().handle(action: showValidateButtonAction, state)
        default:
            return state
        }
    }
}

class ContainerMapAndTitleNavigationHandler { }
