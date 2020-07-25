//
//  MapFieldRepository.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class MapFieldRepository {

    public func getFieldGeoJsonArray() -> [Int: Field]? {
        UtilReaderFile.readJsonFile(resource: "PRATIQUES_2018_LATLONG", typeRessource: "json", FieldCulturalPracticeDecodable.self)?.getFieldDictionnary()
    }

    enum MapFieldRepositoryError: Error {
        case getFieldError
    }
}
