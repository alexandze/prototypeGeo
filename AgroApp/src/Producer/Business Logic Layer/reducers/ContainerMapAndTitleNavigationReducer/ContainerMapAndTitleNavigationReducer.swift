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
        var state = state ?? ContainerMapAndTitleNavigationState(uuidState: UUID().uuidString)
        return state
    }
}

class ContainerMapAndTitleNavigationHandler { }
