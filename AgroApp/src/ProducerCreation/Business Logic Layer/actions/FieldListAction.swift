//
//  FieldListAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-17.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct FieldListAction {
    struct WillSelectFieldOnListAction: Action {
        var field: Field
    }

    struct IsAppearAction: Action {
        var isAppear: Bool
    }

    struct UpdateFieldAction: Action {
        let field: Field
    }

    struct RemoveFieldAction: Action {
        let indexPath: IndexPath
    }
}
