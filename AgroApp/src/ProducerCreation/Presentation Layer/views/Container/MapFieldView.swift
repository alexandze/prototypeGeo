//
//  MapFieldView.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit
import MapKit

class MapFieldView: UIView {
    public static let VIEW_TAG = 99
    let mapFieldViewModel: MapFieldViewModel

    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .satellite
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    init(mapFieldViewModel: MapFieldViewModel) {
        self.mapFieldViewModel = mapFieldViewModel
        super.init(frame: .zero)
        addMapViewToViewParent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addMapViewToViewParent() {
        addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor ),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func config(markerAnnotationView: MKMarkerAnnotationView?, idClusterAnnotation: String) {
        guard let markerAnnotationView = markerAnnotationView else { return }
        markerAnnotationView.titleVisibility = .adaptive
        markerAnnotationView.subtitleVisibility = .adaptive
        markerAnnotationView.markerTintColor = .black
        markerAnnotationView.clusteringIdentifier = idClusterAnnotation
        markerAnnotationView.displayPriority = .defaultHigh
        markerAnnotationView.canShowCallout = true
    }

    func configNotSelected(polygonRenderer: MKPolygonRenderer?) {
        guard let polygonRenderer = polygonRenderer else { return }
        polygonRenderer.fillColor = UIColor.red.withAlphaComponent(0.1)
        polygonRenderer.strokeColor = UIColor.yellow.withAlphaComponent(0.8)
        polygonRenderer.lineWidth = 2
    }

    func configSelected(polygonRenderer: MKPolygonRenderer?) {
        guard let polygonRenderer = polygonRenderer else { return }
        polygonRenderer.fillColor = UIColor.green.withAlphaComponent(0.3)
        polygonRenderer.strokeColor = UIColor.yellow.withAlphaComponent(0.8)
        polygonRenderer.lineWidth = 2
    }

    func configRightCalloutAccessoryView(
        mkAnnotation: MKAnnotation,
        markerAnnotationView: MKMarkerAnnotationView?,
        handleAddFunc: @escaping (UIButton) -> Void,
        handleCancelFunc: @escaping (UIButton) -> Void
    ) {
        guard let annotationWithData =
            mkAnnotation as? AnnotationWithData<PayloadFieldAnnotation>,
        let dataFromAnnotation = annotationWithData.data,
        let markerAnnotationView = markerAnnotationView else { return }

        if markerAnnotationView.rightCalloutAccessoryView == nil {
            let rightCalloutAccessoryView = SelectedFieldCalloutView()
            rightCalloutAccessoryView.addTargetButtonAdd(handleAddFunc: handleAddFunc)
            rightCalloutAccessoryView.addTargetButtonCancel(handleCancelFunc: handleCancelFunc)
            rightCalloutAccessoryView.setStateButton(isSelected: dataFromAnnotation.isSelected)
            return markerAnnotationView.rightCalloutAccessoryView = rightCalloutAccessoryView
        }

        if let rightCalloutAccessoryView =
            markerAnnotationView.rightCalloutAccessoryView as? SelectedFieldCalloutView {
            return rightCalloutAccessoryView.setStateButton(isSelected: dataFromAnnotation.isSelected)
        }
    }

}
