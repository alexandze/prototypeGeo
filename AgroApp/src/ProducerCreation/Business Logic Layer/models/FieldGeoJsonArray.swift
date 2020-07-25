//
//  FieldCulturalPracticeDecodable.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import MapKit

struct FieldCulturalPracticeDecodable: Decodable {
    var fieldWrappers: [FieldDecodableWrapper]

    private enum CodingKeys: String, CodingKey {
        case fieldWrappers = "features"
    }

    func getFieldDictionnary() -> [Int: Field] {
        fieldWrappers
            .map(mapFieldWrapperToFieldDecodable(fieldWrapper:))
            .filter(filterValidFieldDecodable(fieldDecodable:))
            .map(mapFieldDecodableToField(fieldDecodable:))
            .reduce([Int:Field](), reduceToFieldDictionnary(fieldDictionnary:field:))
    }

    private func mapFieldWrapperToFieldDecodable(fieldWrapper: FieldDecodableWrapper) -> FieldDecodable? {
        fieldWrapper.fieldDecodable
    }

    private func filterValidFieldDecodable(fieldDecodable: FieldDecodable?) -> Bool {
        if fieldDecodable?.polygon == nil {
            print(fieldDecodable?.id)
        }
        return fieldDecodable?.id != nil &&
            fieldDecodable?.type != nil &&
            fieldDecodable?.culturalPratice != nil &&
            fieldDecodable?.polygon?.isEmpty != nil &&
            !fieldDecodable!.polygon!.isEmpty &&
            fieldDecodable?.annotation?.isEmpty != nil &&
            !fieldDecodable!.annotation!.isEmpty
    }

    private func mapFieldDecodableToField(fieldDecodable: FieldDecodable?) -> Field {
        Field(
            id: fieldDecodable!.id!,
            type: fieldDecodable!.type!,
            culturalPratice: fieldDecodable?.culturalPratice,
            polygon: fieldDecodable!.polygon!,
            annotation: fieldDecodable!.annotation!
        )
    }

    private func reduceToFieldDictionnary(fieldDictionnary: [Int: Field], field: Field) -> [Int: Field] {
        var copyFieldDictionnary = fieldDictionnary
        copyFieldDictionnary[field.id] = field
        return copyFieldDictionnary
    }
}

struct FieldDecodableWrapper: Decodable {
    var fieldDecodable: FieldDecodable?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try? container.decode(Int.self, forKey: .id)
        var culturalPractice = try? container.decode(CulturalPractice.self, forKey: .properties)
        var field = try? container.decode(FieldDecodable.self, forKey: .geometry)

        if let id = id {
            culturalPractice?.id = id
            field?.id = id
            field?.culturalPratice = culturalPractice
            setTitleAndSubtitleOf(annotationsWithData: field?.annotation, with: id)
            setPayloadOf(annotationsWithData: field?.annotation, id: id)
            self.fieldDecodable = field
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case geometry
        case properties
    }

    func setTitleAndSubtitleOf(
        annotationsWithData: [AnnotationWithData<PayloadFieldAnnotation>?]?,
        with id: Int?
    ) {
        guard let annotationsWithData = annotationsWithData, let id = id else { return }

        return annotationsWithData.forEach { (annotationWithData: AnnotationWithData<PayloadFieldAnnotation>?) in
            annotationWithData?.title = "\(id)"

            annotationWithData?.subtitle =
            "\(NSLocalizedString("Parcelle avec le id", comment: "Parcelle avec le id")) \(id)"
        }
    }

    func setPayloadOf(annotationsWithData: [AnnotationWithData<PayloadFieldAnnotation>?]?, id: Int?) {
        guard let annotationsWithData = annotationsWithData, let id = id else { return }

        annotationsWithData.forEach { (annotation: AnnotationWithData<PayloadFieldAnnotation>?) -> Void in
            annotation?.data?.idField = id
        }
    }
}

struct FieldDecodable: Decodable {
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

            if let type = type, type == FieldDecodable.POLYGON {
                let tuplePolygonAnnotationArray = decodePolygon(container: container)
                self.polygon = getPolygonArrayFrom(tuplePolygonAnnotationArray: tuplePolygonAnnotationArray)
                self.annotation = getAnnotationArrayFrom(tuplePolygonAnnotationArray: tuplePolygonAnnotationArray)
            }

            if let type = type, type == FieldDecodable.MULTI_POLYGON {
                let tuplePolygonAnnotationArray = decodeMultiPolygon(container: container)
                self.polygon = getPolygonArrayFrom(tuplePolygonAnnotationArray: tuplePolygonAnnotationArray)
                self.annotation = getAnnotationArrayFrom(tuplePolygonAnnotationArray: tuplePolygonAnnotationArray)
            }

        } catch { }
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

    private func decodeMultiPolygon(
        container: KeyedDecodingContainer<FieldDecodable.CodingKeys>
    ) -> [TuplePolygonAnnotation]? {
        guard let multiPolygon = decodeMultipolygonCoordinates(container: container) else { return nil }
        var tuplePolygonAnnotationArray = [TuplePolygonAnnotation]()

        (0..<multiPolygon.count).forEach { index1 in
            (0..<multiPolygon[index1].count).forEach { index2 in
                do {
                    guard let tuplePolygonAnnotation =
                        try createTuplePolygonAnnotation(coordinate: multiPolygon[index1][index2])
                        else { return }

                    tuplePolygonAnnotationArray.append(tuplePolygonAnnotation)
                } catch { }
            }
        }

        return !tuplePolygonAnnotationArray.isEmpty ? tuplePolygonAnnotationArray : nil
    }

    private func decodePolygon(
        container: KeyedDecodingContainer<FieldDecodable.CodingKeys>
    ) -> [TuplePolygonAnnotation]? {
        do {
            let coordinates = decodePolygonCoordinates(container: container)
            var tuplePolygonAnnotations = [TuplePolygonAnnotation]()

            try coordinates?.forEach({ (coordinate: [[Double]]) in
                guard let tuplePolygonAnnotation = try createTuplePolygonAnnotation(coordinate: coordinate) else { return }
                tuplePolygonAnnotations.append(tuplePolygonAnnotation)
            })

            return tuplePolygonAnnotations
        } catch {
            return nil
        }
    }

    private func createTuplePolygonAnnotation(
        coordinate: [[Double]]?
    ) throws -> TuplePolygonAnnotation? {
        let points = try createMkMapPoint(latLongArray: coordinate)
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
        container: KeyedDecodingContainer<FieldDecodable.CodingKeys>
    ) -> [[[[Double]]]]? {
        guard let coordinates = try? container.decode([[[[Double]]]].self, forKey: .coordinates),
            !coordinates.isEmpty else { return nil }

        return coordinates
    }

    private func decodePolygonCoordinates(
        container: KeyedDecodingContainer<FieldDecodable.CodingKeys>
    ) -> [[[Double]]]? {
        guard let coordinates = try? container.decode([[[Double]]].self, forKey: .coordinates)
            else { return nil }
        return coordinates
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
