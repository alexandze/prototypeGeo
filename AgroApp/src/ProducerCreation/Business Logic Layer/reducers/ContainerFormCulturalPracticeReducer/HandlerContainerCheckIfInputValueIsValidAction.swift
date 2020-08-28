//
//  HandlerCheckIfInputValueIsValidAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension ContainerFormCulturalPracticeHandler {
    class HandlerCheckIfInputValueIsValidAction: HandlerReducer {
        func handle(
            action: ContainerFormCulturalPracticeAction.CheckIfInputValueIsValidAction,
            _ state: ContainerFormCulturalPracticeState
        ) -> ContainerFormCulturalPracticeState {
            let util = UtilHandlerCheckIfInputValueIsValidAction(
                state: state,
                idElementUIData: action.id,
                valueElementUIData: action.value
            )
            
            return (
                findIndexElementUIData(util: ) >>>
                    checkIfValueIsValid(util:) >>>
                    newState(util:)
                )(util) ?? state
            
        }
        
        private func findIndexElementUIData(util: UtilHandlerCheckIfInputValueIsValidAction?) -> UtilHandlerCheckIfInputValueIsValidAction? {
            guard var newUtil = util,
                let elementUIDataObservableList = newUtil.state.elementUIDataObservableList else {
                    return nil
            }
            
            let indexElementUIDataOp = elementUIDataObservableList.firstIndex { $0.id == newUtil.idElementUIData }
            guard let indexElementUIData = indexElementUIDataOp else { return nil }
            newUtil.indexElementUIData = indexElementUIData
            return newUtil
        }
        
        private func checkIfValueIsValid(util: UtilHandlerCheckIfInputValueIsValidAction?) -> UtilHandlerCheckIfInputValueIsValidAction? {
            guard var newUtil = util,
                var newElementUIDataObservableList = newUtil.state.elementUIDataObservableList,
                let indexElementUIData = newUtil.indexElementUIData,
                let inputElementObservable = newElementUIDataObservableList[indexElementUIData].toInputElementObservable() else {
                    return nil
            }
            
            inputElementObservable.isValid = inputElementObservable.isInputValid()
            newElementUIDataObservableList[indexElementUIData] = inputElementObservable
            newUtil.newElementUIDataObservableList = newElementUIDataObservableList
            return newUtil
        }
        
        private func newState(util: UtilHandlerCheckIfInputValueIsValidAction?) -> ContainerFormCulturalPracticeState? {
            guard let newUtil = util,
                let newElementUIDataObservableList = newUtil.newElementUIDataObservableList,
                let indexElementUIData = newUtil.indexElementUIData else {
                    return nil
            }
            
            return newUtil.state.changeValue(
                elementUIDataObservableList: newElementUIDataObservableList,
                actionResponse: .checkIfInputValueIsValidActionResponse(indexElementUIData: indexElementUIData)
            )
        }
    }
    
    private struct UtilHandlerCheckIfInputValueIsValidAction {
        let state: ContainerFormCulturalPracticeState
        let idElementUIData: UUID
        let valueElementUIData: String
        var indexElementUIData: Int?
        var newElementUIDataObservableList: [ElementUIDataObservable]?
    }
}
