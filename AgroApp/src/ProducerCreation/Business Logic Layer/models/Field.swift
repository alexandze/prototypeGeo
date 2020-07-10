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
