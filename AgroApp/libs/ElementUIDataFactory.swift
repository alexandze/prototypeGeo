//
//  ElementUIDataFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-31.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class ElementUIDataFactoryImpl: ElementUIDataFactory {
    
    func makeElementUIData(_ inputValueType: InputValue.Type ,_ inputValue: InputValue? = nil, _ number: Int? = nil) -> ElementUIData {
        var inputElement = InputElement(
            title: inputValueType.getTitle(),
            value: inputValue?.getValue() ?? "",
            isValid: false,
            isRequired: true,
            regexPattern: inputValueType.getRegexPattern(),
            keyboardType: .normal,
            unitType: inputValueType.getUnitType(),
            typeValue: inputValueType.getTypeValue(),
            regex: makeRegularExpression(inputValueType.getRegexPattern()),
            number: number
        )
        
        inputElement.isValid = inputElement.isInputValid()
        return inputElement
    }
    
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
    
    func makeElementUIData(_ selectValueType: SelectValue.Type, _ selectValue: SelectValue? = nil) -> ElementUIData {
        let rawValue = selectValue?.getRawValue() ??
            (Util.hasIndexInArray(selectValueType.getTupleValues(), index: 0)
                ? selectValueType.getTupleValues()[0].0
                : 0)

        return SelectElement(
            title: selectValueType.getTitle(),
            value: selectValue?.getValue(),
            isValid: selectValue?.getValue() != nil,
            isRequired: true,
            values: selectValueType.getTupleValues(),
            typeValue: selectValueType.getTypeValue(),
            rawValue: rawValue,
            indexValue: findIndexValueByRawValue(rawValue, values: selectValueType.getTupleValues())
        )
    }
    
    func makeElementUIData(_ selectValueInit: SelectValueInit) -> ElementUIData {
        SelectElement(
            title: type(of: selectValueInit).getTitle(),
            value: !selectValueInit.getValue().isEmpty ? selectValueInit.getValue() : nil,
            isValid: true,
            isRequired: true,
            values: selectValueInit.getTupleValues(),
            typeValue: type(of: selectValueInit).getTypeValue(),
            rawValue: selectValueInit.getIndexValueSelected() ?? 0,
            indexValue: findIndexValueByRawValue(selectValueInit.getIndexValueSelected() ?? 0, values: selectValueInit.getTupleValues()),
            canEdit: selectValueInit.getValues().count > 1
        )
    }
    
    func makeInputElementWithRemoveButton(_ inputValueType: InputValue.Type, _ number: Int) -> ElementUIData {
        InputElementWithRemoveButton(
            title: inputValueType.getTitle(),
            value: "",
            isValid: false,
            isRequired: true,
            action: ElementFormAction.remove.rawValue,
            regexPattern: inputValueType.getRegexPattern(),
            number: number,
            regex: makeRegularExpression(inputValueType.getRegexPattern()),
            typeValue: inputValueType.getTypeValue()
        )
    }
    
    func makeInputElementWithRemoveButton(_ inputValueType: InputValue.Type, _ inputValue: InputValue, _ number: Int) -> ElementUIData {
        var inputValueWithRemoveButton = InputElementWithRemoveButton(
            title: inputValueType.getTitle(),
            value: inputValue.getValue(),
            isValid: false,
            isRequired: true,
            action: ElementFormAction.remove.rawValue,
            regexPattern: inputValueType.getRegexPattern(),
            number: number,
            regex: makeRegularExpression(inputValueType.getRegexPattern()),
            typeValue: inputValueType.getTypeValue()
        )
        
        inputValueWithRemoveButton.isValid = inputValueWithRemoveButton.isInputValid()
        return inputValueWithRemoveButton
    }
    
    private func makeRegularExpression(_ regexPattern: String) -> NSRegularExpression? {
        return try? NSRegularExpression(pattern: regexPattern, options: [.caseInsensitive])
    }
    
    private func findIndexValueByRawValue(_ rawValue: Int, values: [(Int, String)]) -> Int? {
        values.firstIndex { tupleRawValue in
            tupleRawValue.0 == rawValue
        }
    }
}

protocol ElementUIDataFactory {
    func makeElementUIData(_ inputValueType: InputValue.Type ,_ inputValue: InputValue?) -> ElementUIData
    func makeElementUIData(_ inputValueType: InputValue.Type ,_ inputValue: InputValue?, _ number: Int?) -> ElementUIData
    func makeElementUIData(_ selectValueType: SelectValue.Type, _ selectValue: SelectValue?) -> ElementUIData
    func makeElementUIData(_ selectValueInit: SelectValueInit) -> ElementUIData
    func makeInputElementWithRemoveButton(_ inputValueType: InputValue.Type, _ number: Int) -> ElementUIData
    func makeInputElementWithRemoveButton(_ inputValueType: InputValue.Type, _ inputValue: InputValue, _ number: Int) -> ElementUIData
}
