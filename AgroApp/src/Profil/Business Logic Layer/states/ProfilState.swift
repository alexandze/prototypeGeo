//
//  ProfilState.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct ProfilState: Equatable {
    static func == (lhs: ProfilState, rhs: ProfilState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }
    
    var uuidState: String
    var name: String?
    var actionResponse: ActionResponse?
    
    enum ActionResponse {
        case notResponse
    }
}
