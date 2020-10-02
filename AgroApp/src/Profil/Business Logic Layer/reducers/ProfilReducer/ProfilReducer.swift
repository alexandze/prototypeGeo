//
//  ProfilReducer.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func profilReducer(
        action: Action,
        state: ProfilState?
    ) -> ProfilState {
        let state = state ?? ProfilState(uuidState: UUID().uuidString)
        
        switch action {
        case let getProfilAction as ProfilAction.GetProfilAction:
            break
        default:
            return state
        }
        
    return state
    }
}
