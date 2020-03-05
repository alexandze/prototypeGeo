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
    var fieldListState: FieldListState = FieldListState(uuidState: "", fieldList: [], currentField: nil, isForRemove: false, indexForRemove: -1)
    var culturalPracticeState: CulturalPracticeState = CulturalPracticeState(uuidState: "", currentField: nil)
    
}
