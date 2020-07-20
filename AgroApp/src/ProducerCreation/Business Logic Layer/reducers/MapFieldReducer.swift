//
//  MapFieldReducer1.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-17.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    static func mapFieldReducer(action: Action, state: MapFieldState?) -> MapFieldState {
        let state = state ?? MapFieldState(uuidState: UUID().uuidString)

        switch action {
        case let getAllMapFieldSuccess as MapFieldAction.GetAllFieldSuccess :
            return MapFieldReducerHandler.handle(getAllFieldSuccess: getAllMapFieldSuccess, state: state)
        default:
            return state
        }
    }
}

class MapFieldReducerHandler {
    static func handle(
        getAllFieldSuccess: MapFieldAction.GetAllFieldSuccess,
        state: MapFieldState
    ) -> MapFieldState {
        getAllFieldSuccess.mapFieldAllFieldState
    }
}
