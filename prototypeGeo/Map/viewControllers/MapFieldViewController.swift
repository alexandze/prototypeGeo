//
//  MapFieldViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit
import MapKit


class MapFieldViewController: UIViewController, MKMapViewDelegate, Identifier {
    static var identifier: String = "MapFieldViewController"
    
    var mapFieldViewModel: MapFieldViewModel!
    var mapFieldView: MapFieldView!
    var mapView: MKMapView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(mapFieldViewModel: MapFieldViewModel) {
        self.mapFieldViewModel = mapFieldViewModel
        self.mapFieldView = MapFieldView(mapFieldViewModel: self.mapFieldViewModel)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = self.mapFieldView
        self.mapFieldViewModel.mapView = self.mapFieldView.mapView
        self.mapView = self.mapFieldView.mapView
        self.mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapFieldViewModel.subscribeToTableViewControllerState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.mapFieldViewModel.disposeToTableViewControllerState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapFieldViewModel.dispatchGetAllFields()
        self.mapFieldViewModel.registerAnnotationView()
        self.mapFieldViewModel.initTitleNavigation(viewController: self)
        self.mapFieldViewModel.initRegion()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        self.mapFieldViewModel.handleAnnotation(mkAnnotation: annotation)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        self.mapFieldViewModel.handleOverlay(overlay: overlay)
    }
    
    
    
    
    
    
    
    
    
    

}
