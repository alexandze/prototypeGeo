//
//  FieldMakeFieldUpdateBySectionFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-30.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class FieldMakeFieldUpdateBySectionFactoryImpl: FieldMakeFieldUpdateBySectionFactory {
    func makeFieldUpdateBySection(_ section: Section<ElementUIData>, _ field: Field) -> Field {
        var copyField = field
        
        section.rowData
            .map(mapCastElementUIDataToInputElement(_:))
            .filter(filterInputElementNotNil(_:))
            .map(mapUnwrapInputElement(_:))
            .forEach { inputElement in
                copyField = updateFieldByInputElement(copyField, inputElement)
        }
        
        return copyField
    }
    
    func updateFieldByInputElement(_ field: Field, _ inputElement: InputElement) -> Field {
        guard let typeValue = inputElement.typeValue else {
            return field
        }
        
        var copyField = field
        
        switch typeValue {
        case IdPleineTerre.getTypeValue():
            copyField.idPleinTerre = self.makeInputValue(IdPleineTerre.self, inputElement.value) as? IdPleineTerre
        default:
            return copyField
        }
        
        return copyField
    }
    
    private func makeInputValue(_ inputValueType: InputValue.Type, _ value: String) -> InputValue? {
        inputValueType.make(value: value)
    }
    
    private func mapCastElementUIDataToInputElement(_ elementUIData: ElementUIData) -> InputElement? {
        elementUIData as? InputElement
    }
    
    private func filterInputElementNotNil(_ inputElementOp: InputElement?) -> Bool {
        inputElementOp != nil
    }
    
    private func mapUnwrapInputElement(_ inputElementOp: InputElement?) -> InputElement {
        inputElementOp!
    }
}

protocol FieldMakeFieldUpdateBySectionFactory {
    func makeFieldUpdateBySection(_ section: Section<ElementUIData>, _ field: Field) -> Field
}
