//
//  EnterpriseService.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class EnterpriseServiceImpl: EnterpriseService {
    let enterpriseMakeElementUIDataListFactory: EnterpriseMakeElementUIDataListFactory
    let enterpriseMakeByElementUIData: EnterpriseMakeByElementUIData
    let enterpriseMakeNimSelectValue: EnterpriseMakeNimSelectValue
    
    init(
        enterpriseMakeElementUIDataListFactory: EnterpriseMakeElementUIDataListFactory = EnterpriseMakeElementUIDataListFactoryImpl(),
        enterpriseMakeByElementUIData: EnterpriseMakeByElementUIData = EnterpriseMakeByElementUIDataImpl(),
        enterpriseMakeNimSelectValue: EnterpriseMakeNimSelectValue = EnterpriseMakeNimSelectValueImpl()
    ) {
        self.enterpriseMakeElementUIDataListFactory = enterpriseMakeElementUIDataListFactory
        self.enterpriseMakeByElementUIData = enterpriseMakeByElementUIData
        self.enterpriseMakeNimSelectValue = enterpriseMakeNimSelectValue
    }
    
    func makeElementUIdataListByEnterprise(_ enterprise: Enterprise) -> [ElementUIData] {
        enterpriseMakeElementUIDataListFactory.makeElementUIdataListByEnterprise(enterprise)
    }
    
    func makeElementUIDataList() -> [ElementUIData] {
        enterpriseMakeElementUIDataListFactory.makeElementUIDataList()
    }
    
    func makeEnterprise(_ enterprise: Enterprise, withElement elementUIData: ElementUIData) -> Enterprise {
        enterpriseMakeByElementUIData.makeEnterprise(enterprise, withElement: elementUIData)
    }
    
    func makeEnterpriseByElementUIData(_ elementUIdata: ElementUIData) -> Enterprise {
        enterpriseMakeByElementUIData.makeEnterpriseByElementUIData(elementUIdata)
    }
    
    func makeNimSelectValueByEnterpriseList(_ enterpriseList: [Enterprise]) -> NimSelectValue? {
        enterpriseMakeNimSelectValue.makeNimSelectValueByEnterpriseList(enterpriseList)
    }
    
    func makeNimInputElementWithRemoveButton(_ number: Int) -> ElementUIData {
        enterpriseMakeElementUIDataListFactory.makeNimInputElementWithRemoveButton(number)
    }
    
    func makeNimInputElementWithRemoveButton(_ nimInputValue: NimInputValue, _ number: Int) -> ElementUIData {
        enterpriseMakeElementUIDataListFactory.makeNimInputElementWithRemoveButton(nimInputValue, number)
    }
}

protocol EnterpriseService {
    func makeElementUIdataListByEnterprise(_ enterprise: Enterprise) -> [ElementUIData]
    func makeElementUIDataList() -> [ElementUIData]
    func makeEnterprise(_ enterprise: Enterprise, withElement elementUIData: ElementUIData) -> Enterprise
    func makeEnterpriseByElementUIData(_ elementUIdata: ElementUIData) -> Enterprise
    func makeNimSelectValueByEnterpriseList(_ enterpriseList: [Enterprise]) -> NimSelectValue?
    func makeNimInputElementWithRemoveButton(_ number: Int) -> ElementUIData
    func makeNimInputElementWithRemoveButton(_ nimInputValue: NimInputValue, _ number: Int) -> ElementUIData
}
