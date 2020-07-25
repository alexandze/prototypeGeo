//
//  MapField.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class MapFieldService {
    public func getFields() -> [Int: Field]? {
        MapFieldRepository().getFieldGeoJsonArray()
    }
}
