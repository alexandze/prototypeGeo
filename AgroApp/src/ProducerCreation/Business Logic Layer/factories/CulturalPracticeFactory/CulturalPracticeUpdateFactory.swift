//
//  CulturalPracticeUpdateFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class CulturalPracticeUpdateFactoryImpl: CulturalPracticeUpdateFactory {
    
    func makeCulturalPracticeByUpdate(_ culturalPractice: CulturalPractice? = nil, _ elementUIData: ElementUIData) -> CulturalPractice? {
        let culturalPractice = culturalPractice ?? CulturalPractice()
        
        switch elementUIData {
         case _ as SelectElement:
            return makeCulturalPractice(culturalPractice, elementUIData)
        case _ as InputElement:
            return makeCulturalPractice(culturalPractice, elementUIData)
        case let elementUIListData as ElementUIListData:
            return makeCulturalPractice(culturalPractice, elementUIListData)
        default:
            return nil
        }
    }
    
    private func makeCulturalPractice(_ culturalPractice: CulturalPractice, _ elemenetUIData: ElementUIData, _ index: Int? = nil) -> CulturalPractice? {
        switch elemenetUIData {
        case let selectElement as SelectElement:
            return makeCulturalPractice(culturalPractice, selectElement, index)
        case let inputElement as InputElement:
            return makeCulturalPractice(culturalPractice, inputElement, index)
        default:
            return nil
        }
    }
    
    private func makeCulturalPractice(
        _ culturalPractice: CulturalPractice,
        _ elementUIListData: ElementUIListData
    ) -> CulturalPractice? {
        let index = elementUIListData.index
        var copyCulturalPractice = culturalPractice
        
        elementUIListData.elements.forEach { elementUIData in
            let newCulturalPracticeOp = makeCulturalPractice(copyCulturalPractice, elementUIData, index)
            
            if let newCulturalPractice = newCulturalPracticeOp {
                copyCulturalPractice = newCulturalPractice
            }
        }
        
        return copyCulturalPractice
    }
    
    
    private func makeCulturalPractice(
        _ culturalPractice: CulturalPractice,
        _ inputElement: InputElement,
        _ index: Int? = nil
    ) -> CulturalPractice? {
        guard let value = inputElement.value else { return nil }
        var copyCulturalPractice = culturalPractice
        
        switch inputElement.typeValue {
        case AlMehlich3.getTypeValue():
            copyCulturalPractice.alMehlich3 = AlMehlich3.make(value: value) as? AlMehlich3
        case PMehlich3.getTypeValue():
            copyCulturalPractice.pMehlich3 = PMehlich3.make(value: value) as? PMehlich3
        case TauxApplicationPhosphoreRang.getTypeValue():
            copyCulturalPractice.tauxApplicationPhosphoreRang = TauxApplicationPhosphoreRang.make(value: value) as? TauxApplicationPhosphoreRang
        case TauxApplicationPhosphoreVolee.getTypeValue():
            copyCulturalPractice.tauxApplicationPhosphoreVolee = TauxApplicationPhosphoreVolee.make(value: value) as? TauxApplicationPhosphoreVolee
        case DoseFumier.getTypeValue():
            copyCulturalPractice.doseFumier = makeInputValueList(DoseFumier.self, copyCulturalPractice.doseFumier, value, index) as? [DoseFumier]
        default:
            return nil
        }
        
        return copyCulturalPractice
    }
    
    
    
    private func makeCulturalPractice(
        _ culturalPractice: CulturalPractice,
        _ selectElement: SelectElement,
        _ index: Int? = nil
    ) -> CulturalPractice? {
        guard let rawValue = selectElement.rawValue else { return  nil }
        var copyCulturalPractice = culturalPractice
        
        switch selectElement.typeValue {
        case Avaloir.getTypeValue():
            copyCulturalPractice.avaloir = Avaloir(rawValue: rawValue)
        case BandeRiveraine.getTypeValue():
            copyCulturalPractice.bandeRiveraine = BandeRiveraine(rawValue: rawValue)
        case TravailSol.getTypeValue():
            copyCulturalPractice.travailSol = TravailSol(rawValue: rawValue)
        case CouvertureAssociee.getTypeValue():
            copyCulturalPractice.couvertureAssociee = CouvertureAssociee(rawValue: rawValue)
        case CouvertureDerobee.getTypeValue():
            copyCulturalPractice.couvertureDerobee = CouvertureDerobee(rawValue: rawValue)
        case DrainageSouterrain.getTypeValue():
            copyCulturalPractice.drainageSouterrain = DrainageSouterrain(rawValue: rawValue)
        case DrainageSurface.getTypeValue():
            copyCulturalPractice.drainageSurface = DrainageSurface(rawValue: rawValue)
        case ConditionProfilCultural.getTypeValue():
            copyCulturalPractice.conditionProfilCultural = ConditionProfilCultural(rawValue: rawValue)
        case CultureAnneeEnCoursAnterieure.getTypeValue():
            copyCulturalPractice.cultureAnneeEnCoursAnterieure = CultureAnneeEnCoursAnterieure(rawValueIndex: rawValue)
        case PeriodeApplicationFumier.getTypeValue():
            copyCulturalPractice.periodeApplicationFumier = makeSelectValueList(
                PeriodeApplicationFumier.self,
                copyCulturalPractice.periodeApplicationFumier,
                rawValue, index
            ) as? [PeriodeApplicationFumier]
        case DelaiIncorporationFumier.getTypeValue():
            copyCulturalPractice.delaiIncorporationFumier = makeSelectValueList(
                DelaiIncorporationFumier.self,
                copyCulturalPractice.delaiIncorporationFumier,
                rawValue, index
            ) as? [DelaiIncorporationFumier]
        default:
            return nil
        }
        
        return copyCulturalPractice
    }
    
    private func makeSelectValueList(_ typeSelf: SelectValue.Type, _ selectValues: [SelectValue]?, _ rawValue: Int, _ index: Int?) -> [SelectValue]? {
        guard let index = index else { return nil }
        var selectValueList = selectValues ?? []
        let selectValueOp = typeSelf.make(rawValue: index)
        
        if Util.hasIndexInArray(selectValueList, index: index), let selectValue = selectValueOp {
            selectValueList[index] = selectValue
            return selectValueList
        }
        
        if let selectValue = selectValueOp {
            selectValueList.append(selectValue)
            return selectValueList
        }
        
        return nil
    }
    
    
    private func makeInputValueList(_ typeSelf: InputValue.Type, _ inputValues: [InputValue]?, _ value: String, _ index: Int?) -> [InputValue]? {
        guard let index = index else { return nil }
        var inputValueList = inputValues ?? []
        let inputValueOps = typeSelf.make(value: value)
        
        if Util.hasIndexInArray(inputValueList, index: index),
            let inputValue = inputValueOps {
            inputValueList[index] = inputValue
            return inputValueList
        }
        
        if let inputValue = inputValueOps {
            inputValueList.append(inputValue)
            return inputValueList
        }
        
        return nil
    }
    
}

protocol CulturalPracticeUpdateFactory {
    func makeCulturalPracticeByUpdate(_ culturalPractice: CulturalPractice?, _ elementUIData: ElementUIData) -> CulturalPractice?
}
