//
//  FarmerState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct FarmerState {
    var farmerTableViewControllerState: FarmerTableViewControllerState =
        FarmerTableViewControllerState(
            uuidState: "",
            farmers: [],
            sectionsFarmersFormated: [],
            isEmptyFarmers: true
    )
}
