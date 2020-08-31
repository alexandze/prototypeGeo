//
//  FieldMakeSectionByFieldFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-30.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class FieldMakeSectionByFieldFactoryImpl: FieldMakeSectionByFieldFactory {
    
    func makeSectionByField(_ field: Field) -> [Section<ElementUIData>] {
        getMirrorChildrenOfField(field)
            .map(mapMirrorChildToElementUIData(field))
            .filter(filterElementUIDataNotNil(_:))
            .map(mapUnwrapElementUIData(_:))
            .map(mapElementUIDataToSection(_:))
    }
    
    private func getMirrorChildrenOfField(_ field: Field) -> Mirror.Children {
        Mirror(reflecting: field).children
    }
    
    private func mapMirrorChildToElementUIData(_ field: Field) -> (Mirror.Child) -> ElementUIData? {
    { (child: Mirror.Child) in
        guard let label = child.label else {
            return nil
        }
        
        switch label  {
        case IdPleineTerre.getTypeValue():
            return self.makeElementUIData(IdPleineTerre.self, field.idPleinTerre)
        default:
            break
        }
        
        return nil
        }
    }
    
    // TODO creer une class elementUIData Factory
    func makeElementUIData(_ inputValueType: InputValue.Type ,_ inputValue: InputValue? = nil) -> ElementUIData {
        var inputElement = InputElement(
            title: inputValueType.getTitle(),
            value: inputValue?.getValue() ?? "",
            isValid: false,
            isRequired: true,
            regexPattern: inputValueType.getRegexPattern(),
            keyboardType: .normal,
            unitType: inputValueType.getUnitType(),
            typeValue: inputValueType.getTypeValue(),
            regex: makeRegularExpression(inputValueType.getRegexPattern())
        )
        
        inputElement.isValid = inputElement.isInputValid()
        return inputElement
    }
    
    private func makeRegularExpression(_ regexPattern: String) -> NSRegularExpression? {
        return try? NSRegularExpression(pattern: regexPattern, options: [.caseInsensitive])
    }
    
    private func mapElementUIDataToSection(_ elementUIData: ElementUIData) -> Section<ElementUIData> {
        Section(sectionName: elementUIData.title, rowData: [elementUIData], typeSection: elementUIData.type)
    }
    
    private func filterElementUIDataNotNil(_ elementUIDataOp: ElementUIData?) -> Bool {
        elementUIDataOp != nil
    }
    
    private func mapUnwrapElementUIData(_ elementUIDataOp: ElementUIData?) -> ElementUIData {
        elementUIDataOp!
    }
    
}

protocol FieldMakeSectionByFieldFactory {
    func makeSectionByField(_ field: Field) -> [Section<ElementUIData>]
}
