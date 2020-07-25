//
//  MapFieldAllFieldsState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import MapKit

struct MapFieldState: Equatable {
    static func == (lhs: MapFieldState, rhs: MapFieldState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var fieldDictionnary: [Int: Field] = [Int: Field]()
}
