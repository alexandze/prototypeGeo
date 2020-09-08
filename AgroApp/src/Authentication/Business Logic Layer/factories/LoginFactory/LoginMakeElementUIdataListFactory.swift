//
//  LoginMakeElementUIdataListFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-07.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class LoginMakeElementUIdataListFactoryImpl: LoginMakeElementUIdataListFactory {
    
    let elementUIDataFactory: ElementUIDataFactory
    
    init(elementUIDataFactory: ElementUIDataFactory = ElementUIDataFactoryImpl()) {
        self.elementUIDataFactory = elementUIDataFactory
    }
    
    func makeElementUIDataListByLogin(_ login: Login) -> [ElementUIData] {
        Util.getMirrorChildrenOfTValue(login)
            .map(mapMirrorChildToInputElement(login))
            .filter(Util.filterTValueNotNil(ElementUIData.self))
            .map(Util.mapUnwrapTValue(ElementUIData.self))
    }
    
    func makeElementUIDataList() -> [ElementUIData] {
        let login = Login()
        return makeElementUIDataListByLogin(login)
    }
    
    private func mapMirrorChildToInputElement(_ login: Login) -> (Mirror.Child) -> ElementUIData? {
    { (child: Mirror.Child) -> ElementUIData? in
        guard let label = child.label else { return nil }
        
        switch label  {
        case EmailInputValue.getTypeValue():
            return self.elementUIDataFactory.makeElementUIData(EmailInputValue.self, login.email)
        case PasswordInputValue.getTypeValue():
            return self.elementUIDataFactory.makeElementUIData(PasswordInputValue.self, login.password)
        default:
            return nil
        }
        }
    }
}

protocol LoginMakeElementUIdataListFactory {
    func makeElementUIDataList() -> [ElementUIData]
    func makeElementUIDataListByLogin(_ login: Login) -> [ElementUIData]
}
