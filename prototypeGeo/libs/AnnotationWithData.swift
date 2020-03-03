//
//  AnnotationWithData.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-03.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit
import MapKit

class AnnotationWithData<T>: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var data: T?
    
    init(location coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
    
    init(location coordinate: CLLocationCoordinate2D, data: T) {
        self.coordinate = coordinate
        self.data = data
        super.init()
    }
}
