//
//  Field.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct Field<T: GeometryShape> {
    var id: Int
    var name: String
    var type: String
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
