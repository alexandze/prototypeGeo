//
//  MapFieldViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift
import MapKit

class MapFieldViewModel {
    let mapFieldAllFieldStateObs: Observable<MapFieldState>
    let mapFieldInteraction: MapFieldInteraction
    var disposableMapFieldAllState: Disposable?
    var mapView: MKMapView!
    var fieldsPolygonsAnnotations: [(Field<Polygon>, MKPolygon, AnnotationWithData<PayloadFieldAnnotation>)?]?
    var fieldsMuliPolygonsAnnotations: [
        (Field<MultiPolygon>, [(MKPolygon, AnnotationWithData<PayloadFieldAnnotation>)?])
    ]?

    let idClusterAnnotation = "idCLusterAnnotation"
    let idAnnotationView = "My annotation view"
    var currentSelectedAnnotation: AnnotationWithData<PayloadFieldAnnotation>?
    let disposeBag = DisposeBag()

    init(
        mapFieldAllFieldStateObs: Observable<MapFieldState>,
        mapFieldInteraction: MapFieldInteraction
    ) {
        self.mapFieldAllFieldStateObs = mapFieldAllFieldStateObs
        self.mapFieldInteraction = mapFieldInteraction
    }

    func initRegion() {
        let location2D = CLLocationCoordinate2DMake(45.233023116000027, -73.355880542999955)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        let region = MKCoordinateRegion(center: location2D, span: coordinateSpan)
        self.mapView.region = mapView.regionThatFits(region)
    }

    func handle(mkAnnotation: MKAnnotation) -> MKAnnotationView? {
        if mkAnnotation is AnnotationWithData<PayloadFieldAnnotation> {
            let markerAnnotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier:
                self.idAnnotationView,
                for: mkAnnotation
                ) as? MKMarkerAnnotationView
            config(markerAnnotationView: markerAnnotationView!)
            configRightCalloutAccessoryView(
                with: mkAnnotation,
                and: markerAnnotationView!
            )
            return markerAnnotationView
        }

        if mkAnnotation is MKClusterAnnotation {

        }

        return nil
    }

    func handle(overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? PolygonWithData<PayloadFieldAnnotation> {
            let polygonRenderer = MKPolygonRenderer(polygon: overlay)

            if overlay.data!.isSelected {
                configSelected(polygonRenderer: polygonRenderer)
                return polygonRenderer
            }

            configNotSelected(polygonRenderer: polygonRenderer)
            return polygonRenderer
        }

        return MKOverlayRenderer()
    }

    func registerAnnotationView() {
        self.mapView.register(
            MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: self.idAnnotationView
        )
    }

    func dispatchGetAllFields() {
        mapFieldInteraction.getAllField()
    }

    func initTitleNavigation(of viewController: UIViewController) {
        viewController.navigationItem.title = "Carte"
    }

    func configTabBarItem(of viewController: UIViewController) {
        let barIttem = UITabBarItem(title: "Carte", image: nil, tag: 25)
        barIttem.title = "Carte"
       // viewController.title = "Carte"
        viewController.tabBarItem = barIttem
    }

    func subscribeToTableViewControllerState() {
        self.disposableMapFieldAllState = self.mapFieldAllFieldStateObs
       //.subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {state  in
                self.proccessInitMap(
                with: state.fieldPolygonAnnotation,
                and: state.fieldMultiPolygonAnnotation
            )
        })
    }

    func disposeToTableViewControllerState() {
        self.disposableMapFieldAllState?.dispose()
    }

    public func handleAnnotationViewSelected(annotationView: MKAnnotationView) {
        if let selectedFieldRightCalloutView =
            (annotationView as? MKMarkerAnnotationView)?.rightCalloutAccessoryView as? SelectedFieldCalloutView,
            let annotationWithData = annotationView.annotation as? AnnotationWithData<PayloadFieldAnnotation>,
            let dataFromAnnotationView = annotationWithData.data {
            self.currentSelectedAnnotation = annotationWithData
            selectedFieldRightCalloutView.setStateButton(with: dataFromAnnotationView.isSelected)
        }
    }

    private func proccessInitMap(
        with fieldPolygonAnnotation: [(Field<Polygon>, MKPolygon, AnnotationWithData<PayloadFieldAnnotation>)?],
        and fieldMultiPolygonAnnotation: [
            (Field<MultiPolygon>, [(MKPolygon, AnnotationWithData<PayloadFieldAnnotation>)?])
        ]
    ) {
        self.fieldsPolygonsAnnotations = fieldPolygonAnnotation
        self.fieldsMuliPolygonsAnnotations = fieldMultiPolygonAnnotation

        fieldPolygonAnnotation.forEach { fieldPolygonAnnotationTuple in
            add(mkPointAnnotation: fieldPolygonAnnotationTuple?.2, in: self.mapView)
            add(mkPolygon: fieldPolygonAnnotationTuple?.1, in: self.mapView)
        }

        fieldMultiPolygonAnnotation.forEach { fieldMultiPolygonAnnotationTuple in
            fieldMultiPolygonAnnotationTuple.1.forEach { tuplePolygonAnnotation in
                self.add(mkPointAnnotation: tuplePolygonAnnotation?.1, in: self.mapView)
                self.add(mkPolygon: tuplePolygonAnnotation?.0, in: self.mapView)
            }
        }
    }

    private func add(
        mkPointAnnotation: AnnotationWithData<PayloadFieldAnnotation>?,
        in mapView: MKMapView
    ) {
        mkPointAnnotation.map {mapView.addAnnotation($0)}
    }

    private func add(mkPolygon: MKPolygon?, in mapView: MKMapView) {
        mkPolygon.map { mapView.addOverlay($0) }
    }

    private func config(markerAnnotationView: MKMarkerAnnotationView) {
        markerAnnotationView.titleVisibility = .adaptive
        markerAnnotationView.subtitleVisibility = .adaptive
        markerAnnotationView.markerTintColor = .black
        markerAnnotationView.clusteringIdentifier = self.idClusterAnnotation
        markerAnnotationView.displayPriority = .defaultHigh
        markerAnnotationView.canShowCallout = true
    }

    private func configRightCalloutAccessoryView(
        with mkAnnotation: MKAnnotation,
        and markerAnnotationView: MKMarkerAnnotationView
    ) {
        guard let annotationWithData =
            mkAnnotation as? AnnotationWithData<PayloadFieldAnnotation> else { return }
        guard let dataFromAnnotation = annotationWithData.data else { return }

        if markerAnnotationView.rightCalloutAccessoryView == nil {
            let rightCalloutAccessoryView = SelectedFieldCalloutView()
            rightCalloutAccessoryView.addTargetButtonAdd(handleAddFunc: handleAdd(button:))
            rightCalloutAccessoryView.addTargetButtonCancel(handleCancelFunc: handleCancel(button:))
            rightCalloutAccessoryView.setStateButton(with: dataFromAnnotation.isSelected)
            return markerAnnotationView.rightCalloutAccessoryView = rightCalloutAccessoryView
        }

        if let rightCalloutAccessoryView =
            markerAnnotationView.rightCalloutAccessoryView as? SelectedFieldCalloutView {
            return rightCalloutAccessoryView.setStateButton(with: dataFromAnnotation.isSelected)
        }
    }

    private func handleAdd(button: UIButton) {
        guard let dataFromAnnotation = currentSelectedAnnotation?.data else { return }
        guard let selectedFieldCalloutView = button.superview as? SelectedFieldCalloutView else { return }

        dataFromAnnotation.isSelected = true
        selectedFieldCalloutView.setStateButton(with: true)
        findFieldById(idField: dataFromAnnotation.idField)
            .do(
                onNext: { self.dispatchAddFieldToListView(field: $0.0, mapFieldInteraction: self.mapFieldInteraction) }
        )
            .observeOn(MainScheduler.instance)
            .take(1)
            .subscribe {
                if let polygonRenderer = $0.element?.3 as? MKPolygonRenderer {
                    self.configSelected(polygonRenderer: polygonRenderer)
                }
        }.disposed(by: self.disposeBag)
    }

    private func configSelected(polygonRenderer: MKPolygonRenderer) {
        polygonRenderer.fillColor = UIColor.green.withAlphaComponent(0.3)
        polygonRenderer.strokeColor = UIColor.yellow.withAlphaComponent(0.8)
        polygonRenderer.lineWidth = 2
    }

    private func configNotSelected(polygonRenderer: MKPolygonRenderer) {
        polygonRenderer.fillColor = UIColor.red.withAlphaComponent(0.1)
        polygonRenderer.strokeColor = UIColor.yellow.withAlphaComponent(0.8)
        polygonRenderer.lineWidth = 2
    }

    private func handleCancel(button: UIButton) {
        guard let dataFromAnnotation = currentSelectedAnnotation?.data else { return }
        guard let selectedFieldCalloutView =
            button.superview as? SelectedFieldCalloutView else { return }
        dataFromAnnotation.isSelected = false
        selectedFieldCalloutView.setStateButton(with: false)

        findFieldById(idField: dataFromAnnotation.idField)
            .do(
                onNext: {
                    self.removeFieldToListView(tupleField: $0, mapFieldInteraction: self.mapFieldInteraction)
            }
        )
            .observeOn(MainScheduler.instance)
            .take(1)
            .subscribe {
                if let polygonRenderer = $0.element?.3 as? MKPolygonRenderer {
                    self.configNotSelected(polygonRenderer: polygonRenderer)
                }
        }.disposed(by: self.disposeBag)
    }

    private func findFieldById(idField: Int) ->
        Observable<(FieldType, AnnotationWithData<PayloadFieldAnnotation>, MKPolygon, MKOverlayRenderer)> {
        if fieldsPolygonsAnnotations != nil {
            return Observable
                .from(fieldsPolygonsAnnotations!)
                .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
                .filter { self.filterSelectedBy(idField: idField, field: $0?.0)}
                .flatMap { self.flapMapToNotOptional(tupleField: $0, idField: idField) }
                .reduce([]) { self.reduce(tupleField: $1, to: $0) }
                .flatMap { self.getOverlayRendererAndAddTo(tupleField: $0)}
        }

        return Observable.error(NSError(domain: "not found field with id \(idField)", code: 1))
    }

    private func filterSelectedBy(idField: Int, field: Field<Polygon>?) -> Bool {
        if field != nil {
            return field!.id == idField
        }

        return false
    }

    private func flapMapToNotOptional(
        tupleField: (Field<Polygon>, MKPolygon, AnnotationWithData<PayloadFieldAnnotation>)?,
        idField: Int
    ) -> Observable<(FieldType, AnnotationWithData<PayloadFieldAnnotation>, MKPolygon)> {
        if let field = tupleField?.0, let annotationWithData = tupleField?.2, let mkPolygon = tupleField?.1 {
            return Observable.just((FieldType.polygon(field), annotationWithData, mkPolygon))
        }

        return Observable.error(NSError(domain: "not found field with id \(idField)", code: 1))
    }

    private func reduce(
        tupleField: (FieldType, AnnotationWithData<PayloadFieldAnnotation>, MKPolygon), to
        tupleFieldArray: [(FieldType, AnnotationWithData<PayloadFieldAnnotation>, MKPolygon)]
    ) -> [(FieldType, AnnotationWithData<PayloadFieldAnnotation>, MKPolygon)] {
        var tupleFieldArrayMutable = tupleFieldArray
        tupleFieldArrayMutable.append(tupleField)
        return tupleFieldArrayMutable
    }

    private func getOverlayRendererAndAddTo(
        tupleField: [(FieldType, AnnotationWithData<PayloadFieldAnnotation>, MKPolygon)]
    ) -> Observable<(FieldType, AnnotationWithData<PayloadFieldAnnotation>, MKPolygon, MKOverlayRenderer)> {
        if let over =  self.mapView.renderer(for: tupleField[0].2 ) {
            return Observable.just((tupleField[0].0, tupleField[0].1, tupleField[0].2, over))
        }

        return Observable.error(NSError(domain: "", code: 1))
    }

    private func dispatchAddFieldToListView(
        field: FieldType,
        mapFieldInteraction: MapFieldInteraction
    ) {
        mapFieldInteraction.selectedField(field: field)
    }

    private func removeFieldToListView(
        tupleField: (
        FieldType,
        AnnotationWithData<PayloadFieldAnnotation>,
        MKPolygon,
        MKOverlayRenderer
        ),
        mapFieldInteraction: MapFieldInteraction
    ) {
        mapFieldInteraction.deselectedField(field: tupleField.0)
    }

}
