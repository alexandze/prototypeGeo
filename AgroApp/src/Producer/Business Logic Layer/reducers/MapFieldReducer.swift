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
        case let getAllMapFieldSuccess as MapFieldAction.GetAllFieldSuccessAction :
            return MapFieldReducerHandler().handle(getAllFieldSuccess: getAllMapFieldSuccess, state)
        case let willSelectedFieldOnMapAction as MapFieldAction.WillSelectedFieldOnMapAction:
            return MapFieldReducerHandler().handle(willSelectedFieldOnMapAction: willSelectedFieldOnMapAction, state)
        case let getAllFieldAction as MapFieldAction.GetAllFieldAction:
            return MapFieldReducerHandler().handle(getAllFieldAction: getAllFieldAction, state)
        case let willDeselectFieldOnMapAction as MapFieldAction.WillDeselectFieldOnMapAction:
            return MapFieldReducerHandler().handle(willDeselectFieldOnMapAction: willDeselectFieldOnMapAction, state)
        case _ as ContainerMapAndTitleNavigationAction.KillStateAction:
            return state.reset()
        default:
            return state
        }
    }
}

class MapFieldReducerHandler {
    func handle(
        willDeselectFieldOnMapAction: MapFieldAction.WillDeselectFieldOnMapAction,
        _ state: MapFieldState
    ) -> MapFieldState {
        state.changeValues(
            lastFieldDeselected: willDeselectFieldOnMapAction.field,
            responseAction: .willDeselectFieldOnMapActionResponse
        )
    }

    func handle(
        getAllFieldSuccess: MapFieldAction.GetAllFieldSuccessAction,
        _ state: MapFieldState
    ) -> MapFieldState {
        state.changeValues(
            fieldDictionnary: getAllFieldSuccess.fieldDictionnary,
            responseAction: .getAllFieldActionSuccessResponse
        )
    }

    func handle(
        willSelectedFieldOnMapAction: MapFieldAction.WillSelectedFieldOnMapAction,
        _ state: MapFieldState
    ) -> MapFieldState {
        state.changeValues(
            lastFieldSelected: willSelectedFieldOnMapAction.field,
            responseAction: .willSelectedFieldOnMapActionResponse
        )
    }

    func handle(
        getAllFieldAction: MapFieldAction.GetAllFieldAction,
        _ state: MapFieldState
    ) -> MapFieldState {
        state.changeValues(
            responseAction: .getAllFieldActionResponse
        )
    }
}
