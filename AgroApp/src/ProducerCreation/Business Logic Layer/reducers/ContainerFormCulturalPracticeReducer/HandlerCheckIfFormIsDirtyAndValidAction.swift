//
//  HandlerCheckIfFormIsDirtyAndValidAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension ContainerFormCulturalPracticeHandler {
    class HandlerCheckIfFormIsDirtyAndValidAction: HandlerReducer {
        func handle(
            action: ContainerFormCulturalPracticeAction.CheckIfFormIsDirtyAndValidAction,
            _ state: ContainerFormCulturalPracticeState
        ) -> ContainerFormCulturalPracticeState {
            
        }
        
        private func isAllInputElementValid(util: UtilHandlerCheckIfFormIsDirtyAndValidAction?) -> UtilHandlerCheckIfFormIsDirtyAndValidAction? {
            guard var newUtil = util,
                let elementUIDataObservableList = newUtil.state.elementUIDataObservableList else {
                return nil
            }
            
            let indexFirstInvalidValue = elementUIDataObservableList.firstIndex { elementUIDataObservable in
                if let inputElementObservable = elementUIDataObservable.toInputElementObservable() {
                    inputElementObservable.isValid = inputElementObservable.isInputValid()
                    return !inputElementObservable.isValid
                }
                
                return false
            }
            
            newUtil.isAllInputElementValid = indexFirstInvalidValue == nil
            return newUtil
        }
        
        private func hasDirtyElement(util: UtilHandlerCheckIfFormIsDirtyAndValidAction?) -> UtilHandlerCheckIfFormIsDirtyAndValidAction? {
            guard var newUtil = util,
                let elementUIDataObservable = newUtil.state.elementUIDataObservableList,
                let elementUIDataList = newUtil.state.section?.rowData
            else {
                return nil
            }
            
            guard let isAllInputElementValid = newUtil.isAllInputElementValid, isAllInputElementValid else {
                newUtil.isPrintAlert = false
                return newUtil
            }
            
            let firstElementObservableDirty = elementUIDataObservable.first { elementUIDataObservable in
                if let inputElementObservable = elementUIDataObservable.toInputElementObservable(),
                    let inputElement = self.findElementUIDataById(inputElementObservable.id, elementUIDataList: elementUIDataList) as? InputElement {
                    return inputElementObservable.value != inputElement.value
                }
                
                if let selectElementObservable = elementUIDataObservable.toSelectElementObservable(),
                    let selectElement = self.findElementUIDataById(selectElementObservable.id, elementUIDataList: elementUIDataList) as? SelectElement {
                    return selectElementObservable.rawValue != selectElement.rawValue
                }
                
                return false
            }
            
            newUtil.isPrintAlert = firstElementObservableDirty != nil
            return newUtil
        }
        
        private func newState(util: UtilHandlerCheckIfFormIsDirtyAndValidAction?) -> ContainerFormCulturalPracticeState? {
            guard let newUtil = util,
                let isPrintAlert = newUtil.isPrintAlert else {
                return nil
            }
            
            return newUtil.state.changeValue(actionResponse: .checkIfFormIsDirtyAndValidAction(isPrintAlert: isPrintAlert))
        }
        
        private func findElementUIDataById(_ id: UUID, elementUIDataList: [ElementUIData]) -> ElementUIData? {
            elementUIDataList.first { elementUIData in
                elementUIData.id == id
            }
        }
        
    }
    
    private struct UtilHandlerCheckIfFormIsDirtyAndValidAction {
        let state: ContainerFormCulturalPracticeState
        var isAllInputElementValid: Bool?
        var isPrintAlert: Bool?
        
    }
}
