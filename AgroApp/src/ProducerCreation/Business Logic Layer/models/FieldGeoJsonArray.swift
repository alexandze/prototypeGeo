//
//  FieldGeoJsonArray.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import MapKit

struct FieldGeoJsonArray: Codable {
    var features: [Feature]
}

struct Feature: Codable {
    var id: Int
    var geometry: Geometry
    var properties: CulturalPractice
}

struct Geometry: Codable {
    var type: String?
    var coordinates: [[[Double]]]?
    var coordinatesMulti: [[[[Double]]]]?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(String.self, forKey: .type)

        if type == "Polygon" {
            // TODO creer des MKPolygon
            coordinates = try? values.decode([[[Double]]].self, forKey: .coordinates)
        }

        if type == "MultiPolygon" {
            // TODO creer des MKPolygon
            coordinatesMulti = try? values.decode([[[[Double]]]].self, forKey: .coordinates)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case coordinates
    }
}

/*******   ********/

struct FieldGeoJsonArray1: Decodable {
    var features: [Feature1]
}

struct Feature1: Decodable {
    // TODO set le title et le subtitle de l'annotation, set le id field du payload, set le id field de Field
    var id: Int
    var geometry: Field1
    var properties: CulturalPractice
}

struct Geometry1: Codable {
    var type: String?
    var coordinates: [[[Double]]]?
    var coordinatesMulti: [[[[Double]]]]?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(String.self, forKey: .type)

        if type == "Polygon" {
            // TODO creer des MKPolygon
            coordinates = try? values.decode([[[Double]]].self, forKey: .coordinates)
        }

        if type == "MultiPolygon" {
            // TODO creer des MKPolygon
            coordinatesMulti = try? values.decode([[[[Double]]]].self, forKey: .coordinates)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case coordinates
    }
}

struct Field1: Decodable {
    static let POLYGON = "Polygon"
    static let MULTI_POLYGON = "MultiPolygon"
    var id: Int?
    var type: String?
    var culturalPratice: CulturalPractice?
    var polygon: [PolygonWithData<PayloadFieldAnnotation>]?
    var annotation: [AnnotationWithData<PayloadFieldAnnotation>]?

    // "geometry" in json file
    private enum CodingKeys: String, CodingKey {
        case type
        case coordinates
    }

    enum FieldCodableError: Error {
        case invalidLatLong
    }

    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.type = try? container.decode(String.self, forKey: .type)

            if let type = type, type == Field1.POLYGON {
                let tuplePolygonAnnotation = decodePolygon(container: container)
                self.polygon = getPolygonArrayFrom(tuple: tuplePolygonAnnotation)
                self.annotation = getAnnotationArrayFrom(tuple: tuplePolygonAnnotation)
            }

            if let type = type, type == Field1.MULTI_POLYGON {
                let tuplePolygonAnnotationArray = decodeMultiPolygon(container: container)
                self.polygon = getPolygonArrayFrom(tuplePolygonAnnotationArray: tuplePolygonAnnotationArray)
                self.annotation = getAnnotationArrayFrom(tuplePolygonAnnotationArray: tuplePolygonAnnotationArray)
            }

        } catch { }
    }

    private func getPolygonArrayFrom(
        tuple: TuplePolygonAnnotation?
    ) -> [PolygonWithData<PayloadFieldAnnotation>]? {
        guard let (polygon, _) = tuple else { return nil }
        return [polygon]
    }

    private func getPolygonArrayFrom(
        tuplePolygonAnnotationArray: [TuplePolygonAnnotation]?
    ) -> [PolygonWithData<PayloadFieldAnnotation>]? {
        guard let tuplePolygonAnnotationArray = tuplePolygonAnnotationArray else { return nil }

        return tuplePolygonAnnotationArray.map { tuplePolygonAnnotation in
            tuplePolygonAnnotation.0
        }
    }

    private func getAnnotationArrayFrom(
        tuplePolygonAnnotationArray: [TuplePolygonAnnotation]?
    ) -> [AnnotationWithData<PayloadFieldAnnotation>]? {
        guard let tuplePolygonAnnotationArray = tuplePolygonAnnotationArray else { return nil }

        return tuplePolygonAnnotationArray.map { tuplePolygonAnnotation in
            tuplePolygonAnnotation.1
        }
    }

    private func getAnnotationArrayFrom(
        tuple: TuplePolygonAnnotation?
    ) -> [AnnotationWithData<PayloadFieldAnnotation>]? {
        guard let (_, annotation) = tuple else { return nil }
        return [annotation]
    }

    private func decodeMultiPolygon(
        container: KeyedDecodingContainer<Field1.CodingKeys>
    ) -> [TuplePolygonAnnotation]? {
        guard let multiPolygon = decodeMultipolygonCoordinates(container: container) else { return nil }
        var tuplePolygonAnnotationArray = [TuplePolygonAnnotation]()

        (0..<multiPolygon.count).forEach { index1 in
            (0..<multiPolygon[index1].count).forEach { index2 in
                do {
                    guard let tuplePolygonAnnotation =
                        try createTuplePolygonAnnotation(coordinates: multiPolygon[index1][index2])
                        else { return }

                    tuplePolygonAnnotationArray.append(tuplePolygonAnnotation)
                } catch { }
            }
        }

        return !tuplePolygonAnnotationArray.isEmpty ? tuplePolygonAnnotationArray : nil
    }

    private func decodePolygon(
        container: KeyedDecodingContainer<Field1.CodingKeys>
    ) -> TuplePolygonAnnotation? {
        do {
            let coordinates = decodePolygonCoordinates(container: container)
            return try createTuplePolygonAnnotation(coordinates: coordinates)
        } catch {
            return nil
        }
    }

    private func createTuplePolygonAnnotation(
        coordinates: [[Double]]?
    ) throws -> TuplePolygonAnnotation? {
        let points = try createMkMapPoint(latLongArray: coordinates)
        let payload = createPayloadFieldAnnotation(idField: -1)
        let polygonWithData = createPolygonWithData(points: points, payload: payload)
        let centerPolygon = calculCenter(points: points)

        let annotationWithData = createAnnotationWithData(
            centerPolygon: centerPolygon,
            payload: payload
        )

        if let polygonWithData = polygonWithData,
            let annotationWithData = annotationWithData {
            return (polygonWithData, annotationWithData)
        }

        return nil
    }

    private func decodeMultipolygonCoordinates(
        container: KeyedDecodingContainer<Field1.CodingKeys>
    ) -> [[[[Double]]]]? {
        guard let coordinates = try? container.decode([[[[Double]]]].self, forKey: .coordinates),
            !coordinates.isEmpty else { return nil }

        return coordinates
    }

    private func decodePolygonCoordinates(
        container: KeyedDecodingContainer<Field1.CodingKeys>
    ) -> [[Double]]? {
        guard let coordinates = try? container.decode([[[Double]]].self, forKey: .coordinates),
            coordinates.count == 1 else { return nil }

        return coordinates[0]
    }

    private func createMkMapPoint(latLongArray: [[Double]]?) throws -> [MKMapPoint]? {
        guard let latLongArray = latLongArray else { return nil }

        return try latLongArray.map { latLong in
            guard latLong.count == 2 else { throw FieldCodableError.invalidLatLong }
            let coordinate = CLLocationCoordinate2D(latitude: latLong[1], longitude: latLong[0])
            return MKMapPoint(coordinate)
        }
    }

    private func createPayloadFieldAnnotation(idField: Int?) -> PayloadFieldAnnotation? {
        guard let id = idField else { return nil }
        return PayloadFieldAnnotation(idField: id)
    }

    private func createPolygonWithData(
        points: [MKMapPoint]?,
        payload: PayloadFieldAnnotation?
    ) -> PolygonWithData<PayloadFieldAnnotation>? {
        guard let points = points, let payload = payload else { return nil }
        let polygon = PolygonWithData<PayloadFieldAnnotation>(points: points, count: points.count)
        polygon.data = payload
        return polygon
    }

    private func createAnnotationWithData(
        centerPolygon: CLLocationCoordinate2D?,
        payload: PayloadFieldAnnotation?
    ) -> AnnotationWithData<PayloadFieldAnnotation>? {
        guard let centerPolygon = centerPolygon, let payload = payload else { return nil }
        return AnnotationWithData(location: centerPolygon, data: payload)
    }

    private func calculCenter(points: [MKMapPoint]?) -> CLLocationCoordinate2D? {
        let minLatitude = getMinLatitude(from: points)
        let maxLatitude = getMaxLatitude(from: points)
        let minLongitude = getMinLongitude(from: points)
        let maxLongitude = getMaxLongitude(from: points)

        if let minLatitude = minLatitude,
            let maxLatitude = maxLatitude,
            let minLongitude = minLongitude,
            let maxLongitude = maxLongitude {
            let centerLatitude = minLatitude + ((maxLatitude - minLatitude) / 2)
            let centerLongitude = minLongitude + ((maxLongitude - minLongitude) / 2)
            return CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        }

        return nil
    }

    private func getMaxLatitude(from mapPoints: [MKMapPoint]?) -> Double? {
        guard let mapPoints = mapPoints else { return nil }
        let max = mapPoints.max {$0.coordinate.latitude < $1.coordinate.latitude }
        return max?.coordinate.latitude
    }

    private func getMinLatitude(from mapPoints: [MKMapPoint]?) -> Double? {
        guard let mapPoints = mapPoints else { return nil }
        let min  = mapPoints.min {$0.coordinate.latitude < $1.coordinate.latitude }
        return min?.coordinate.latitude
    }

    private func getMinLongitude(from mapPoints: [MKMapPoint]?) -> Double? {
        guard let mapPoints = mapPoints else { return nil }
        let min  = mapPoints.min {$0.coordinate.longitude < $1.coordinate.longitude }
        return min?.coordinate.longitude
    }

    private func getMaxLongitude(from mapPoints: [MKMapPoint]?) -> Double? {
        guard let mapPoints = mapPoints else { return nil }
        let max = mapPoints.max { $0.coordinate.longitude < $1.coordinate.longitude }
        return max?.coordinate.longitude
    }

    private typealias TuplePolygonAnnotation = (PolygonWithData<PayloadFieldAnnotation>, AnnotationWithData<PayloadFieldAnnotation>)
}
