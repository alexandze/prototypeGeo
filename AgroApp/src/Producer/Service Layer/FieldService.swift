//
//  FieldFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-30.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class FieldServiceImpl: FieldService {
    let fieldMakeSectionByFieldFactory: FieldMakeSectionByFieldFactory
    let fieldMakeFieldUpdateBySectionFactory: FieldMakeFieldUpdateBySectionFactory
    
    init(
        fieldMakeSectionByFieldFactory: FieldMakeSectionByFieldFactory = FieldMakeSectionByFieldFactoryImpl(),
        fieldMakeFieldUpdateBySectionFactory: FieldMakeFieldUpdateBySectionFactory = FieldMakeFieldUpdateBySectionFactoryImpl()
    ) {
        self.fieldMakeSectionByFieldFactory = fieldMakeSectionByFieldFactory
        self.fieldMakeFieldUpdateBySectionFactory = fieldMakeFieldUpdateBySectionFactory
    }
    
    func makeSectionByField(_ field: Field) -> [Section<ElementUIData>] {
        fieldMakeSectionByFieldFactory.makeSectionByField(field)
    }
    
    func makeFieldUpdateBySection(_ section: Section<ElementUIData>, _ field: Field) -> Field {
        fieldMakeFieldUpdateBySectionFactory.makeFieldUpdateBySection(section, field)
    }
}

protocol FieldService {
    func makeSectionByField(_ field: Field) -> [Section<ElementUIData>]
    func makeFieldUpdateBySection(_ section: Section<ElementUIData>, _ field: Field) -> Field
}
