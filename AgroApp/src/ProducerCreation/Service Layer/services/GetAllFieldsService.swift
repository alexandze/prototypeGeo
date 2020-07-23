//
//  GetAllFields.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import MapKit
import RxSwift

extension MapFieldService {
    public func getFields() -> ([(Field<Polygon>, MKPolygon, AnnotationWithData<PayloadFieldAnnotation>)?], [(Field<MultiPolygon>, [(MKPolygon, AnnotationWithData<PayloadFieldAnnotation> )?])])? {
        let fieldsGeoJson = self.mapFieldRepository.getFieldGeoJsonArray()
        print(fieldsGeoJson?.features[0].properties)

        return fieldsGeoJson.map { (fieldsGeoJsonUnwrap: FieldGeoJsonArray) -> (
                [(Field<Polygon>, MKPolygon, AnnotationWithData<PayloadFieldAnnotation>)?],
                [(Field<MultiPolygon>, [(MKPolygon, AnnotationWithData<PayloadFieldAnnotation> )?])]) in
            let tupleFormatFieldJson = formatFieldsGeoJson(fieldsGeoJson: fieldsGeoJsonUnwrap)
            let fieldMKPolygonMKPointAnnotation = createMKPolygonMKPointAnnotationFor(fields: tupleFormatFieldJson.0)

            let fieldMKMultiPolygonMKPointAnnotation = createMKMultiPolygonMKPoinAnnotationFor(fields: tupleFormatFieldJson.1)
            return (fieldMKPolygonMKPointAnnotation, fieldMKMultiPolygonMKPointAnnotation)
        }
    }

    private func cleanFieldMKPolygonMKPointAnnotationList(fieldMKPolygonMKPointAnnotation: [(Field<Polygon>, MKPolygon, AnnotationWithData<PayloadFieldAnnotation>)?]) -> [(Field<Polygon>, MKPolygon, AnnotationWithData<PayloadFieldAnnotation>)] {
        let arrayTupleWithoutNilValue =  fieldMKPolygonMKPointAnnotation.filter { $0 != nil }
        return arrayTupleWithoutNilValue.map { $0! }
    }

    private func formatFieldsGeoJson(fieldsGeoJson: FieldGeoJsonArray) -> ([Field<Polygon>], [Field<MultiPolygon>]) {
        let fieldPolygon = formatFieldsGeoJsonToFieldPolygon(fieldsGeoJson: fieldsGeoJson)
        let fieldMultiPolygon = formatFieldsGeoJsonToFieldMultiPolygon(fieldsGeoJson: fieldsGeoJson)
        return (fieldPolygon, fieldMultiPolygon)
    }

    private func formatFieldsGeoJsonToFieldPolygon(fieldsGeoJson: FieldGeoJsonArray) -> [Field<Polygon>] {
        let fieldsPolygone = filterPolygon(fieldsGeoJson: fieldsGeoJson)

        return fieldsPolygone.features.map {(feature: Feature) -> Field<Polygon> in
            let type = feature.geometry.type!
            let id = feature.id
            let coordinates = feature.geometry.coordinates![0]
            let polygon = Polygon(value: coordinates)
            return Field(id: id, name: "", type: type, culturalPratice: nil, coordinates: polygon)
        }
    }

    private func formatFieldsGeoJsonToFieldMultiPolygon(fieldsGeoJson: FieldGeoJsonArray) -> [Field<MultiPolygon>] {
        let fieldMultiPolygons = filterMultiPolygon(fieldsGeoJson: fieldsGeoJson)

        return fieldMultiPolygons.features.map { (feature: Feature) -> Field<MultiPolygon> in
            let type = feature.geometry.type!
            let id = feature.id
            let coordinates = feature.geometry.coordinatesMulti![0]
            let multiPolyon = MultiPolygon(value: coordinates)
            return Field(id: id, name: "", type: type, culturalPratice: nil, coordinates: multiPolyon)
        }
    }

    private func filterPolygon(fieldsGeoJson: FieldGeoJsonArray) -> FieldGeoJsonArray {
        FieldGeoJsonArray(features: fieldsGeoJson.features.filter { $0.geometry.type == "Polygon" })
    }

    private func filterMultiPolygon(fieldsGeoJson: FieldGeoJsonArray) -> FieldGeoJsonArray {
        FieldGeoJsonArray(features: fieldsGeoJson.features.filter { $0.geometry.type == "MultiPolygon" })
    }

    private func calculCenterPolygon(from mapPoint: [MKMapPoint]) -> CLLocationCoordinate2D? {
        let minLatitude = getMinLatitude(from: mapPoint)
        let maxLatitude = getMaxLatitude(from: mapPoint)
        let minLongitude = getMinLongitude(from: mapPoint)
        let maxLongitude = getMaxLongitude(from: mapPoint)

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

    private func getMaxLatitude(from mapPoint: [MKMapPoint]) -> Double? {
        let max = mapPoint.max {$0.coordinate.latitude < $1.coordinate.latitude }
        return max?.coordinate.latitude
    }

    private func getMinLatitude(from mapPoint: [MKMapPoint]) -> Double? {
        let min  = mapPoint.min {$0.coordinate.latitude < $1.coordinate.latitude }
        return min?.coordinate.latitude
    }

    private func getMinLongitude(from mapPoint: [MKMapPoint]) -> Double? {
        let min  = mapPoint.min {$0.coordinate.longitude < $1.coordinate.longitude }
        return min?.coordinate.longitude
    }

    private func getMaxLongitude(from mapPoint: [MKMapPoint]) -> Double? {
        let max = mapPoint.max {$0.coordinate.longitude < $1.coordinate.longitude }
        return max?.coordinate.longitude
    }

    //////////////
    private func createMKPolygonMKPointAnnotationFor(fields: [Field<Polygon>]) -> [(Field<Polygon>, MKPolygon, AnnotationWithData<PayloadFieldAnnotation>)?] {
        fields.map { createFieldWithMKPolygon(field: $0) }
    }

    private func createMKMultiPolygonMKPoinAnnotationFor(fields: [Field<MultiPolygon>]) -> [(Field<MultiPolygon>, [(MKPolygon, AnnotationWithData<PayloadFieldAnnotation> )?])] {
        fields.map { createFieldWithMKMultiPolygon(field: $0) }
    }

    private func createMapPoints(from polygonType: PolygonType) -> [MKMapPoint] {
        polygonType.map { MKMapPoint(CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])) }
    }

    private func createPolygon(from mapPoint: [MKMapPoint]) -> MKPolygon {
        PolygonWithData<PayloadFieldAnnotation>(points: mapPoint, count: mapPoint.count)
    }

    private func createFieldWithMKPolygon(field: Field<Polygon>) -> (Field<Polygon>, MKPolygon, AnnotationWithData<PayloadFieldAnnotation>)? {
        let payload = PayloadFieldAnnotation(idField: field.id)
        let mapPoint = createMapPoints(from: field.coordinates.value)
        let mkPolygon = createPolygon(from: mapPoint) as? PolygonWithData<PayloadFieldAnnotation>
        mkPolygon!.data = payload
        let centerLocationCoordinate2D = calculCenterPolygon(from: mapPoint)

        return centerLocationCoordinate2D.map { (location: CLLocationCoordinate2D) -> (Field<Polygon>, MKPolygon, AnnotationWithData<PayloadFieldAnnotation>) in
            let mkPointannotation = createAnnotationWithData(
                locationCoordinate2D: location,
                title: " \(field.id)",
                subtitle: "\(NSLocalizedString("Parcelle avec le id", comment: "Parcelle avec le id")) \(field.id)",
                payloadFieldAnnotation: payload
            )

            return (field, mkPolygon!, mkPointannotation)
        }
    }

    private func createFieldWithMKMultiPolygon(field: Field<MultiPolygon>) -> (Field<MultiPolygon>, [(MKPolygon, AnnotationWithData<PayloadFieldAnnotation>)?]) {
        let payload = PayloadFieldAnnotation(idField: field.id)

        let mkPolygonsAndMkPointAnnotation = field.coordinates.value.map {(polygonType: PolygonType) -> (MKPolygon, AnnotationWithData<PayloadFieldAnnotation>)? in
            let mapPoint = createMapPoints(from: polygonType)
            let mkPolygon = createPolygon(from: mapPoint) as? PolygonWithData<PayloadFieldAnnotation>
            mkPolygon!.data = payload
            let centerLocationCoordinate2D = calculCenterPolygon(from: mapPoint)

            return centerLocationCoordinate2D.map {(location: CLLocationCoordinate2D) -> (MKPolygon, AnnotationWithData<PayloadFieldAnnotation>) in
                let mkPointannotation = createAnnotationWithData(
                    locationCoordinate2D: location,
                    title: " \(field.id)",
                    subtitle: "\(NSLocalizedString("Parcelle avec le id", comment: "Parcelle avec le id")) \(field.id)",
                    payloadFieldAnnotation: payload
                )

                return (mkPolygon!, mkPointannotation)
            }
        }

        return (field, mkPolygonsAndMkPointAnnotation)
    }

    private func createAnnotationWithData(
        locationCoordinate2D: CLLocationCoordinate2D,
        title: String?,
        subtitle: String?,
        payloadFieldAnnotation: PayloadFieldAnnotation
    ) -> AnnotationWithData<PayloadFieldAnnotation> {
        let locationCoordianate = locationCoordinate2D
        let annotationWithData = AnnotationWithData(location: locationCoordianate, data: payloadFieldAnnotation)
        annotationWithData.coordinate = locationCoordianate
        annotationWithData.title = title
        annotationWithData.subtitle = subtitle
        return annotationWithData
    }
}

// filtrer les polygon dans le geojson    // filtrer les multipolygon dans le geojson
// transformer les polygon fieldPolygon   // transformer les multipolygon en fieldMultipolygon
// creer des mkPolygon avec le payload a partir de fieldPolygon   // creer plusieur mkPolygon avec payload
// Calculer le centre du polygon
// creer l'annotation avec son payload

/*
class MyService {
    
    func getGeoDataForMapKit() {
        getFieldGeoJsonArrayObs()
            .flatMap {self.createFeatureStreamFrom(fieldGeoJson: $0) }
            .skipWhile { self.isFeatureHasNilCoordinates(feature: $0) }
            
            .flatMap { self.createMKMapPointWrapper(feature: $0) }
            
            
    }
    
    func getFieldGeoJsonArrayObs() -> Observable<FieldGeoJsonArray> {
        let fieldGeoJson = MapFieldRepository.shared.getFieldGeoJsonArray()
        
        if let fieldGeoJson = fieldGeoJson {
            return Observable.just(fieldGeoJson)
        }
        
        return Observable.error(GeoDataForMapkitError.getFieldGeoJson)
    }
    
    func isFeatureHasNilCoordinates(feature: Feature) -> Bool {
        feature.geometry.coordinates == nil || feature.geometry.coordinates!.count == 0
    }
    
    func createFeatureStreamFrom(fieldGeoJson: FieldGeoJsonArray) -> Observable<Feature> {
        Observable.from(fieldGeoJson.features)
    }
    
    func createMKMapPointWrapper(feature: Feature) -> Single<TupleMKMapPointArrayFeature> {
        Single.create { observer in
            let mkMapPointArray = self.createMKMapPoint(feature.geometry.coordinates![0])
            let tuple = (mkMapPointArray, feature)
            observer(.success(tuple))
            return Disposables.create()
        }
    }
    
    func createMKMapPoint(_ coordinatePolygon: CoordinatePolygon) -> [MKMapPoint] {
        coordinatePolygon.map { (longitudeLatitude: [Double]) -> MKMapPoint in
            MKMapPoint(
                CLLocationCoordinate2D(
                    latitude: longitudeLatitude[1],
                    longitude: longitudeLatitude[0]
                )
            )
        }
    }
    
    func calculCenterOfMKMapPointsWrapper(tupleMKMapPointArrayFeature: TupleMKMapPointArrayFeature) {
        
    }
    
    
    
    func calculCenterOfMKMapPoints(_ mkMapPoints: [MKMapPoint]) -> CLLocationCoordinate2D {
        let minLatitude = getMinLatitude(from: mkMapPoints)
        let maxLatitude = getMaxLatitude(from: mkMapPoints)
        let minLongitude = getMinLongitude(from: mkMapPoints)
        let maxLongitude = getMaxLongitude(from: mkMapPoints)
        let centerLatitude = minLatitude + ((maxLatitude - minLatitude) / 2)
        let centerLongitude = minLongitude + ((maxLongitude - minLongitude) / 2)
        return CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
    }
    
    
    
    
    func createGeoDataPolygon(feature: Feature) -> Observable<GeoDataPolygon> {
        let id = feature.id
        let polygonCoordinate = feature.geometry.coordinates![0]
        
        
    }
    
    private func getMaxLatitude(from mkMapPoint: [MKMapPoint]) -> Double {
        let max = mkMapPoint.max {$0.coordinate.latitude < $1.coordinate.latitude }
        return max!.coordinate.latitude
    }
    
    private func getMinLatitude(from mkMapPoint: [MKMapPoint]) -> Double {
        let min  = mkMapPoint.min {$0.coordinate.latitude < $1.coordinate.latitude }
        return min!.coordinate.latitude
    }
    
    private func getMinLongitude(from mkMapPoint: [MKMapPoint]) -> Double {
        let min  = mkMapPoint.min {$0.coordinate.longitude < $1.coordinate.longitude }
        return min!.coordinate.longitude
    }
    
    private func getMaxLongitude(from mkMapPoint: [MKMapPoint]) -> Double {
        let max = mkMapPoint.max {$0.coordinate.longitude < $1.coordinate.longitude }
        return max!.coordinate.longitude
    }
}

struct GeoDataForMapkit {
    var mkPolygon: [MKPolygon]?
    var fieldPolygon: [Field<Polygon>]?
}

struct GeoDataPolygon {
    var id: Int?
    var polygonWithData: PolygonWithData<PayloadFieldAnnotation>?
}

enum GeoDataForMapkitError: Error {
    case getFieldGeoJson
}

typealias TuplePolygon = (Field<Polygon>, MKPolygon)
typealias TupleMultiPolygon = (Field<MultiPolygon>, [MKPolygon])
typealias TuplePolygonAndMultipolygon = (TuplePolygon, TupleMultiPolygon)
typealias PolygonArray = [[Double]]
typealias TupleMKMapPointArrayFeature = ([MKMapPoint], Feature)
typealias TupleMKMapPointArrayFeatureCenterPolygon = ([MKMapPoint], Feature, CLLocationCoordinate2D)
typealias CoordinatePolygon = [[Double]]
*/
