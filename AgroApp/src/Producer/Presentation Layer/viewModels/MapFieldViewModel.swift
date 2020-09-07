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
    weak var mapFieldView: MapFieldView?
    var state: MapFieldState?
    let mapFieldService: MapFieldService
    let idClusterAnnotation = "idCLusterAnnotation"
    let idAnnotationView = "My annotation view"
    var currentSelectedAnnotation: AnnotationWithData<PayloadFieldAnnotation>?
    let disposeBag = DisposeBag()
    var lastSelectedFieldCalloutView: SelectedFieldCalloutView?

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
        guard let mapFieldView = mapFieldView else { return }
        let location2D = CLLocationCoordinate2DMake(45.233023116000027, -73.355880542999955)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        let region = MKCoordinateRegion(center: location2D, span: coordinateSpan)
        
        guard let mapView =  mapFieldView.mapView else {
            return
        }
        
        mapView.region = mapView.regionThatFits(region)
    }

    func registerAnnotationView() {
        guard let mapFieldView = mapFieldView else { return }
        mapFieldView.mapView?.register(
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
        guard let mapFieldView = mapFieldView else { return }

        annotationsWithData.forEach {
            mapFieldView.mapView?.addAnnotation($0)
        }
    }

    private func addToMap(polygonsWithData: [PolygonWithData<PayloadFieldAnnotation>]) {
        guard let mapFieldView = mapFieldView else { return }

        polygonsWithData.forEach {
            mapFieldView.mapView?.addOverlay($0)
        }
    }

    private func selectePolygonOf(field: Field) {
        guard let mapFieldView = mapFieldView else { return }

        field.polygon.forEach {
            let polygonRenderer = mapFieldView.mapView?.renderer(for: $0) as? MKPolygonRenderer
            mapFieldView.configSelected(polygonRenderer: polygonRenderer)
        }
    }

    private func deselectPolygonOf(field: Field) {
        guard let mapFieldView = mapFieldView else { return }

        field.polygon.forEach {
            let polygonRenderer = mapFieldView.mapView?.renderer(for: $0) as? MKPolygonRenderer
            mapFieldView.configNotSelected(polygonRenderer: polygonRenderer)
        }
    }

    private func setAnnotationIsSelected(_ fieldSelected: Field) {
        (0..<fieldSelected.annotation.count).forEach { index in
            fieldSelected.annotation[index].data?.isSelected = true
        }
    }

    private func setAnnotationDataIsDeselected(_ fieldDeselected: Field) {
        (0..<fieldDeselected.annotation.count).forEach { index in
            fieldDeselected.annotation[index].data?.isSelected = false
        }
    }

    private func printAddButtonInCalloutView(idField: Int) {
        guard lastSelectedFieldCalloutView?.idField == idField else { return }
        lastSelectedFieldCalloutView?.setStateButton(isSelected: false)
    }
    
    deinit {
        print("******** MapFieldViewModel ********")
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
            selectedFieldRightCalloutView.setStateButton(isSelected: dataFromAnnotationView.isSelected)
            lastSelectedFieldCalloutView = selectedFieldRightCalloutView
            lastSelectedFieldCalloutView?.idField = dataFromAnnotationView.idField
        }
    }

    func handle(overlay: MKOverlay) -> MKOverlayRenderer {
        guard let mapFieldView = mapFieldView,
            let overlay = overlay as? PolygonWithData<PayloadFieldAnnotation>
            else { return MKOverlayRenderer()}

        let polygonRenderer = MKPolygonRenderer(polygon: overlay)

        if overlay.data!.isSelected {
            mapFieldView.configSelected(polygonRenderer: polygonRenderer)
            return polygonRenderer
        }

        mapFieldView.configNotSelected(polygonRenderer: polygonRenderer)
        return polygonRenderer
    }

    func handle(mkAnnotation: MKAnnotation) -> MKAnnotationView? {
        guard let mapFieldView = mapFieldView,
            mkAnnotation is AnnotationWithData<PayloadFieldAnnotation> else { return nil }

        let markerAnnotationView = mapFieldView.mapView?.dequeueReusableAnnotationView(
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

    private func handleWillDeselectFieldOnMapActionResponse() {
        guard let lastFieldDeselected = state?.lastFieldDeselected
            else { return }

        deselectPolygonOf(field: lastFieldDeselected)
        setAnnotationDataIsDeselected(lastFieldDeselected)
        printAddButtonInCalloutView(idField: lastFieldDeselected.id)
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
        guard let lastSelected = state?.lastFieldSelected,
            let fieldSelected = state?.fieldDictionnary?[lastSelected.id]
            else { return }

        selectePolygonOf(field: fieldSelected)
        setAnnotationIsSelected(fieldSelected)
    }

    private func handleGetAllFieldActionSuccessResponse() {
        addPolygonsAndAnnotationsToMap()
        // TODO dispatch success add polygon and annotation
    }

    private func handleCancel(button: UIButton) {
        guard let dataFromAnnotation = currentSelectedAnnotation?.data,
            let selectedFieldCalloutView = button.superview as? SelectedFieldCalloutView
            else { return }

        lastSelectedFieldCalloutView = selectedFieldCalloutView
        lastSelectedFieldCalloutView?.setStateButton(isSelected: false)
        lastSelectedFieldCalloutView?.idField = dataFromAnnotation.idField
        mapFieldInteraction.willDeselectedFieldOnMapAction(field: self.state?.fieldDictionnary?[dataFromAnnotation.idField])
    }

    private func handleAdd(button: UIButton) {
        guard let dataFromAnnotation = currentSelectedAnnotation?.data,
            let selectedFieldCalloutView = button.superview as? SelectedFieldCalloutView else { return }

        lastSelectedFieldCalloutView = selectedFieldCalloutView
        lastSelectedFieldCalloutView?.setStateButton(isSelected: true)
        lastSelectedFieldCalloutView?.idField = dataFromAnnotation.idField
        mapFieldInteraction.willSelectedFieldOnMapAction(field: self.state?.fieldDictionnary?[dataFromAnnotation.idField])
    }

    private func handleGetAllFieldErrorResponse() {
        // TODO handle error get All field
    }
}

// Dispatcher
extension MapFieldViewModel {

}
