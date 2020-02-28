//
//  MapFieldAllFieldsState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import MapKit

struct MapFieldAllFieldsState: Equatable {
    static func == (lhs: MapFieldAllFieldsState, rhs: MapFieldAllFieldsState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }
    
    var uuidState: String
    var fieldPolygonAnnotation: [(Field<Polygon>, MKPolygon, MKPointAnnotation)?]
    var fieldMultiPolygonAnnotation: [(Field<MultiPolygon>, [(MKPolygon, MKPointAnnotation)?])]
}
