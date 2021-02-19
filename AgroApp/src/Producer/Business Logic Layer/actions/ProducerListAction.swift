//
//  ProducerListAction.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-03.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct ProducerListAction {
    struct GetProducerListAction: Action { }
    
    struct GetProducerListSuccesAction: Action {
        let producerList: [Producer]
    }
    
    struct GetProducerListFailureAction: Action { }
    
    struct SaveNewProducerInDatabaseSuccessAction: Action {
        var producer: Producer
    }
    
    struct SaveNewProducerInDatabaseErrorAction: Action { }
}
