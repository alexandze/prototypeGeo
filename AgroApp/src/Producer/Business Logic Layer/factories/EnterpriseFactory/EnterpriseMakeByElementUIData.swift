//
//  EnterpriseMakeByElementUIData.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-31.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class EnterpriseMakeByElementUIDataImpl: EnterpriseMakeByElementUIData {
    
    func makeEnterprise(_ enterprise: Enterprise, withElement elementUIData: ElementUIData) -> Enterprise {
        var copyEnterprise = enterprise
        
        if let inputElementData = elementUIData as? InputElement {
            copyEnterprise = makeEnterprise(copyEnterprise, withElement: inputElementData)
            return copyEnterprise
        }
        
        if let inputElementWithRemoveButton = elementUIData as? InputElementWithRemoveButton {
            copyEnterprise = makeEnterprise(copyEnterprise, withElement: inputElementWithRemoveButton)
            return copyEnterprise
        }
        
        return copyEnterprise
    }
    
    func makeEnterpriseByElementUIData(_ elementUIdata: ElementUIData) -> Enterprise {
        makeEnterprise(Enterprise(), withElement: elementUIdata)
    }
    
    private func makeEnterprise(_ enterprise: Enterprise, withElement inputElementData: InputElement) -> Enterprise {
        guard let typeValue = inputElementData.typeValue else {
            return enterprise
        }
        
        var copyEnterprise = enterprise
        
        switch typeValue {
        case NimInputValue.getTypeValue():
            copyEnterprise.nim = NimInputValue.make(value: inputElementData.value) as? NimInputValue
        default:
            break
        }
        
        return copyEnterprise
    }
    
    private func makeEnterprise(_ enterprise: Enterprise, withElement inputElementWithRemoveButton: InputElementWithRemoveButton) -> Enterprise {
        guard let typeValue = inputElementWithRemoveButton.typeValue else {
            return enterprise
        }
        
        var copyEnterprise = enterprise
        
        switch typeValue {
        case NimInputValue.getTypeValue():
            copyEnterprise.nim = NimInputValue.make(value: inputElementWithRemoveButton.value) as? NimInputValue
        default:
            break
        }
        
        return copyEnterprise
    }
}

protocol EnterpriseMakeByElementUIData {
    func makeEnterprise(_ enterprise: Enterprise, withElement elementUIData: ElementUIData) -> Enterprise
    func makeEnterpriseByElementUIData(_ elementUIdata: ElementUIData) -> Enterprise
    
}
