//
//  LoginReducer.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-05.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func loginReducer(action: Action, state: LoginState?) -> LoginState {
        let state = state ?? LoginState(uuidState: UUID().uuidString)
        
        switch action {
        case let getElementUIDataListAction as LoginAction.GetElementUIDataListAction:
            return LoginHandler.HandlerGetLoginElementUIDataList().handle(action: getElementUIDataListAction, state)
        default:
            return state
        }
    }
}

class LoginHandler { }
