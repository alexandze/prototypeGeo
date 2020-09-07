//
//  AddProducerFormService.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-14.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class AddProducerFormServiceImpl: AddProducerFormService {
    let addProducerFormFactory: AddProducerFormFactory

    init(addProducerFormFactory: AddProducerFormFactory = AddProducerFormFactoryImpl()) {
        self.addProducerFormFactory = addProducerFormFactory
    }

    func getElementUIDataObservableList() -> [ElementUIDataObservable] {
        addProducerFormFactory.makeElementUIDataObservableList()
    }

    func getAddButtonElementObservable(isEnabled: Bool) -> ButtonElementObservable {
        addProducerFormFactory.makeAddNimButtonElementObservable(isEnabled: isEnabled)
    }

    func getNimTitle() -> String {
        addProducerFormFactory.getNimTitle()
    }

    func getMaxNim() -> Int {
        addProducerFormFactory.getMaxNim()
    }

    func makeNimInputElementWithRemoveButton(value: String? = nil, number: Int? = nil) -> InputElementWithRemoveButtonObservable {
        addProducerFormFactory.makeNimInputElementWithRemoveButton(value: value, number: number)
    }

}

protocol AddProducerFormService {
    func getElementUIDataObservableList() -> [ElementUIDataObservable]
    func getAddButtonElementObservable(isEnabled: Bool) -> ButtonElementObservable
    func getNimTitle() -> String
    func getMaxNim() -> Int
    func makeNimInputElementWithRemoveButton(value: String?, number: Int?) -> InputElementWithRemoveButtonObservable
}
