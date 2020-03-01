//
//  MapFieldState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct MapState {
    var mapFieldAllFieldsState: MapFieldState = MapFieldState(uuidState: "", fieldPolygonAnnotation: [], fieldMultiPolygonAnnotation: [])
    var fieldListState: FieldListState = FieldListState(uuidState: "", fieldList: nil, currentField: nil)
    var culturalPracticeState: CulturalPracticeState = CulturalPracticeState(uuidState: "", currentField: nil)
    
}
