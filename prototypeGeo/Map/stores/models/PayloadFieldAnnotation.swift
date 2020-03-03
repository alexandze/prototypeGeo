//
//  PayloadFieldAnnotation.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-03.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct PayloadFieldAnnotation {
    let idField: Int
    var isSelected = false
    
    init(idField: Int) {
        self.idField = idField
    }
}
