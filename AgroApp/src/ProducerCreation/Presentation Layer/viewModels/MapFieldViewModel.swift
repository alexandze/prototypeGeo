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
    var fieldDictionnary: [Int: Field]?

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

    func subscribeToTableViewControllerState() {
        self.disposableMapFieldAllState = self.mapFieldAllFieldStateObs
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { state in
                // TODO faire des response d'action
                self.handleInitMap(
                    fieldDictionnary: state.fieldDictionnary
                )
            })
    }

    func initRegion() {
        let location2D = CLLocationCoordinate2DMake(45.233023116000027, -73.355880542999955)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        let region = MKCoordinateRegion(center: location2D, span: coordinateSpan)
        self.mapView.region = mapView.regionThatFits(region)
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
        //viewController.title = "Carte"
        viewController.tabBarItem = barIttem
    }

    func disposeToTableViewControllerState() {
        _ = Util.runInSchedulerBackground {
            self.disposableMapFieldAllState?.dispose()
        }
    }

    private func set(fieldDictionnary: [Int: Field]) {
        self.fieldDictionnary = fieldDictionnary
    }

    private func addPolygonsAndAnnotationsToMap(_ fieldDictionnary: [Int: Field]) {
        fieldDictionnary.forEach { (_, field) in
            addToMap(polygonsWithData: field.polygon)
            addToMap(annotationsWithData: field.annotation)
        }
    }

    private func addToMap(
        annotationsWithData: [AnnotationWithData<PayloadFieldAnnotation>]
    ) {
        annotationsWithData.forEach {
            self.mapView.addAnnotation($0)
        }

    }

    private func addToMap(polygonsWithData: [PolygonWithData<PayloadFieldAnnotation>]) {
        polygonsWithData.forEach {
            self.mapView.addOverlay($0)
        }
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

    private func configSelected(polygonRenderer: MKPolygonRenderer?) {
        guard let polygonRenderer = polygonRenderer else { return }
        polygonRenderer.fillColor = UIColor.green.withAlphaComponent(0.3)
        polygonRenderer.strokeColor = UIColor.yellow.withAlphaComponent(0.8)
        polygonRenderer.lineWidth = 2
    }

    private func configNotSelected(polygonRenderer: MKPolygonRenderer?) {
        guard let polygonRenderer = polygonRenderer else { return }
        polygonRenderer.fillColor = UIColor.red.withAlphaComponent(0.1)
        polygonRenderer.strokeColor = UIColor.yellow.withAlphaComponent(0.8)
        polygonRenderer.lineWidth = 2
    }

}

// Handler
extension MapFieldViewModel {
    func handleAnnotationViewSelected(annotationView: MKAnnotationView) {
        if let selectedFieldRightCalloutView =
            (annotationView as? MKMarkerAnnotationView)?.rightCalloutAccessoryView as? SelectedFieldCalloutView,
            let annotationWithData = annotationView.annotation as? AnnotationWithData<PayloadFieldAnnotation>,
            let dataFromAnnotationView = annotationWithData.data {
            self.currentSelectedAnnotation = annotationWithData
            selectedFieldRightCalloutView.setStateButton(with: dataFromAnnotationView.isSelected)
        }
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

        return nil
    }

    private func handleInitMap(fieldDictionnary: [Int: Field]) {
        addPolygonsAndAnnotationsToMap(fieldDictionnary)
        set(fieldDictionnary: fieldDictionnary)

        // TODO dispatch success add polygon and annotation
    }

    private func handleCancel(button: UIButton) {
        guard let dataFromAnnotation = currentSelectedAnnotation?.data else { return }
        guard let selectedFieldCalloutView =
            button.superview as? SelectedFieldCalloutView else { return }
        dataFromAnnotation.isSelected = false
        selectedFieldCalloutView.setStateButton(with: false)
        let fieldDeselected = fieldDictionnary?[dataFromAnnotation.idField]

        fieldDeselected?.polygon.forEach {
            let polygonRenderer = self.mapView.renderer(for: $0) as? MKPolygonRenderer
            configNotSelected(polygonRenderer: polygonRenderer)
        }

        dipatchRemoveFieldToListView(field: fieldDeselected)
    }

    private func handleAdd(button: UIButton) {
        guard let dataFromAnnotation = currentSelectedAnnotation?.data else { return }
        guard let selectedFieldCalloutView = button.superview as? SelectedFieldCalloutView else { return }

        dataFromAnnotation.isSelected = true
        selectedFieldCalloutView.setStateButton(with: true)
        let fieldSelected = fieldDictionnary?[dataFromAnnotation.idField]

        fieldSelected?.polygon.forEach {
            let polygonRenderer = self.mapView.renderer(for: $0) as? MKPolygonRenderer
            configSelected(polygonRenderer: polygonRenderer)
        }

        dispatchAddFieldToListView(field: fieldSelected)
    }
}

// Dispatcher
extension MapFieldViewModel {
    private func dispatchAddFieldToListView(
        field: Field?
    ) {
        guard let field = field else { return }
        mapFieldInteraction.selectedField(field: field)
    }

    private func dipatchRemoveFieldToListView(
        field: Field?
    ) {
        guard let field = field else { return }
        mapFieldInteraction.deselectedField(field: field)
    }
}
