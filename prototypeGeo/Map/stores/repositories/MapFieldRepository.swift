//
//  MapFieldRepository.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class MapFieldRepository {
    static let shared = MapFieldRepository()

    public func getFieldGeoJsonArray() -> FieldGeoJsonArray? {
        UtilReaderFile.readJsonFile(resource: "ACTU", typeRessource: "json", FieldGeoJsonArray.self)
    }

}
