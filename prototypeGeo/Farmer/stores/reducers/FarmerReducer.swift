//
//  FarmerReducer.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func farmerReducer(action: Action, state: FarmerState?) -> FarmerState {
        var state = state ?? FarmerState()
        
        switch action {
        case let successGetFamers as SuccessGetFamersAction:
            state.farmerTableViewControllerState = successGetFamers.farmerTableViewControllerState
        default:
            break
        }
        
        return state
    }
}
