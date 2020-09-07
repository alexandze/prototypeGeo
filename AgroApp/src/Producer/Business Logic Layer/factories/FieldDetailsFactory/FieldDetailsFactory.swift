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
    let elementUIDataFactory: ElementUIDataFactory
    
    init(elementUIDataFactory: ElementUIDataFactory = ElementUIDataFactoryImpl()) {
        self.elementUIDataFactory = elementUIDataFactory
    }
    
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
        var index = findLastIndexDoseFumier(sectionList)
        index += 1
        let newSectionDoseFumier = createSectionDoseFumier(index: index)
        return addDoseFumierToSectionList(sectionList, newSectionDoseFumier)
    }
    
    private func findLastIndexDoseFumier(_ sectionList: [Section<ElementUIData>]) -> Int {
        let indexFindOp = (0..<sectionList.count).reversed().firstIndex { index in
            sectionList[index].typeSection == ElementUIListData.TYPE_ELEMENT
        }
        
        if let indexFind = indexFindOp,
            Util.hasIndexInArray(sectionList, index: (indexFind.base - 1)),
            let lastIndexFind = sectionList[indexFind.base - 1].index {
            return lastIndexFind
        }
        
        return -1
    }
    
    private func createSectionDoseFumier(index: Int) -> Section<ElementUIData> {
        let elementUIDataListDoseFumier = [
            DoseFumier.getTypeValue(),
            PeriodeApplicationFumier.getTypeValue(),
            DelaiIncorporationFumier.getTypeValue()
            ]
            .map { label in
                initElementUIDataWithNilValueByLabelDoseFumier(label)
        }.filter { $0 != nil }
            .map { $0! }
        
        return Section(
            sectionName: titleDoseFumier,
            rowData: elementUIDataListDoseFumier,
            typeSection: ElementUIListData.TYPE_ELEMENT,
            index: index
        )
    }
    
    private func initElementUIDataWithNilValueByLabelDoseFumier(_ label: String) -> ElementUIData? {
        switch label {
        case DoseFumier.getTypeValue():
            return elementUIDataFactory.makeElementUIData(DoseFumier.self, nil)
        case PeriodeApplicationFumier.getTypeValue():
            return elementUIDataFactory.makeElementUIData(PeriodeApplicationFumier.self, nil)
        case DelaiIncorporationFumier.getTypeValue():
            return elementUIDataFactory.makeElementUIData(DelaiIncorporationFumier.self, nil)
        default:
            return nil
        }
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
    
    // TODO creer une class elementUIData Factory qui permet de creer une section a partir d'un tableau
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
        
        return mirror.children.map(mapMirrorChildrenCulturalPractice(culturalPractice))
            .filter { $0 != nil  }
            .map { $0! }
    }
    
    private func makeElementUIDataForListValueForm(_ culturalPracticeOp: CulturalPractice? = nil) -> [[ElementUIData]] {
        let culturalPractice = culturalPracticeOp ?? CulturalPractice()
        let mirror = Mirror(reflecting: culturalPractice)
        
        return mirror.children
            .map(mapMirrorChildrenCulturalPracticeContainer(culturalPractice))
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
    
    private func mapMirrorChildrenCulturalPractice(_ culturalPractice: CulturalPractice) -> (Mirror.Child) -> ElementUIData? {
    { (child: Mirror.Child) in
        if let label = child.label {
            return self.initElementUIDataByLabel(label, culturalPractice)
        }
        return nil
        }
    }
    
    private func mapMirrorChildrenCulturalPracticeContainer(_ culturalPractice: CulturalPractice) -> (Mirror.Child) -> [ElementUIData]? {
    { (child: Mirror.Child) in
        guard let label = child.label else { return nil }
        return self.initElementUIDataForDoseFumier(label, culturalPractice)
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
    
    private func initElementUIDataByLabel(_ label: String, _ culturalPractice: CulturalPractice) -> ElementUIData? {
        switch label {
        case Avaloir.getTypeValue():
            return elementUIDataFactory.makeElementUIData(Avaloir.self, culturalPractice.avaloir)
        case BandeRiveraine.getTypeValue():
            return elementUIDataFactory.makeElementUIData(BandeRiveraine.self, culturalPractice.bandeRiveraine)
        case TravailSol.getTypeValue():
            return elementUIDataFactory.makeElementUIData(TravailSol.self, culturalPractice.travailSol)
        case CouvertureAssociee.getTypeValue():
            return elementUIDataFactory.makeElementUIData(CouvertureAssociee.self, culturalPractice.couvertureAssociee)
        case CouvertureDerobee.getTypeValue():
            return elementUIDataFactory.makeElementUIData(CouvertureDerobee.self, culturalPractice.couvertureDerobee)
        case DrainageSouterrain.getTypeValue():
            return elementUIDataFactory.makeElementUIData(DrainageSouterrain.self, culturalPractice.drainageSouterrain)
        case DrainageSurface.getTypeValue():
            return elementUIDataFactory.makeElementUIData(DrainageSurface.self, culturalPractice.drainageSurface)
        case ConditionProfilCultural.getTypeValue():
            return elementUIDataFactory.makeElementUIData(ConditionProfilCultural.self, culturalPractice.conditionProfilCultural)
        case TauxApplicationPhosphoreRang.getTypeValue():
            return elementUIDataFactory.makeElementUIData(TauxApplicationPhosphoreRang.self, culturalPractice.tauxApplicationPhosphoreRang)
        case TauxApplicationPhosphoreVolee.getTypeValue():
            return elementUIDataFactory.makeElementUIData(TauxApplicationPhosphoreVolee.self, culturalPractice.tauxApplicationPhosphoreVolee)
        case PMehlich3.getTypeValue():
            return elementUIDataFactory.makeElementUIData(PMehlich3.self, culturalPractice.pMehlich3)
        case AlMehlich3.getTypeValue():
            return elementUIDataFactory.makeElementUIData(AlMehlich3.self, culturalPractice.alMehlich3)
        case CultureAnneeEnCoursAnterieure.getTypeValue():
            return elementUIDataFactory.makeElementUIData(CultureAnneeEnCoursAnterieure.self, culturalPractice.cultureAnneeEnCoursAnterieure)
        default:
            return nil
        }
    }
    
    private func initElementUIDataForDoseFumier(_ label: String, _ culturalPractice: CulturalPractice) -> [ElementUIData]? {
        switch label {
        case DoseFumier.getTypeValue():
            return makeElementUIDataList(DoseFumier.self, culturalPractice.doseFumier)
        case PeriodeApplicationFumier.getTypeValue():
            return makeElementUIDataList(PeriodeApplicationFumier.self, culturalPractice.periodeApplicationFumier)
        case DelaiIncorporationFumier.getTypeValue():
            return makeElementUIDataList(DelaiIncorporationFumier.self, culturalPractice.delaiIncorporationFumier)
        default:
            return nil
        }
    }
    
    private func makeElementUIDataList(_ selectValueType: SelectValue.Type, _ selectValueList: [SelectValue]?) -> [ElementUIData]? {
        guard let selectValueList = selectValueList else {
            return nil
        }
        
        return selectValueList.map { selectValue in
            elementUIDataFactory.makeElementUIData(selectValueType, selectValue)
        }
    }
    
    private func makeElementUIDataList(_ inputValueType: InputValue.Type, _ inputValueList: [InputValue]?) -> [ElementUIData]? {
        guard let inputValueList = inputValueList else {
            return nil
        }
        
        return inputValueList.map { inputValue in
            elementUIDataFactory.makeElementUIData(inputValueType, inputValue)
        }
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

protocol SelectValueInit: ValueForm {
    func getIndexValueSelected() -> Int?
    func getValues() -> [String]
    func getTupleValues() -> [(Int, String)]
    static func make(_ values: [String], _ indexValueSelected: Int?) -> SelectValueInit
    static func setIndexValueSelected(_ indexValueSelected: Int, selectValueInit: SelectValueInit) -> SelectValueInit
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
