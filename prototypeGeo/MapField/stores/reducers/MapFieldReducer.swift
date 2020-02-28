//
//  MapFieldReducer.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func MapFieldReducer(action: Action, state: MapFieldState?) -> MapFieldState {
        var state = state ?? MapFieldState()
        
        switch action {
        case let getAllMapFieldSuccess as MapFieldAction.GetAllFieldSuccess :
            state.mapFieldAllFieldsState = getAllMapFieldSuccess.mapFieldAllFieldState
        default:
            break
        }
        
        return state
    }
}
