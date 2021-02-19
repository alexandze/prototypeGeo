//
//  HandlerGetLoginElementUIDataList.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-07.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension LoginHandler {
    class HandlerGetLoginElementUIDataList: HandlerReducer {
        let loginService: LoginService
        
        init(loginService: LoginService = LoginServiceImpl()) {
            self.loginService = loginService
        }
        
        func handle(action: LoginAction.GetElementUIDataListAction, _ state: LoginState) -> LoginState {
            let util = UtilHandlerGetLoginElementUIDataList(state: state)
            
            return (
                makeElementUIDataList(util: ) >>>
                    convertElementUIDataListToObservableWrapper(util: ) >>>
                    newState(util:)
            )(util) ?? state
        }
        
        private func makeElementUIDataList(util: UtilHandlerGetLoginElementUIDataList?) -> UtilHandlerGetLoginElementUIDataList? {
            guard var newUtil = util else {
                return nil
            }
            
            newUtil.newElementUIDataList = loginService.makeElementUIDataList()
            return newUtil
        }
        
        private func convertElementUIDataListToObservableWrapper(util: UtilHandlerGetLoginElementUIDataList?) -> UtilHandlerGetLoginElementUIDataList? {
            guard var newUtil = util,
                let elementUIDataList = newUtil.newElementUIDataList
                else { return nil }
            
            newUtil.newElementUIDataObservableList = convertElementUIDataListToObservable(elementUIDataList)
            return newUtil
        }
        
        private func newState(util: UtilHandlerGetLoginElementUIDataList?) -> LoginState? {
            guard let newUtil = util,
                let elementUIDataObservableList = newUtil.newElementUIDataObservableList
            else { return nil }
            
            return newUtil.state.changeValues(
                elementUIDataListObservable: elementUIDataObservableList,
                actionResponse: .getElementUIDataListActionResponse
            )
        }
        
        private func convertElementUIDataListToObservable(_ elementUIDataList: [ElementUIData]) -> [ElementUIDataObservable] {
            elementUIDataList
                .map { ($0 as? InputElement)?.toInputElementObservable() }
                .filter(Util.filterTValueNotNil(InputElementObservable.self))
                .map(Util.mapUnwrapTValue(InputElementObservable.self))
        }
    }
    
    private struct UtilHandlerGetLoginElementUIDataList {
        let state: LoginState
        var newElementUIDataList: [ElementUIData]?
        var newElementUIDataObservableList: [ElementUIDataObservable]?
    }
}
