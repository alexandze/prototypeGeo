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
    var elementUIDataObservableList: [ElementUIDataObservable]?
    var addButtonElementObservable: ButtonElementObservable?
    var producer: Producer?
    var enterpriseList: [Enterprise]?
    var responseAction: ResponseAction?

    func changeValues(
        elementUIDataObservableList: [ElementUIDataObservable]? = nil,
        addButtonElementObservable: ButtonElementObservable? = nil,
        producer: Producer? = nil,
        enterpriseList: [Enterprise]? = nil,
        responseAction: ResponseAction
    ) -> AddProducerFormState {
        AddProducerFormState(
            uuidState: UUID().uuidString,
            elementUIDataObservableList: elementUIDataObservableList ?? self.elementUIDataObservableList,
            addButtonElementObservable: addButtonElementObservable ?? self.addButtonElementObservable,
            producer: producer ?? self.producer,
            enterpriseList: enterpriseList ?? self.enterpriseList,
            responseAction: responseAction
        )
    }

    enum ResponseAction {
        case getListElementUIDataWihoutValueResponse
        case checkIfInputElemenIsValidActionResponse(index: Int)
        case checkIfAllInputElementIsValidActionResponse(isAllInputValid: Bool)
        case addNimInputElementActionResponse(indexOfNewNimInputElement: Int)
        case removeNimInputElementActionResponse(indexInputElementRemoved: Int, indexInputElementUpdateList: [Int])
        case validateFormActionResponse(isAllInputElementRequiredIsValid: Bool, nimSelectValue: NimSelectValue?)
        case notResponse
    }
}
