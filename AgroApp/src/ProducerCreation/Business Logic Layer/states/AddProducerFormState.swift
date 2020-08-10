//
//  AddProducerFormState.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-06.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct AddProducerFormState: Equatable {

    static func == (lhs: AddProducerFormState, rhs: AddProducerFormState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var listElementUIData: [ElementUIData]?
    var listElementValue: [String]?
    var listElementValid: [Bool]?
    var responseAction: ResponseAction?

    func changeValues(
        listElementUIData: [ElementUIData]? = nil,
        listElementValue: [String]? = nil,
        listElementValid: [Bool]? = nil,
        responseAction: ResponseAction
    ) -> AddProducerFormState {
        AddProducerFormState(
            uuidState: UUID().uuidString,
            listElementUIData: listElementUIData ?? self.listElementUIData,
            listElementValue: listElementValue ?? self.listElementValue,
            listElementValid: listElementValid ?? self.listElementValid,
            responseAction: responseAction
        )
    }

    enum ResponseAction {
        case getListElementUIDataWihoutValueResponse
        case notResponse
    }
}
