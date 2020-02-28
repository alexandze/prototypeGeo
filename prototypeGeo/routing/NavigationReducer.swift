//
//  NavigationReducer.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-08.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func navigationReducer(action: Action, state: NavigationState?) -> NavigationState {
        var state = state ?? NavigationState()
        
        switch action {
        case let navigationAction as NavigationAction:
            state = NavigationState(url: navigationAction.url, data: navigationAction.data)
        default:
            break
        }
        
        return state
    }
}
