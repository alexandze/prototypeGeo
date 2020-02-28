//
//  FarmerTableVIewControllerState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct FarmerTableViewControllerState: Equatable {
    static func == (lhs: FarmerTableViewControllerState, rhs: FarmerTableViewControllerState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }
    
    
    var uuidState: String
    var farmers: [Farmer]
    var sectionsFarmersFormated: [Section<FarmerFormated>]
    var isEmptyFarmers: Bool
}
