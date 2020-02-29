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
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
}
