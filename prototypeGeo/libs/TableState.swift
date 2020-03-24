//
//  TableState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-23.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum TableState {
    case reloadData
    case insertRows(indexPath: [IndexPath])
    case deletedRows(indexPath: [IndexPath])
}
