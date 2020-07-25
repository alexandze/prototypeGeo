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
    var lastIdFieldSelected: Int?
    var lastIdFieldDeselected: Int?
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
        lastIdFieldSelected: Int? = nil,
        lastIdFieldDeselected: Int? = nil,
        responseAction: ResponseAction? = nil
    ) -> MapFieldState {
        MapFieldState(
            uuidState: UUID().uuidString,
            fieldDictionnary: fieldDictionnary ?? self.fieldDictionnary,
            lastIdFieldSelected: lastIdFieldSelected ?? self.lastIdFieldSelected,
            lastIdFieldDeselected: lastIdFieldDeselected ?? self.lastIdFieldDeselected,
            responseAction: responseAction ?? self.responseAction
        )
    }
}
