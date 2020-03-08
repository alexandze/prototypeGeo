//
//  Reducers.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct Reducers {
    public static func appReducer(action: Action, state: AppState?) -> AppState {
        return AppState(
            farmerState: Reducers.farmerReducer(action: action, state: state?.farmerState),
            mapFieldState: Reducers.mapFieldReducer(action: action, state: state?.mapFieldState)
        )
    }
}
