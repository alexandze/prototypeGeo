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
    var mapFieldView: MapFieldView!
    var state: MapFieldState?
    let mapFieldService: MapFieldService
    let idClusterAnnotation = "idCLusterAnnotation"
    let idAnnotationView = "My annotation view"
    var currentSelectedAnnotation: AnnotationWithData<PayloadFieldAnnotation>?
    let disposeBag = DisposeBag()

    init(
        mapFieldAllFieldStateObs: Observable<MapFieldState>,
        mapFieldInteraction: MapFieldInteraction,
        mapFieldService: MapFieldService = MapFieldService()
    ) {
        self.mapFieldAllFieldStateObs = mapFieldAllFieldStateObs
        self.mapFieldInteraction = mapFieldInteraction
        self.mapFieldService = mapFieldService
    }

    func subscribeToTableViewControllerState() {
        self.disposableMapFieldAllState = self.mapFieldAllFieldStateObs
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { state in
                guard let responseAction = state.responseAction else { return }
                self.set(state: state)

                switch responseAction {
                case .willSelectedFieldOnMapActionResponse:
                    self.handleWillSelectedFieldOnMapActionResponse()
                case .getAllFieldActionResponse:
                    self.handleGetAllFieldActionResponse()
                case .getAllFieldActionSuccessResponse:
                    self.handleGetAllFieldActionSuccessResponse()
                case .getAllFieldErrorActionResponse:
                    self.handleGetAllFieldErrorResponse()
                case .willDeselectFieldOnMapActionResponse:
                    self.handleWillDeselectFieldOnMapActionResponse()
                }
            })
    }

    func initRegion() {
        let location2D = CLLocationCoordinate2DMake(45.233023116000027, -73.355880542999955)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        let region = MKCoordinateRegion(center: location2D, span: coordinateSpan)
        mapFieldView.mapView.region = mapFieldView.mapView.regionThatFits(region)
    }

    func registerAnnotationView() {
        mapFieldView.mapView.register(
            MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: self.idAnnotationView
        )
    }

    func set(state: MapFieldState) {
        self.state = state
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

    private func addPolygonsAndAnnotationsToMap() {
        state?.fieldDictionnary?.forEach { (_, field) in
            addToMap(polygonsWithData: field.polygon)
            addToMap(annotationsWithData: field.annotation)
        }
    }

    private func addToMap(
        annotationsWithData: [AnnotationWithData<PayloadFieldAnnotation>]
    ) {
        annotationsWithData.forEach {
            self.mapFieldView.mapView.addAnnotation($0)
        }
    }

    private func addToMap(polygonsWithData: [PolygonWithData<PayloadFieldAnnotation>]) {
        polygonsWithData.forEach {
            self.mapFieldView.mapView.addOverlay($0)
        }
    }

    private func selectePolygonOf(field: Field) {
        field.polygon.forEach {
            let polygonRenderer = self.mapFieldView.mapView.renderer(for: $0) as? MKPolygonRenderer
            self.mapFieldView.configSelected(polygonRenderer: polygonRenderer)
        }
    }

    private func deselectPolygonOf(field: Field) {
        field.polygon.forEach {
            let polygonRenderer = self.mapFieldView.mapView.renderer(for: $0) as? MKPolygonRenderer
            self.mapFieldView.configNotSelected(polygonRenderer: polygonRenderer)
        }
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
                self.mapFieldView.configSelected(polygonRenderer: polygonRenderer)
                return polygonRenderer
            }

            self.mapFieldView.configNotSelected(polygonRenderer: polygonRenderer)
            return polygonRenderer
        }

        return MKOverlayRenderer()
    }

    func handle(mkAnnotation: MKAnnotation) -> MKAnnotationView? {
        if mkAnnotation is AnnotationWithData<PayloadFieldAnnotation> {
            let markerAnnotationView = mapFieldView.mapView.dequeueReusableAnnotationView(
                withIdentifier:
                self.idAnnotationView,
                for: mkAnnotation
                ) as? MKMarkerAnnotationView

            mapFieldView.config(
                markerAnnotationView: markerAnnotationView,
                idClusterAnnotation: idClusterAnnotation
            )

            mapFieldView.configRightCalloutAccessoryView(
                mkAnnotation: mkAnnotation,
                markerAnnotationView: markerAnnotationView,
                handleAddFunc: {[weak self] button in self?.handleAdd(button: button) },
                handleCancelFunc: {[weak self] button in self?.handleCancel(button: button) }
            )

            return markerAnnotationView
        }

        return nil
    }

    private func handleWillDeselectFieldOnMapActionResponse() {
        guard let lastIdDeselected = state?.lastIdFieldDeselected,
            let fieldDeselected = state?.fieldDictionnary?[lastIdDeselected]
            else { return }

        deselectPolygonOf(field: fieldDeselected)
        mapFieldInteraction.didDeselectFieldOnMapAction(field: fieldDeselected)
    }

    private func handleGetAllFieldActionResponse() {
        _ = mapFieldService.getFieldsObs()
            .observeOn(Util.getSchedulerMain())
            .subscribe(onSuccess: {
                self.mapFieldInteraction.getFieldSuccessAction($0)
            }, onError: {
                self.mapFieldInteraction.getFieldErrorAction(error: $0)
            })
    }

    private func handleWillSelectedFieldOnMapActionResponse() {
        guard let lastIdSelected = state?.lastIdFieldSelected,
            let fieldSelected = state?.fieldDictionnary?[lastIdSelected]
            else { return }

        selectePolygonOf(field: fieldSelected)
        mapFieldInteraction.didSelectedFieldAction(field: fieldSelected)
    }

    private func handleGetAllFieldActionSuccessResponse() {
        addPolygonsAndAnnotationsToMap()
        // TODO dispatch success add polygon and annotation
    }

    private func handleCancel(button: UIButton) {
        guard let dataFromAnnotation = currentSelectedAnnotation?.data else { return }
        guard let selectedFieldCalloutView = button.superview as? SelectedFieldCalloutView else { return }
        dataFromAnnotation.isSelected = false
        selectedFieldCalloutView.setStateButton(with: false)
        mapFieldInteraction.willDeselectedFieldOnMapAction(idField: dataFromAnnotation.idField)
    }

    private func handleAdd(button: UIButton) {
        guard let dataFromAnnotation = currentSelectedAnnotation?.data else { return }
        guard let selectedFieldCalloutView = button.superview as? SelectedFieldCalloutView else { return }
        dataFromAnnotation.isSelected = true
        selectedFieldCalloutView.setStateButton(with: true)
        mapFieldInteraction.willSelectedFieldOnMapAction(idField: dataFromAnnotation.idField)
    }

    private func handleGetAllFieldErrorResponse() {
        // TODO handle error get All field
    }
}

// Dispatcher
extension MapFieldViewModel {

}
