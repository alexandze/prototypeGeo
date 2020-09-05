//
//  LoginInteraction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-05.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class LoginInteractionImpl: LoginInteraction {
    private let actionDispatcher: ActionDispatcher

    init(actionDispatcher: ActionDispatcher) {
        self.actionDispatcher = actionDispatcher
    }
    
}

protocol LoginInteraction {
    
}
