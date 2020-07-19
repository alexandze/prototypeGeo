//
//  Field.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

indirect enum FieldType {
    case polygon(Field<Polygon>)
    case multiPolygon(Field<MultiPolygon>)

    func getId() -> Int {
        switch self {
        case .multiPolygon(let multiPolygon):
            return multiPolygon.id
        case .polygon(let polygon):
            return polygon.id
        }
    }

    func getCulturalPractice() -> CulturalPractice? {
        switch self {
        case .multiPolygon(let multipolygon):
            return multipolygon.culturalPratice
        case .polygon(let polygon):
            return polygon.culturalPratice
        }
    }

    func changeValue(culturalPractice: CulturalPractice) -> FieldType {
        switch self {
        case .multiPolygon(var multipolygon):
            multipolygon.culturalPratice = culturalPractice
            return .multiPolygon(multipolygon)
        case .polygon(var polygon):
            polygon.culturalPratice = culturalPractice
            return .polygon(polygon)
        }
    }
}

struct Field<T: GeometryShape> {
    var id: Int
    var name: String
    var type: String
    var culturalPratice: CulturalPractice?
    var coordinates: T
}

typealias PolygonType = [PointType]
typealias MultiPolygonType = [PolygonType]
typealias PointType = [Double]

protocol GeometryShape { }

struct Polygon: GeometryShape {
    var value: PolygonType
}

struct MultiPolygon: GeometryShape {
    var value: MultiPolygonType
}
