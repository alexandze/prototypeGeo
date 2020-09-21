//
//  ProducerListState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct ProducerListState: Equatable {
    static func == (lhs: ProducerListState, rhs: ProducerListState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var producerList: [Producer]?
    var isEmptyFarmers: Bool?
}
