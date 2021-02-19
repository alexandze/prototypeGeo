//
//  HanderMiddleware.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-21.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift

protocol HanderMiddleware {
    associatedtype InputAction: Action
    associatedtype MyState
    
    func handle(_ action: InputAction, _ state: MyState) -> Action
}
