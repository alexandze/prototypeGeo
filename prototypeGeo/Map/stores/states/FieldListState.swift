//
//  FieldListState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct FieldListState: Equatable {
    static func == (lhs: FieldListState, rhs: FieldListState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var fieldList: [FieldType]
    var currentField: FieldType?
    var isForRemove: Bool = false
    var indexForRemove: Int = 0
}
