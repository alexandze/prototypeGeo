//
//  HandlerCloseContainerFormWithSaveAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension ContainerFormCulturalPracticeHandler {
    class HandlerCloseContainerFormWithSaveAction: HandlerReducer {
        func handle(
            action: ContainerFormCulturalPracticeAction.CloseContainerFormWithSaveAction,
            _ state: ContainerFormCulturalPracticeState
        ) -> ContainerFormCulturalPracticeState {
            let util = UtilHandlerCloseContainerFormWithSaveAction(state: state)
            
            return (
                checkIfAllInputValueIsValid(util: ) >>>
                    convertElementUIDataObservableToElementUIData(util: ) >>>
                    makeSectionElementUIData(util: ) >>>
                    newState(util: )
            )(util) ?? state
        }
        
        private func checkIfAllInputValueIsValid(util: UtilHandlerCloseContainerFormWithSaveAction?) -> UtilHandlerCloseContainerFormWithSaveAction? {
            guard let newUtil = util,
            let elementUIDataObservableList = newUtil.state.elementUIDataObservableList else {
                return nil
            }
            
            let indexOfFirstElementInvalidOp = elementUIDataObservableList.firstIndex { elementUIDataObservable in
                if let inputElementObservable = elementUIDataObservable.toInputElementObservable() {
                    inputElementObservable.isValid = inputElementObservable.isInputValid()
                    return !inputElementObservable.isValid
                }
                
                return false
            }
            
            return indexOfFirstElementInvalidOp == nil ? newUtil : nil
        }
        
        private func convertElementUIDataObservableToElementUIData(util: UtilHandlerCloseContainerFormWithSaveAction?) -> UtilHandlerCloseContainerFormWithSaveAction? {
            guard var newUtil = util,
                let elementUIDataObservableList = newUtil.state.elementUIDataObservableList else {
                    return nil
            }
            
            newUtil.newElementUIDataList = elementUIDataObservableList.map { (elementUIDataObservable: ElementUIDataObservable) -> ElementUIData? in
                switch elementUIDataObservable {
                case let inputElementObservable as InputElementObservable:
                    return inputElementObservable.toInputElement()
                case let selectElement as SelectElementObservable:
                    return selectElement.toSelectElement()
                default:
                    return nil
                }
            }.filter { $0 != nil }
                .map { $0! }
            
            return newUtil
        }
        
        private func makeSectionElementUIData(util: UtilHandlerCloseContainerFormWithSaveAction?) -> UtilHandlerCloseContainerFormWithSaveAction? {
            guard var newUtil = util,
                let newElementUIDataList = newUtil.newElementUIDataList,
                var section = newUtil.state.section else {
                    return nil
            }
            
            section.rowData = newElementUIDataList
            newUtil.newSection = section
            return newUtil
        }
        
        private func newState(util: UtilHandlerCloseContainerFormWithSaveAction?) -> ContainerFormCulturalPracticeState? {
            guard let newUtil = util,
                let newSection = newUtil.newSection else {
                    return nil
            }
            
            return newUtil.state.changeValue(
                section: newSection,
                isFormValid: true,
                actionResponse: .closeContainerFormWithSaveActionResponse
            )
        }
    }
    
    private struct UtilHandlerCloseContainerFormWithSaveAction {
        let state: ContainerFormCulturalPracticeState
        var newElementUIDataList: [ElementUIData]?
        var newSection: Section<ElementUIData>?
    }
}
