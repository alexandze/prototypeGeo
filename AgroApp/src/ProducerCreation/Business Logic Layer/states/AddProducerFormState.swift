//
//  AddProducerFormState.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-06.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct AddProducerFormState: Equatable {

    static func == (lhs: AddProducerFormState, rhs: AddProducerFormState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var responseAction: ResponseAction?

    enum ResponseAction {
        case notResponse
    }
}
