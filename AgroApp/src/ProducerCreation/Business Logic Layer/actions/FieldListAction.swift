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
        var field: FieldType
    }

    struct IsAppearAction: Action {
        var isAppear: Bool
    }
}
