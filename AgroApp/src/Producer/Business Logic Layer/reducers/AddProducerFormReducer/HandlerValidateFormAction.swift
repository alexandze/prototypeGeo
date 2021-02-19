//
//  HandlerValidateFormAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-17.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension AddProducerFormReducerHandler {
    class HandlerValidateFormAction: HandlerReducer {

        let helperAddProducerFormHandler: HelperAddProducerFormReducerHandler
        let producerService: ProducerService
        let enterpriseService: EnterpriseService
        
        init(
            helperAddProducerFormHandler: HelperAddProducerFormReducerHandler = HelperAddProducerFormReducerHandlerImpl(),
            producerService: ProducerService = ProducerServiceImpl(),
            enterpriseService: EnterpriseService = EnterpriseServiceImpl()
        ) {
            self.helperAddProducerFormHandler = helperAddProducerFormHandler
            self.producerService = producerService
            self.enterpriseService = enterpriseService
        }

        func handle(action: AddProducerFormAction.ValidateFormAction, _ state: AddProducerFormState) -> AddProducerFormState {
            let util = UtilHandlerValidateFormAction(state: state, helperAddProducerFormHandler: helperAddProducerFormHandler)

            return (
                filterElementUIDataRequired(util:) >>>
                    checkIfAllInputElementIsValid(util:) >>>
                    makeProducerByElementWrapper(util: ) >>>
                    makeNewEnterpriseListWrapper(util: ) >>>
                    makeNimSelectValueWrapper(util: ) >>>
                    setEnterpriseListOfProducerWrapper(util: ) >>>
                    newState(util:)
            )(util) ?? state
        }

        private func filterElementUIDataRequired(
            util: UtilHandlerValidateFormAction?
        ) -> UtilHandlerValidateFormAction? {
            guard var newUtil = util else { return nil }

            guard let elementUIDataList = newUtil.state.elementUIDataObservableList else {
                newUtil.isAllInputElementIsValid = false
                return newUtil
            }

            newUtil.elementUIDataRequiredList = newUtil.helperAddProducerFormHandler
                .filterElementUIDataRequired(elementUIDataList: elementUIDataList)

            return newUtil
        }

        private func checkIfAllInputElementIsValid(
            util: UtilHandlerValidateFormAction?
        ) -> UtilHandlerValidateFormAction? {
            guard var newUtil = util else { return nil }

            guard let elementUIDataRequiredList = newUtil.elementUIDataRequiredList, !elementUIDataRequiredList.isEmpty else {
                newUtil.isAllInputElementIsValid = false
                return newUtil
            }

            newUtil.isAllInputElementIsValid = newUtil.helperAddProducerFormHandler
                .checkIfAllInputElementRequiredIsValid(elementUIDataRequiredList: elementUIDataRequiredList)

            return newUtil
        }
        
        private func makeProducerByElementWrapper(util: UtilHandlerValidateFormAction?) -> UtilHandlerValidateFormAction? {
            guard var newUtil = util,
                let elementUIDataObservableList = newUtil.state.elementUIDataObservableList else {
                    return nil
            }
            
            guard let isAllInputElementIsValid = newUtil.isAllInputElementIsValid, isAllInputElementIsValid else {
                return newUtil
            }
            
            newUtil.newProducer = makeNewProducer(Producer(), elementUIDataListObservable: elementUIDataObservableList)
            return newUtil
        }
        
        private func makeNewProducer(_ producer: Producer, elementUIDataListObservable: [ElementUIDataObservable]) -> Producer {
            var newProducer = producer
            
            elementUIDataListObservable.map {
                ($0 as? InputElementObservable)?.toInputElement() }
                .filter(Util.filterTValueNotNil(InputElement.self))
                .map(Util.mapUnwrapTValue(InputElement.self))
                .forEach { inputElement in
                    newProducer = producerService.makeProducer(newProducer, withElement: inputElement)
            }
            
            return newProducer
        }
        
        private func makeNewEnterpriseListWrapper(util: UtilHandlerValidateFormAction?) -> UtilHandlerValidateFormAction? {
            guard var newUtil = util,
                let elementUIDataObservableList = newUtil.state.elementUIDataObservableList else {
                    return nil
            }
            
            guard let isAllInputElementIsValid = newUtil.isAllInputElementIsValid, isAllInputElementIsValid else {
                return newUtil
            }
            
            newUtil.newEnterpriseList = makeNewEnterpriseListbyElementList(elementUIDataObservableList)
            return newUtil
        }
        
        private func makeNewEnterpriseListbyElementList(_ elementUIDataListObservable: [ElementUIDataObservable]) -> [Enterprise] {
            let inputElementList = elementUIDataListObservable
                .map { ($0 as? InputElementObservable)?.toInputElement() }
                .filter(Util.filterTValueNotNil(InputElement.self))
                .map(Util.mapUnwrapTValue(InputElement.self))
                .filter { $0.typeValue == NimInputValue.getTypeValue() }
            
            let inputElementWithRemoveButton = elementUIDataListObservable
                .map { ($0 as? InputElementWithRemoveButtonObservable)?.toInputElementWithRemoveButton() }
                .filter(Util.filterTValueNotNil(InputElementWithRemoveButton.self))
                .map(Util.mapUnwrapTValue(InputElementWithRemoveButton.self))
                .filter { $0.typeValue == NimInputValue.getTypeValue() }
            
            let enterpriseList1 = inputElementList.map {
                enterpriseService.makeEnterprise(Enterprise(), withElement: $0)
            }
            
            let enterpriseList2 = inputElementWithRemoveButton.map {
                enterpriseService.makeEnterprise(Enterprise(), withElement: $0)
            }
            
            return enterpriseList1 + enterpriseList2
        }
        
        private func makeNimSelectValueWrapper(util: UtilHandlerValidateFormAction?) -> UtilHandlerValidateFormAction? {
            guard var newUtil = util else {
                return nil
            }
            
            guard let isAllInputElementIsValid = newUtil.isAllInputElementIsValid, isAllInputElementIsValid else {
                return newUtil
            }
            
            guard let newEnterpriseList = newUtil.newEnterpriseList else {
                return newUtil
            }
            
            newUtil.newNimSelectValue = makeNimSelectValueByEnterpriseList(newEnterpriseList)
            return newUtil
        }
        
        private func makeNimSelectValueByEnterpriseList(_ enterpriseList: [Enterprise]) -> NimSelectValue? {
            enterpriseService.makeNimSelectValueByEnterpriseList(enterpriseList)
        }
        
        private func setEnterpriseListOfProducerWrapper(util: UtilHandlerValidateFormAction?) -> UtilHandlerValidateFormAction? {
            guard var newUtil = util else {
                return nil
            }
            
            guard let isAllInputElementIsValid = newUtil.isAllInputElementIsValid, isAllInputElementIsValid else {
                return newUtil
            }
            
            guard let enterpriseList = newUtil.newEnterpriseList, let producer = newUtil.newProducer else {
                return newUtil
            }
            
            newUtil.newProducer = setEnterpriseList(enterpriseList, ofProducer: producer)
            return newUtil
        }
        
        private func setEnterpriseList(_ enterpriseList: [Enterprise], ofProducer producer: Producer) -> Producer {
            var copyProducer = producer
            copyProducer.enterprises = enterpriseList
            return copyProducer
        }

        private func newState(util: UtilHandlerValidateFormAction?) -> AddProducerFormState? {
            guard let newUtil = util,
                let isAllInputElementIsValid = newUtil.isAllInputElementIsValid else {
                return nil
            }
            
            return newUtil.state
                .changeValues(
                    producer: newUtil.newProducer,
                    enterpriseList: newUtil.newEnterpriseList,
                    responseAction: .validateFormActionResponse(
                        isAllInputElementRequiredIsValid: isAllInputElementIsValid,
                        nimSelectValue: newUtil.newNimSelectValue
                    )
            )
        }

    }

    private struct UtilHandlerValidateFormAction {
        var state: AddProducerFormState
        var helperAddProducerFormHandler: HelperAddProducerFormReducerHandler
        var elementUIDataRequiredList: [ElementUIDataObservable]?
        var isAllInputElementIsValid: Bool?
        var newProducer: Producer?
        var newEnterpriseList: [Enterprise]?
        var newNimSelectValue: NimSelectValue?
    }
}
