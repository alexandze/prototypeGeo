//
//  FieldGeoJsonArray.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct FieldGeoJsonArray: Codable {
    var features: [Feature]
}

struct Feature: Codable {
    var id: Int
    var geometry: Geometry
}

struct Geometry: Codable {
    var type: String?
    var coordinates: [[[Double]]]?
    var coordinatesMulti: [[[[Double]]]]?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(String.self, forKey: .type)
        
        if type == "Polygon" {
            coordinates = try? values.decode([[[Double]]].self, forKey: .coordinates)
        }
        
        if type == "MultiPolygon" {
            coordinatesMulti = try values.decode([[[[Double]]]].self, forKey: .coordinates)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case coordinates
    }

}

