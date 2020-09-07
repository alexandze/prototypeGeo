//
//  MapFieldAllFieldsState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import MapKit

struct MapFieldState: Equatable {
    static func == (lhs: MapFieldState, rhs: MapFieldState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var fieldDictionnary: [Int: Field]?
    var lastFieldSelected: Field?
    var lastFieldDeselected: Field?
    var responseAction: ResponseAction?

    enum ResponseAction {
        case willSelectedFieldOnMapActionResponse
        case getAllFieldActionResponse
        case getAllFieldErrorActionResponse
        case getAllFieldActionSuccessResponse
        case willDeselectFieldOnMapActionResponse
    }

    func changeValues(
        fieldDictionnary: [Int: Field]? = nil,
        lastFieldSelected: Field? = nil,
        lastFieldDeselected: Field? = nil,
        responseAction: ResponseAction? = nil
    ) -> MapFieldState {
        MapFieldState(
            uuidState: UUID().uuidString,
            fieldDictionnary: fieldDictionnary ?? self.fieldDictionnary,
            lastFieldSelected: lastFieldSelected ?? self.lastFieldSelected,
            lastFieldDeselected: lastFieldDeselected ?? self.lastFieldDeselected,
            responseAction: responseAction ?? self.responseAction
        )
    }
}
