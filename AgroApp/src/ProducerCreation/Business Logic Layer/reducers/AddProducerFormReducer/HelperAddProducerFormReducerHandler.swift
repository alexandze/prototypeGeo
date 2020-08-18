//
//  HelperAddProducerFormReducerHandler.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-17.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class HelperAddProducerFormReducerHandlerImpl: HelperAddProducerFormReducerHandler {

    func filterElementUIDataRequired(elementUIDataList: [ElementUIDataObservable]) -> [ElementUIDataObservable] {
        elementUIDataList.filter { elementUIData in
            (elementUIData as? InputElementDataObservable)?.isRequired ?? false
        }
    }

    func checkIfAllInputElementRequiredIsValid(elementUIDataRequiredList: [ElementUIDataObservable]) -> Bool {
        let firstIndexInvalidValue = elementUIDataRequiredList.firstIndex { elementUIData in
            guard let isValid = (elementUIData as? InputElementDataObservable)?.isInputValid() else {
                return true
            }

            return !isValid
        }

       return !(firstIndexInvalidValue != nil)
    }
}

protocol HelperAddProducerFormReducerHandler {
    func filterElementUIDataRequired(elementUIDataList: [ElementUIDataObservable]) -> [ElementUIDataObservable]
    func checkIfAllInputElementRequiredIsValid(elementUIDataRequiredList: [ElementUIDataObservable]) -> Bool
}
