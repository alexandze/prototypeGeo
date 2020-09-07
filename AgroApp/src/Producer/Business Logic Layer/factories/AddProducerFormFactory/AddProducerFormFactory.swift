//
//  AddProducerFormFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-11.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import SwiftUI

class AddProducerFormFactoryImpl: AddProducerFormFactory {

    let elementUIDataFactory: ProducerElementUIDataFactory

    init(elementUIDataFactory: ProducerElementUIDataFactory = ProducerElementUIDataFactoryImpl()) {
        self.elementUIDataFactory = elementUIDataFactory
    }

    func makeElementUIDataObservableList() -> [ElementUIDataObservable] {
        elementUIDataFactory.makeElementUIDataObservableList()
    }

    func makeAddNimButtonElementObservable(isEnabled: Bool?) -> ButtonElementObservable {
        elementUIDataFactory.makeAddNimButtonElementObservable(isEnabled: isEnabled)
    }

    func makeNimInputElementWithRemoveButton(value: String?, number: Int?) -> InputElementWithRemoveButtonObservable {
        elementUIDataFactory.makeNimInputElementWithRemoveButton(value: value, number: number)
    }

    func getMaxNim() -> Int {
        elementUIDataFactory.getMaxNim()
    }

    func getNimTitle() -> String {
        elementUIDataFactory.getNimTitle()
    }
}

protocol AddProducerFormFactory {
    func getNimTitle() -> String
    func makeElementUIDataObservableList() -> [ElementUIDataObservable]
    func makeAddNimButtonElementObservable(isEnabled: Bool?) -> ButtonElementObservable
    func getMaxNim() -> Int
    func makeNimInputElementWithRemoveButton(value: String?, number: Int?) -> InputElementWithRemoveButtonObservable
}
