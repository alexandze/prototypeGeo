//
//  FieldDetailsFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-20.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class FieldDetailsFactoryImpl: FieldDetailsFactory {
    
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
        
        guard !elementUIDaListContainer[0].isEmpty else {
            return elementUIDataList
        }
        
        var newElementUIDataList = [ElementUIListData]()
        var elementCurrent = [ElementUIData]()
        
        (0..<elementUIDaListContainer[0].count).forEach { indexElementUIData in
            
            (0..<elementUIDaListContainer.count).forEach { indexArrayElementUIData in
                
                if Util.hasIndexInArray(elementUIDaListContainer, index: indexArrayElementUIData) &&
                    Util.hasIndexInArray(elementUIDaListContainer[indexArrayElementUIData], index: indexElementUIData) {
                    
                    elementCurrent.append(elementUIDaListContainer[indexArrayElementUIData][indexElementUIData])
                    
                }
                
            }
            
            if elementCurrent.count == CulturalPractice.MAX_DOSE_FUMIER {
                newElementUIDataList.append(ElementUIListDataImpl(title: "Dose Fumier \(indexElementUIData + 1)", elements: elementCurrent))
            }
            
            elementCurrent = []
        }
        
        return elementUIDataList + newElementUIDataList
    }
    
    private func mapMirrorChildrenCulturalPractice(_ child: Mirror.Child) -> ElementUIData? {
        
        if case Optional<Any>.none = child.value, let label = child.label {
            return initElementUIDataWithNilValueByLabel(label)
        }
        
        if let selectValue = child.value as? SelectValue {
            return initElementUIDataBySelectValue(selectValue)
        }
        
        if let inputValue = child.value as? InputValue {
            return initElementUIDataByInputValue(inputValue)
        }
        
        return nil
    }
    
    private func mapMirrorChildrenCulturalPracticeContainer(_ child: Mirror.Child) -> [ElementUIData]? {
        
        guard let valueFormList = child.value as? [ValueForm] else {
            return nil
        }
        
        if let selectValueList = valueFormList as? [SelectValue] {
            return initElementUIDataBySelectValues(selectValueList)
        }
        
        if let inputValuesList = valueFormList as? [InputValue] {
            return initElementUIDataByInputValues(inputValuesList)
        }
        
        return nil
    }
    
    private func initElementUIDataBySelectValue(_ selectValue: SelectValue) -> ElementUIData {
        SelectElement(
            title: type(of: selectValue).getTitle(),
            value: selectValue.getValue(),
            isValid: true,
            isRequired: true,
            values: type(of: selectValue).getValues(),
            typeValue: type(of: selectValue).getTypeValue()
        )
    }
    
    private func initElementUIDataByInputValue(_ inputValue: InputValue) -> ElementUIData {
        InputElement(
            title: type(of: inputValue).getTitle(),
            value: inputValue.getValue(),
            isValid: true,
            isRequired: true,
            regexPattern: type(of: inputValue).getRegexPattern(),
            unitType: type(of: inputValue).getUnitType(),
            typeValue: type(of: inputValue).getTypeValue(),
            regex: makeRegularExpression(type(of: inputValue).getRegexPattern())
        )
    }
    
    private func initElementUIDataBySelectValues(_ selectValues: [SelectValue]) -> [ElementUIData] {
        selectValues.map { selectValue in
            SelectElement(
                title: type(of: selectValue).getTitle(),
                value: selectValue.getValue(),
                isValid: true,
                isRequired: true,
                values: type(of: selectValue).getValues(),
                typeValue: type(of: selectValue).getTypeValue()
            )
        }
    }
    
    private func initElementUIDataByInputValues(_ inputValues: [InputValue]) -> [ElementUIData] {
        inputValues.map { inputValue in
            InputElement(
                title: type(of: inputValue).getTitle(),
                value: inputValue.getValue(),
                isValid: true,
                isRequired: true,
                regexPattern: type(of: inputValue).getRegexPattern(),
                unitType: type(of: inputValue).getUnitType(),
                typeValue: type(of: inputValue).getTypeValue(),
                regex: makeRegularExpression(type(of: inputValue).getRegexPattern())
            )
        }
    }
    
    private func initElementUIDataWithNilValueByLabel(_ label: String) -> ElementUIData? {
        switch label {
        case Avaloir.getTypeValue():
            return createElementUIDataWithNilValue(Avaloir.self)
        case BandeRiveraine.getTypeValue():
            return createElementUIDataWithNilValue(BandeRiveraine.self)
        case TravailSol.getTypeValue():
            return createElementUIDataWithNilValue(TravailSol.self)
        case CouvertureAssociee.getTypeValue():
            return createElementUIDataWithNilValue(CouvertureAssociee.self)
        case CouvertureDerobee.getTypeValue():
            return createElementUIDataWithNilValue(CouvertureDerobee.self)
        case DrainageSouterrain.getTypeValue():
            return createElementUIDataWithNilValue(DrainageSouterrain.self)
        case DrainageSurface.getTypeValue():
            return createElementUIDataWithNilValue(DrainageSurface.self)
        case ConditionProfilCultural.getTypeValue():
            return createElementUIDataWithNilValue(ConditionProfilCultural.self)
        case TauxApplicationPhosphoreRang.getTypeValue():
            return createElementUIDataWithNilValue(TauxApplicationPhosphoreRang.self)
        case TauxApplicationPhosphoreVolee.getTypeValue():
            return createElementUIDataWithNilValue(TauxApplicationPhosphoreVolee.self)
        case PMehlich3.getTypeValue():
            return createElementUIDataWithNilValue(PMehlich3.self)
        case AlMehlich3.getTypeValue():
            return createElementUIDataWithNilValue(AlMehlich3.self)
        case CultureAnneeEnCoursAnterieure.getTypeValue():
            return createElementUIDataWithNilValue(CultureAnneeEnCoursAnterieure.self)
        default:
            return nil
        }
        
    }
    
    private func createElementUIDataWithNilValue(_ selectValueType: SelectValue.Type) -> ElementUIData {
        SelectElement(
            title: selectValueType.getTitle(),
            isValid: false,
            isRequired: true,
            values: selectValueType.getValues(),
            typeValue: selectValueType.getTypeValue()
        )
    }
    
    private func createElementUIDataWithNilValue(_ inputValueType: InputValue.Type) -> ElementUIData {
        InputElement(
            title: inputValueType.getTitle(),
            isValid: false,
            isRequired: true,
            regexPattern: inputValueType.getRegexPattern(),
            unitType: inputValueType.getUnitType(),
            typeValue: inputValueType.getTypeValue()
        )
    }
    
    private func makeRegularExpression(_ regexPattern: String) -> NSRegularExpression? {
        return try? NSRegularExpression(pattern: regexPattern, options: [.caseInsensitive])
    }
}

protocol FieldDetailsFactory {
    
}

protocol SelectValue: ValueForm {
    static func getValues() -> [String]
    static func getTupleValues() -> [(Int, String)]
}

protocol InputValue: ValueForm {
    static func getRegexPattern() -> String
    static func getUnitType() -> String
    static func make(value: String) -> InputValue?
}

protocol ValueForm {
    func getValue() -> String
    static func getTypeValue() -> String
    static func getTitle() -> String
}
