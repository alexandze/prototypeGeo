//
//  HandlerAddNimInputElementAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-15.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension AddProducerFormReducerHandler {
    class HandlerAddNimInputElementAction: HandlerReducer {
        let addProducerFormService: AddProducerFormService
        let enterpriseService: EnterpriseService
        
        init(
            addProducerFormService: AddProducerFormService = AddProducerFormServiceImpl(),
            enterpriseService: EnterpriseService = EnterpriseServiceImpl()
        ) {
            self.addProducerFormService = addProducerFormService
            self.enterpriseService = enterpriseService
        }
        
        func handle(action: AddProducerFormAction.AddNimInputElementAction, _ state: AddProducerFormState) -> AddProducerFormState {
            let util = UtilHandlerAddNimInputElementAction(state: state, addProducerFormService: addProducerFormService)
            
            return (
                countNimInput(util:) >>>
                    checkIfMaxNim(util:) >>>
                    findIndexOfLastInputNim(util:) >>>
                    getNumberOfLastInputElementNim(util:) >>>
                    makeNewNimInputElementWithRemoveButton(util:) >>>
                    insertNewNimInputElement(util:) >>>
                    checkIfMaxNimAfterInsert(util:) >>>
                    getNewAddNimButtonElement(util:) >>>
                    newState(util:)
                )(util) ?? state
        }
        
        private func countNimInput(util: UtilHandlerAddNimInputElementAction?) -> UtilHandlerAddNimInputElementAction? {
            guard var newUtil = util,
                let elementUIDataListFromState = newUtil.state.elementUIDataObservableList else {
                    return nil
            }
            
            let titleNim = NimInputValue.getTitle()
            newUtil.nimCount = elementUIDataListFromState.filter { $0.title == titleNim }.count
            return newUtil
        }
        
        private func checkIfMaxNim(util: UtilHandlerAddNimInputElementAction?) -> UtilHandlerAddNimInputElementAction? {
            guard let newUtil = util,
                let nimCount = newUtil.nimCount,
                nimCount < newUtil.addProducerFormService.getMaxNim()
                else { return nil }
            
            return newUtil
        }
        
        private func findIndexOfLastInputNim(util: UtilHandlerAddNimInputElementAction?) -> UtilHandlerAddNimInputElementAction? {
            guard var newUtil = util,
                let elementUIDataListFromState = newUtil.state.elementUIDataObservableList else {
                    return nil
            }
            
            let indexOfLastInputNim = (0..<elementUIDataListFromState.count).reversed().firstIndex { index in
                return elementUIDataListFromState[index].title == NimInputValue.getTitle()
            }
            
            guard let indexFind = indexOfLastInputNim else {
                return nil
            }
            
            // reverse loop
            newUtil.indexOfLastInputNim = indexFind.base - 1
            return newUtil
        }
        
        private func getNumberOfLastInputElementNim(util: UtilHandlerAddNimInputElementAction?) -> UtilHandlerAddNimInputElementAction? {
            guard var newUtil = util,
                let indexOfLastInputElementNim = newUtil.indexOfLastInputNim,
                let elementUIDataListFromState = newUtil.state.elementUIDataObservableList
                else {
                    return nil
            }
            
            let number = (elementUIDataListFromState[indexOfLastInputElementNim] as? InputElementDataObservable)?.number
            
            guard let numberNotNil = number else {
                return nil
            }
            
            newUtil.numberOfLastInput = numberNotNil
            return newUtil
        }
        
        private func makeNewNimInputElementWithRemoveButton(util: UtilHandlerAddNimInputElementAction?) -> UtilHandlerAddNimInputElementAction? {
            guard var newUtil = util,
                let numberLastInput = newUtil.numberOfLastInput else {
                    return nil
            }
            
            let newInputElementWithRemove = enterpriseService.makeNimInputElementWithRemoveButton(numberLastInput + 1)
            
            newUtil.newInputElementWithRemove = (newInputElementWithRemove as? InputElementWithRemoveButton)?
                .toInputElementWithRemoveButtonObservable()
            
            return newUtil
        }
        
        private func insertNewNimInputElement(util: UtilHandlerAddNimInputElementAction?) -> UtilHandlerAddNimInputElementAction? {
            guard var newUtil = util,
                let newInputElementNim = newUtil.newInputElementWithRemove,
                var elementUIDataList = newUtil.state.elementUIDataObservableList,
                let indexOfLastInputNim = newUtil.indexOfLastInputNim
                else {
                    return nil
            }
            
            let indexInsertNewNimInput = indexOfLastInputNim + 1
            elementUIDataList.insert(newInputElementNim, at: indexInsertNewNimInput)
            newUtil.newElementUIDataObservableList = elementUIDataList
            newUtil.indexInsertNim = indexInsertNewNimInput
            return newUtil
        }
        
        private func checkIfMaxNimAfterInsert(util: UtilHandlerAddNimInputElementAction?) -> UtilHandlerAddNimInputElementAction? {
            guard var newUtil = util,
                let nimCountBeforeInsert = newUtil.nimCount else {
                    return nil
            }
            
            newUtil.isMaxNimAfterInsert = (nimCountBeforeInsert + 1) >= newUtil.addProducerFormService.getMaxNim()
            return newUtil
        }
        
        private func getNewAddNimButtonElement(util: UtilHandlerAddNimInputElementAction?) -> UtilHandlerAddNimInputElementAction? {
            guard var newUtil = util,
                let isMaxNimAfterInsert = newUtil.isMaxNimAfterInsert else {
                    return nil
            }
            
            newUtil.newAddButtonElement = newUtil.addProducerFormService.getAddButtonElementObservable(isEnabled: !isMaxNimAfterInsert)
            return newUtil
        }
        
        private func newState(util: UtilHandlerAddNimInputElementAction?) -> AddProducerFormState? {
            guard let newUtil = util,
                let newElementUIDataObservableList = newUtil.newElementUIDataObservableList,
                let indexInsertNewNimInput = newUtil.indexInsertNim,
                let newAddButtonElement = newUtil.newAddButtonElement else {
                    return nil
            }
            
            return newUtil.state.changeValues(
                elementUIDataObservableList: newElementUIDataObservableList,
                addButtonElementObservable: newAddButtonElement,
                responseAction: .addNimInputElementActionResponse(indexOfNewNimInputElement: indexInsertNewNimInput)
            )
        }
    }
    
    private struct UtilHandlerAddNimInputElementAction {
        let state: AddProducerFormState
        let addProducerFormService: AddProducerFormService
        var nimCount: Int?
        var newInputElementWithRemove: InputElementDataObservable?
        var indexOfLastInputNim: Int?
        var numberOfLastInput: Int?
        var newElementUIDataObservableList: [ElementUIDataObservable]?
        var isMaxNimAfterInsert: Bool?
        var indexInsertNim: Int?
        var newAddButtonElement: ButtonElementObservable?
    }
}
