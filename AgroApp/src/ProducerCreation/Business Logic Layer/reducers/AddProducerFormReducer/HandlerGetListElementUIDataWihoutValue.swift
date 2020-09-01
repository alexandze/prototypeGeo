//
//  HandlerGetListElementUIDataWihoutValue.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-09.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
extension AddProducerFormReducerHandler {
    class HandlerGetAllElementUIDataWihoutValue: HandlerReducer {
        let addProducerFormService: AddProducerFormService
        let producerService: ProducerService
        let enterpriseService: EnterpriseService

        init(
            addProducerFormService: AddProducerFormService = AddProducerFormServiceImpl(),
            producerService: ProducerService = ProducerServiceImpl(),
            enterpriseService: EnterpriseService = EnterpriseServiceImpl()
        ) {
            self.addProducerFormService = addProducerFormService
            self.producerService = producerService
            self.enterpriseService = enterpriseService
        }

        func handle(
            action: AddProducerFormAction.GetAllElementUIDataWithoutValueAction,
            _ state: AddProducerFormState
        ) -> AddProducerFormState {
            let util = UtilHandlerGetListElementUIData(
                state: state
            )

            return (
                makeProducerElementUIDataListObservable(util: ) >>>
                    makeNimInputIfEnterpriseListIsNil(util: ) >>>
                    makeEnterpriseElementUIDataListObservable(util: ) >>>
                    makeAddButton(util: ) >>>
                    // TODO restaurer les elements si pas empty
                    newState(util:)
                )(util) ?? state
        }
        
        private func makeProducerElementUIDataListObservable(util: UtilHandlerGetListElementUIData?) -> UtilHandlerGetListElementUIData? {
            guard var newUtil = util else {
                return nil
            }
            
            var elementUIDataList = [ElementUIData]()
            
            if let producer = newUtil.state.producer {
                elementUIDataList = producerService
                    .makeElementUIDataListByProducer(producer)
            }
            
            if newUtil.state.producer == nil {
                elementUIDataList = producerService.makeElementUIDataList()
            }
            
            newUtil.producerElementUIDataListObservable = elementUIDataList
                .map { ($0 as? InputElement)?.toInputElementObservable()  }
                .filter(Util.filterTValueNotNil(InputElementObservable.self))
                .map(Util.mapUnwrapTValue(InputElementObservable.self))
            
            return newUtil
        }
        
        private func makeNimInputIfEnterpriseListIsNil(util: UtilHandlerGetListElementUIData?) -> UtilHandlerGetListElementUIData? {
            guard var newUtil = util else {
                return nil
            }
            
            guard newUtil.state.enterpriseList == nil else {
                return newUtil
            }
            
            newUtil.enterpriseElementUIDataListObservable = enterpriseService
                .makeElementUIDataList()
                .map { ($0 as? InputElement)?.toInputElementObservable() }
                .filter(Util.filterTValueNotNil(InputElementObservable.self))
                .map(Util.mapUnwrapTValue(InputElementObservable.self))
            
            return newUtil
        }
        
        private func makeEnterpriseElementUIDataListObservable(util: UtilHandlerGetListElementUIData?) -> UtilHandlerGetListElementUIData? {
            guard var newUtil = util else {
                return nil
            }
            
            guard let enterpriseList = newUtil.state.enterpriseList else {
                return newUtil
            }
            
            var elementUIDataList = [ElementUIDataObservable?]()
            var hasNilNimInputValue = false
            
            elementUIDataList = (0..<enterpriseList.count).flatMap { (index: Int) -> [ElementUIDataObservable?] in
                if index == 0 {
                    return enterpriseService.makeElementUIdataListByEnterprise(enterpriseList[index])
                        .map {($0 as? InputElement)?.toInputElementObservable() }
                        .filter(Util.filterTValueNotNil(InputElementObservable.self))
                        .map(Util.mapUnwrapTValue(InputElementObservable.self))
                }
                
                if let nimInputValue = enterpriseList[index].nim, !hasNilNimInputValue {
                    return [ enterpriseService.makeNimInputElementWithRemoveButton(nimInputValue, index) ]
                        .map { ($0 as? InputElementWithRemoveButton)?.toInputElementWithRemoveButtonObservable() }
                        .filter(Util.filterTValueNotNil(InputElementWithRemoveButtonObservable.self))
                        .map(Util.mapUnwrapTValue(InputElementWithRemoveButtonObservable.self))
                }
                
                if enterpriseList[index].nim == nil {
                    hasNilNimInputValue = true
                    return [nil]
                }
                
                return [nil]
            }
            
            newUtil.enterpriseElementUIDataListObservable = elementUIDataList
                .filter(Util.filterTValueNotNil(ElementUIDataObservable.self))
                .map(Util.mapUnwrapTValue(ElementUIDataObservable.self))
            
            return newUtil
        }
        
        private func makeAddButton(util: UtilHandlerGetListElementUIData?) -> UtilHandlerGetListElementUIData? {
            guard var newUtil = util
                else { return nil }
            
            newUtil.addButtonElementObservalble = addProducerFormService.getAddButtonElementObservable(isEnabled: true)
            return newUtil
        }
        
        private func newState(
            util: UtilHandlerGetListElementUIData?
        ) -> AddProducerFormState? {
            guard let newUtil = util,
                let addButtonElementObservable = newUtil.addButtonElementObservalble,
                let producerElementUIDataListObservable = newUtil.producerElementUIDataListObservable,
                let enterpriseElementUIDataListObservable = newUtil.enterpriseElementUIDataListObservable
                else { return nil }

            return newUtil.state.changeValues(
                elementUIDataObservableList: producerElementUIDataListObservable + enterpriseElementUIDataListObservable,
                addButtonElementObservable: addButtonElementObservable,
                responseAction: .getListElementUIDataWihoutValueResponse
            )
        }
    }

    private struct UtilHandlerGetListElementUIData {
        var state: AddProducerFormState
        var producerElementUIDataListObservable: [ElementUIDataObservable]?
        var enterpriseElementUIDataListObservable: [ElementUIDataObservable]?
        var addButtonElementObservalble: ButtonElementObservable?
    }
}
