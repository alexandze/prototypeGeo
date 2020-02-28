//
//  StoreSubcriberProxy.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift

class StoreSubscriberProxy<StateType>: StoreSubscriber {
    
    typealias StoreSubscriberStateType = StateType
    let rxObserver: AnyObserver<StateType>
    
    init(rxObserver: AnyObserver<StateType>) {
        self.rxObserver = rxObserver
    }
    
    func newState(state: StateType) {
        rxObserver.on(.next(state))
    }
}

