//
//  EnterpriseMakeElementUIDataListFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-31.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class EnterpriseMakeElementUIDataListFactoryImpl: EnterpriseMakeElementUIDataListFactory {
    let elementUIDataFactory: ElementUIDataFactory
    
    init(elementUIDataFactory: ElementUIDataFactory = ElementUIDataFactoryImpl()) {
        self.elementUIDataFactory = elementUIDataFactory
    }
    
    func makeElementUIdataListByEnterprise(_ enterprise: Enterprise) -> [ElementUIData] {
        Util.getMirrorChildrenOfTValue(enterprise)
            .map(mapMirrorChildrenToElementUIData(enterprise))
            .filter(Util.filterTValueNotNil(ElementUIData.self))
            .map(Util.mapUnwrapTValue(ElementUIData.self))
    }
    
    func makeElementUIDataList() -> [ElementUIData] {
        let enterprise = Enterprise()
        return makeElementUIdataListByEnterprise(enterprise)
    }
    
    func makeNimInputElementWithRemoveButton(_ number: Int) -> ElementUIData {
        elementUIDataFactory.makeInputElementWithRemoveButton(NimInputValue.self, number)
    }
    
    func makeNimInputElementWithRemoveButton(_ nimInputValue: NimInputValue, _ number: Int) -> ElementUIData {
        elementUIDataFactory.makeInputElementWithRemoveButton(NimInputValue.self, nimInputValue, number)
    }
    
    private func mapMirrorChildrenToElementUIData(_ enterprise: Enterprise) -> (Mirror.Child) -> ElementUIData? {
    {[weak self] (child: Mirror.Child) -> ElementUIData? in
        guard let self = self,
            let label = child.label else { return nil }
        
        switch label {
        case NimInputValue.getTypeValue():
            return self.elementUIDataFactory.makeElementUIData(NimInputValue.self, enterprise.nim, 0)
        default:
            return nil
        }
        }
    }
}

protocol EnterpriseMakeElementUIDataListFactory {
    func makeElementUIdataListByEnterprise(_ enterprise: Enterprise) -> [ElementUIData]
    func makeElementUIDataList() -> [ElementUIData]
    func makeNimInputElementWithRemoveButton(_ number: Int) -> ElementUIData
    func makeNimInputElementWithRemoveButton(_ nimInputValue: NimInputValue, _ number: Int) -> ElementUIData
}
