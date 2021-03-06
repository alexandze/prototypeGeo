//
//  LoginState.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-05.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct LoginState: Equatable {
    static func == (lhs: LoginState, rhs: LoginState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }
    
    var uuidState: String
    var elementUIDataListObservable: [ElementUIDataObservable]?
    var actionResponse: ActionResponse?
    
    func changeValues(
        elementUIDataListObservable: [ElementUIDataObservable]?,
        actionResponse: ActionResponse
    ) -> LoginState {
        LoginState(
            uuidState: UUID().uuidString,
            elementUIDataListObservable: elementUIDataListObservable ?? self.elementUIDataListObservable,
            actionResponse: actionResponse
        )
    }
    
    enum ActionResponse {
        case getElementUIDataListActionResponse
    }
}
