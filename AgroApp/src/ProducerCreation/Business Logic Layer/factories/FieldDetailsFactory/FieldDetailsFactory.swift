//
//  FieldDetailsFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-20.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class FieldDetailsFactoryImpl: FieldDetailsFactory {
    
    var cache: [[ElementUIData]]?
    
    func getElementUIDataByCulturalPractice(_ culturalPracticeOp: CulturalPractice? = nil) -> [ElementUIData] {
        let culturalPractice = culturalPracticeOp ?? CulturalPractice()
        let mirror = Mirror(reflecting: culturalPractice)
        let elementUIDataList = mirror.children.map(mapMirrorChildrenCulturalPractice(_:))
            .filter { $0 != nil  }
            .map { $0! }
        
        let elementUIDaListContainer = mirror.children
            .map(mapMirrorChildrenCulturalPracticeContainer(_:))
            .filter { $0 != nil }
            .map { $0! }
        
        return fusionElementUIDataList(elementUIDataList, with: elementUIDaListContainer)
    }
    
    private func fusionElementUIDataList(
        _ elementUIDataList: [ElementUIData],
        with elementUIDaListContainer: [[ElementUIData]]
    ) -> [ElementUIData] {
        guard !elementUIDaListContainer.isEmpty && !elementUIDaListContainer[0].isEmpty else {
            return []
        }
        
        var newElementUIDataList = [ElementUIListData]()
        var elementCurrent = [ElementUIData]()
        
        (0..<elementUIDaListContainer[0].count).forEach { indexElementUIData in
            (0..<elementUIDaListContainer.count).forEach { indexArrayElementUIData in
                elementCurrent.append(elementUIDaListContainer[indexArrayElementUIData][indexElementUIData])
            }
            newElementUIDataList.append(ElementUIListDataImpl(title: "Dose Fumier \(indexElementUIData + 1)", elements: elementCurrent))
            elementCurrent = []
        }
        
        return elementUIDataList + newElementUIDataList
    }
    
    private func mapMirrorChildrenCulturalPractice(_ child: Mirror.Child) -> ElementUIData? {
        switch child.value {
        case let selectValue as SelectValue:
            return initElementUIDataBySelectValue(selectValue)
        case let inputValue as InputValue:
            return initElementUIDataByInputValue(inputValue)
        default:
            return nil
        }
    }
    
    private func mapMirrorChildrenCulturalPracticeContainer(_ child: Mirror.Child) -> [ElementUIData]? {
        switch child.value {
        case let selectValues as [SelectValue]:
            return initElementUIDataBySelectValues(selectValues)
        case let inputValues as [InputValue]:
            return initElementUIDataByInputValues(inputValues)
        default:
            return nil
        }
    }
    
    private func initElementUIDataBySelectValue(_ selectValue: SelectValue) -> ElementUIData {
        SelectElement(
            title: selectValue.getTitle(),
            value: selectValue.getValue(),
            isValid: selectValue.getValue() != nil,
            isRequired: selectValue.isRequired(),
            values: selectValue.getValues(),
            unitType: selectValue.getUnitType(),
            typeValue: selectValue.getTypeValue()
        )
    }
    
    private func initElementUIDataByInputValue(_ inputValue: InputValue) -> ElementUIData {
        InputElement(
            title: inputValue.getTitle(),
            value: inputValue.getValue(),
            isValid: inputValue.getValue() != nil,
            isRequired: inputValue.isRequired(),
            regexPattern: inputValue.getRegexPattern(),
            unitType: inputValue.getUnitType(),
            typeValue: inputValue.getTypeValue()
        )
    }
    
    private func initElementUIDataBySelectValues(_ selectValues: [SelectValue]) -> [ElementUIData] {
        selectValues.map { selectValue in
            SelectElement(
                title: selectValue.getTitle(),
                value: selectValue.getValue(),
                isValid: selectValue.getValue() != nil,
                isRequired: selectValue.isRequired(),
                values: selectValue.getValues(),
                unitType: selectValue.getUnitType(),
                typeValue: selectValue.getTypeValue()
            )
        }
    }
    
    private func initElementUIDataByInputValues(_ inputValues: [InputValue]) -> [ElementUIData] {
        inputValues.map { inputValue in
            InputElement(
                title: inputValue.getTitle(),
                value: inputValue.getValue(),
                isValid: inputValue.getValue() != nil,
                isRequired: inputValue.isRequired(),
                regexPattern: inputValue.getRegexPattern(),
                unitType: inputValue.getUnitType(),
                typeValue: inputValue.getTypeValue()
            )
        }
    }
    
}

protocol FieldDetailsFactory {
    
}

protocol SelectValue: ValueForm {
    func isRequired() -> Bool
    func getValues() -> [String]
    func getTupleValues() -> [(Int, String)]
}

protocol InputValue: ValueForm {
    func isRequired() -> Bool
    func getRegexPattern() -> String
}

protocol ValueForm {
    func getTitle() -> String
    func getValue() -> String?
    func getUnitType() -> String?
    func getTypeValue() -> String
}
