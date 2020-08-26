//
//  FieldDetailsFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-20.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class FieldDetailsFactoryImpl: FieldDetailsFactory {
    let titleAddDoseFumier = "Ajouter une dose fumier"
    let subtitleAddDoseFumier = "Cliquer sur boutton"
    let titleDoseFumier = "Dose Fumier"
    
    func makeSectionListElementUIData(_ culturalPracticeOp: CulturalPractice? = nil) ->
        [Section<ElementUIData>] {
            var elementUIDataList = makeElementUIDataForValueForm(culturalPracticeOp)
            elementUIDataList = addRowWithButtonAddDoseFumier(elementUIDataList)
            let elementUIDaListContainer = makeElementUIDataForListValueForm(culturalPracticeOp)
            let elementUIListData = makeElementUIListData(elementUIDaListContainer)
            return makeSectionListByElementUIDataList(elementUIDataList: (elementUIDataList + elementUIListData))
    }
    
    func makeSectionListElementUIDataByResetSectionElementUIListData(
        _ culturalPractice: CulturalPractice,
        _ sectionList: [Section<ElementUIData>]
    ) -> [Section<ElementUIData>] {
        let indexRemoveList = findAllIndexSectionWithElementUIDataList(sectionList: sectionList)
        var copySectionList = sectionList
        
        indexRemoveList.sorted().reversed().forEach { indexRemove in
            copySectionList = removeSectionByIndex(copySectionList, indexRemove)
        }
        
        let elementUIDaListContainer = makeElementUIDataForListValueForm(culturalPractice)
        let elementUIListData =  makeElementUIListData(elementUIDaListContainer)
        let newSection = makeSectionListByElementUIDataList(elementUIDataList: elementUIListData)
        return copySectionList + newSection
    }
    
    func makeSectionWitNewDoseFumier(
        _ sectionList: [Section<ElementUIData>]
    ) -> [Section<ElementUIData>] {
        var index = findLastIndexDoseFumier(sectionList) ?? -1
        index += 1
        let newSectionDoseFumier = createSectionDoseFumier(index: index)
        return addDoseFumierToSectionList(sectionList, newSectionDoseFumier)
    }
    
    private func findLastIndexDoseFumier(_ sectionList: [Section<ElementUIData>]) -> Int? {
        let indexFind = (0..<sectionList.count).reversed().firstIndex { index in
            sectionList[index].typeSection == ElementUIListData.TYPE_ELEMENT
        }
        
        return indexFind.map { $0.base - 1 }
    }
    
    private func createSectionDoseFumier(index: Int) -> Section<ElementUIData> {
        let elementUIDataListDoseFumier = [
            DoseFumier.getTypeValue(),
            PeriodeApplicationFumier.getTypeValue(),
            DelaiIncorporationFumier.getTypeValue()
            ]
            .map { label in
                initElementUIDataWithNilValueByLabel(label)
        }.filter { $0 != nil }
            .map { $0! }
        
        return Section(
            sectionName: titleDoseFumier,
            rowData: elementUIDataListDoseFumier,
            typeSection: ElementUIListData.TYPE_ELEMENT,
            index: index
        )
    }
    
    private func addDoseFumierToSectionList(
        _ sectionList: [Section<ElementUIData>],
        _ sectionDoseFumier: Section<ElementUIData>
    ) -> [Section<ElementUIData>] {
        var copySection = sectionList
        copySection.append(sectionDoseFumier)
        return copySection
    }
    
    private func findAllIndexSectionWithElementUIDataList(sectionList: [Section<ElementUIData>]) -> [Int] {
        var indexList = [Int]()
        
        (0..<sectionList.count).forEach { index in
            if let typeSection = sectionList[index].typeSection, typeSection == ElementUIListData.TYPE_ELEMENT {
                indexList.append(index)
            }
        }
        
        return indexList
    }
    
    private func removeSectionByIndex(_ sectionList: [Section<ElementUIData>], _ index: Int) -> [Section<ElementUIData>] {
        var copySectionList = sectionList
        
        if Util.hasIndexInArray(copySectionList, index: index) {
            copySectionList.remove(at: index)
        }
        
        return copySectionList
    }
    
    private func makeSectionListByElementUIDataList(elementUIDataList: [ElementUIData]) -> [Section<ElementUIData>] {
        elementUIDataList.map { elementUIData in
            if let elementUIDataList = elementUIData as? ElementUIListData {
                return Section<ElementUIData>(
                    sectionName: elementUIDataList.title,
                    rowData: elementUIDataList.elements,
                    typeSection: elementUIDataList.type,
                    index: elementUIDataList.index
                )
            }
            
            return Section<ElementUIData>(
                sectionName: elementUIData.title,
                rowData: [elementUIData],
                typeSection: elementUIData.type
            )
        }
    }
    
    private func makeElementUIDataForValueForm(_ culturalPracticeOp: CulturalPractice? = nil) -> [ElementUIData] {
        let culturalPractice = culturalPracticeOp ?? CulturalPractice()
        let mirror = Mirror(reflecting: culturalPractice)
        
        return mirror.children.map(mapMirrorChildrenCulturalPractice(_:))
            .filter { $0 != nil  }
            .map { $0! }
    }
    
    private func makeElementUIDataForListValueForm(_ culturalPracticeOp: CulturalPractice? = nil) -> [[ElementUIData]] {
        let culturalPractice = culturalPracticeOp ?? CulturalPractice()
        let mirror = Mirror(reflecting: culturalPractice)
        
        return mirror.children
            .map(mapMirrorChildrenCulturalPracticeContainer(_:))
            .filter { $0 != nil }
            .map { $0! }
    }
    
    private func makeElementUIListData(
        _ elementUIDaListContainer: [[ElementUIData]]
    ) -> [ElementUIData] {
        
        guard !elementUIDaListContainer.isEmpty && !elementUIDaListContainer[0].isEmpty else {
            return []
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
                newElementUIDataList.append(
                    ElementUIListData(
                        title: titleDoseFumier,
                        elements: elementCurrent,
                        index: indexElementUIData
                    )
                )
            }
            
            elementCurrent = []
        }
        
        return newElementUIDataList
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
            typeValue: type(of: selectValue).getTypeValue(),
            rawValue: selectValue.getRawValue()
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
                typeValue: type(of: selectValue).getTypeValue(),
                rawValue: selectValue.getRawValue()
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
    
    private func addRowWithButtonAddDoseFumier(_ elementUIDataList: [ElementUIData]) -> [ElementUIData] {
        let rowWithButtonAddDoseFunier = RowWithButton(
            title: titleAddDoseFumier,
            subTitle: subtitleAddDoseFumier,
            action: ElementFormAction.add.rawValue
        )
        
        var copyElementUIDataList = elementUIDataList
        copyElementUIDataList.append(rowWithButtonAddDoseFunier)
        return copyElementUIDataList
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
            typeValue: inputValueType.getTypeValue(),
            regex: makeRegularExpression(inputValueType.getRegexPattern())
        )
    }
    
    private func makeRegularExpression(_ regexPattern: String) -> NSRegularExpression? {
        return try? NSRegularExpression(pattern: regexPattern, options: [.caseInsensitive])
    }
}

protocol FieldDetailsFactory {
    func makeSectionListElementUIData(_ culturalPracticeOp: CulturalPractice?) -> [Section<ElementUIData>]
    
    func makeSectionListElementUIDataByResetSectionElementUIListData(
        _ culturalPractice: CulturalPractice,
        _ sectionList: [Section<ElementUIData>]
    ) -> [Section<ElementUIData>]
    
    func makeSectionWitNewDoseFumier(
           _ sectionList: [Section<ElementUIData>]
       ) -> [Section<ElementUIData>]
}

protocol SelectValue: ValueForm {
    func getRawValue() -> Int
    static func getValues() -> [String]
    static func getTupleValues() -> [(Int, String)]
    static func make(rawValue: Int) -> SelectValue?
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
