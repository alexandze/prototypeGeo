//
//  AddProducerFormAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-06.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct AddProducerFormAction {
    struct GetAllElementUIDataWithoutValueAction: Action { }

    struct CheckIfInputElemenIsValidAction: Action {
        var id: UUID
        var value: String
    }

    struct CheckIfAllInputElementIsValidAction: Action { }

    struct AddNimInputElementAction: Action {}
}
