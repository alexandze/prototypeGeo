//
//  MapFieldAction.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct MapFieldAction {
    struct GetAllField: Action {}

    struct GetAllFieldSuccess: Action {
        var mapFieldAllFieldState: MapFieldState
    }

    struct SelectedFieldOnMapAction: Action {
        let fieldType: FieldType
    }

    struct DeselectedFieldOnMapAction: Action {
        let fieldType: FieldType
    }
    
    struct SelectedFieldOnListAction: Action {
        let fieldType: FieldType
    }
}
