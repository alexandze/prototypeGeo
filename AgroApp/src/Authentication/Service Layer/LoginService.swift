//
//  LoginService.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-07.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class LoginServiceImpl: LoginService {
    let loginMakeElementUIdataListFactory: LoginMakeElementUIdataListFactory
    
    init(loginMakeElementUIdataListFactory: LoginMakeElementUIdataListFactory = LoginMakeElementUIdataListFactoryImpl()) {
        self.loginMakeElementUIdataListFactory = loginMakeElementUIdataListFactory
    }
    
    func makeElementUIDataList() -> [ElementUIData] {
        loginMakeElementUIdataListFactory.makeElementUIDataList()
    }
    
    func makeElementUIDataListByLogin(_ login: Login) -> [ElementUIData] {
        loginMakeElementUIdataListFactory.makeElementUIDataListByLogin(login)
    }
}

protocol LoginService {
    func makeElementUIDataList() -> [ElementUIData]
    func makeElementUIDataListByLogin(_ login: Login) -> [ElementUIData]
}
