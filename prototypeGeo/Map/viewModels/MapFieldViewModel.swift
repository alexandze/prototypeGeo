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
    let mapFieldAllFieldState$: Observable<MapFieldState>
    let mapFieldInteraction: MapFieldInteraction
    var disposableMapFieldAllState: Disposable?
    var mapView: MKMapView!
    
    let idClusterAnnotation = "idCLusterAnnotation"
    let idAnnotationView = "My annotation view"
    
    init(
        mapFieldAllFieldState$: Observable<MapFieldState>,
        mapFieldInteraction: MapFieldInteraction
    ) {
        self.mapFieldAllFieldState$ = mapFieldAllFieldState$
        self.mapFieldInteraction = mapFieldInteraction
    }
    
    func initRegion() {
        let location2D = CLLocationCoordinate2DMake(45.233023116000027, -73.355880542999955)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        let region = MKCoordinateRegion(center: location2D, span: coordinateSpan)
        self.mapView.region = mapView.regionThatFits(region)
    }
    
    func handleAnnotation(mkAnnotation: MKAnnotation) -> MKAnnotationView? {
        if mkAnnotation is AnnotationWithData<PayloadFieldAnnotation> {
            let markerAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: self.idAnnotationView, for: mkAnnotation) as! MKMarkerAnnotationView
            markerAnnotation.titleVisibility = .adaptive
            markerAnnotation.subtitleVisibility = .adaptive
            markerAnnotation.markerTintColor = .black
            markerAnnotation.clusteringIdentifier = self.idClusterAnnotation
            markerAnnotation.displayPriority = .defaultHigh
            markerAnnotation.canShowCallout = true
            let test = UIView()
            test.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            
            let buttonAdd = UIButton(type: .contactAdd)
            let buttonCancel = UIButton(type: .close)
            
           
            
            
            test.addSubview(buttonCancel)
            test.addSubview(buttonAdd)
            
            buttonAdd.translatesAutoresizingMaskIntoConstraints = false
            buttonCancel.translatesAutoresizingMaskIntoConstraints = false
            
            buttonCancel.isHidden = true
            buttonAdd.isHidden = true
                       
            NSLayoutConstraint.activate([
                buttonAdd.centerXAnchor.constraint(equalTo: test.centerXAnchor),
                buttonAdd.centerYAnchor.constraint(equalTo: test.centerYAnchor)
            ])
            
            NSLayoutConstraint.activate([
                buttonCancel.centerXAnchor.constraint(equalTo: test.centerXAnchor),
                buttonCancel.centerYAnchor.constraint(equalTo: test.centerYAnchor)
            ])
            

            
            

            markerAnnotation.rightCalloutAccessoryView = test
            
            
            // markerAnnotation.animatesWhenAdded = true
           //  markerAnnotation.isDraggable = true
            return markerAnnotation
        }
        if mkAnnotation is MKClusterAnnotation {
            
        }
        
        return nil
    }
    
    func handleOverlay(overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKPolygon {
            let polygonRenderer = MKPolygonRenderer(polygon: overlay)
            polygonRenderer.fillColor = UIColor.red.withAlphaComponent(0.1)
            polygonRenderer.strokeColor = UIColor.yellow.withAlphaComponent(0.8)
            polygonRenderer.lineWidth = 2
            return polygonRenderer
        }
        
        return MKOverlayRenderer()
    }
    
    func registerAnnotationView() {
        self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: self.idAnnotationView)
    }
    
    func dispatchGetAllFields() {
        mapFieldInteraction.getAllField()
    }
    
    func initTitleNavigation(viewController: UIViewController) {
        viewController.navigationItem.title = "Carte"
    }
    
    func configTabBarItem(viewController: UIViewController) {
        let barIttem = UITabBarItem(title: "Carte", image: nil, tag: 25)
        barIttem.title = "Carte"
       // viewController.title = "Carte"
        viewController.tabBarItem = barIttem
    }
    
    func subscribeToTableViewControllerState() {
        self.disposableMapFieldAllState = self.mapFieldAllFieldState$.subscribe(onNext:{ state  in
            self.proccessInitMap(fieldPolygonAnnotation: state.fieldPolygonAnnotation, fieldMultiPolygonAnnotation: state.fieldMultiPolygonAnnotation)
        })
    }
    
    func disposeToTableViewControllerState() {
        self.disposableMapFieldAllState?.dispose()
    }
    
    private func proccessInitMap(
        fieldPolygonAnnotation: [(Field<Polygon>, MKPolygon, AnnotationWithData<PayloadFieldAnnotation>)?],
        fieldMultiPolygonAnnotation: [(Field<MultiPolygon>, [(MKPolygon, AnnotationWithData<PayloadFieldAnnotation>)?])]
    ) {
        fieldPolygonAnnotation.forEach { fieldPolygonAnnotationTuple in
            addAnnotation(in: self.mapView, mkPointAnnotation: fieldPolygonAnnotationTuple?.2)
            addOverlay(in: self.mapView, mkPolygon: fieldPolygonAnnotationTuple?.1)
        }
        
        fieldMultiPolygonAnnotation.forEach { fieldMultiPolygonAnnotationTuple in
            fieldMultiPolygonAnnotationTuple.1.forEach { tuplePolygonAnnotation in
                self.addAnnotation(in: self.mapView, mkPointAnnotation: tuplePolygonAnnotation?.1)
                self.addOverlay(in: self.mapView, mkPolygon: tuplePolygonAnnotation?.0)
            }
        }
    }
    
    private func addAnnotation(in mapView: MKMapView, mkPointAnnotation: AnnotationWithData<PayloadFieldAnnotation>?) {
        mkPointAnnotation.map {mapView.addAnnotation($0)}
    }
    
    private func addOverlay(in mapView: MKMapView, mkPolygon: MKPolygon?) {
        mkPolygon.map { mapView.addOverlay($0) }
    }
}
