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
}

protocol AddProducerFormService {
    func getElementUIDataObservableList() -> [ElementUIDataObservable]
}
