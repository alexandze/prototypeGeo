//
//  HandlerReducerProtocol.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

protocol HandlerReducerProtocol {
    associatedtype State
    associatedtype MyAction: Action

    func handle(action: MyAction, _ state: State) -> State
}
