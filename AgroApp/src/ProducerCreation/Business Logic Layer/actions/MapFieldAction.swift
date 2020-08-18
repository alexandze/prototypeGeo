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
    struct GetAllFieldAction: Action {}

    struct GetAllFieldSuccessAction: Action {
        var fieldDictionnary: [Int: Field]
    }

    struct GetAllFieldErrorAction: Action {
        var error: Error
    }

    struct WillSelectedFieldOnMapAction: Action {
        let field: Field
    }

    struct WillDeselectFieldOnMapAction: Action {
        let field: Field
    }
}
