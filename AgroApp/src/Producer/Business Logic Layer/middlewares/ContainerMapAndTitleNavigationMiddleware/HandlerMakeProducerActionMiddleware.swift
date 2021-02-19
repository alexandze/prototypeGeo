//
//  HandlerMakeProducerActionMiddleware.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-20.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift

extension ContainerMapAndTitleNavigationMiddleware {
    class HandlerMakeProducerActionMiddleware: HanderMiddleware {
        func handle(
            _ action: ContainerMapAndTitleNavigationAction.MakeProducerAction,
            _ state: AppState
        ) -> Action {
            let util = UtilHandlerMakeProducerActionMiddleware(appState: state)
            
            return (
                getDataForAddToProducerFromAppStateWrapper(util: ) >>>
                indexFieldListOnDictionaryWrapper(util: ) >>>
                initFieldListOfForEachEnterpriseWrapper(util:) >>>
                setNewEnterpriseListOfProducerWrapper(util: ) >>>
                makeProducerAction(util: )
            )(util)
        }
        
        // TODO verifier si tout les valeurs de culturalPractice des field
        // verifier les valeurs des field
        // verifier les valeurs des entreprises
        private func checkIfAllValueIsValidWrapper(util: UtilHandlerMakeProducerActionMiddleware?) -> UtilHandlerMakeProducerActionMiddleware? {
            return nil
        }
        
        private func getDataForAddToProducerFromAppStateWrapper(util: UtilHandlerMakeProducerActionMiddleware?) -> UtilHandlerMakeProducerActionMiddleware? {
            guard var newUtil = util,
                let tupleProducerField = getDataForAddToProducerFromAppState(newUtil.appState) else {
                return nil
            }
            
            newUtil.newProducer = tupleProducerField.0
            newUtil.newFieldList = tupleProducerField.1
            return newUtil
        }
        
        private func getDataForAddToProducerFromAppState(_ appState: AppState) -> (Producer, [Field])? {
            guard let producer = appState.addProducerFormState.producer,
                let fieldList = appState.fieldListState.fieldList else {
                    return nil
            }
            
            return (producer, fieldList)
        }
        
        private func indexFieldListOnDictionaryWrapper(util: UtilHandlerMakeProducerActionMiddleware?) -> UtilHandlerMakeProducerActionMiddleware? {
            guard var newUtil = util, let fieldList = newUtil.newFieldList else {
                return nil
            }
            
            newUtil.newfieldDictionaryByNim = indexFieldListOnDictionary(fieldList)
            return newUtil
        }
        
        private func indexFieldListOnDictionary(_ fieldList: [Field]) -> [String:[Field]] {
            fieldList.reduce([String:[Field]]()) { dictionaryField, field in
                var copyDictionnary = dictionaryField
                guard let nimValue = field.nim?.getValue() else { return copyDictionnary }
                var fieldList = copyDictionnary[nimValue] ?? []
                fieldList.append(field)
                copyDictionnary[nimValue] = fieldList
                return copyDictionnary
            }
        }
        
        private func initFieldListOfForEachEnterpriseWrapper(util: UtilHandlerMakeProducerActionMiddleware?) -> UtilHandlerMakeProducerActionMiddleware? {
            guard var newUtil = util,
                let enterpriseList = newUtil.newProducer?.enterprises,
                let fieldDictionary = newUtil.newfieldDictionaryByNim else {
                return nil
            }
            
            newUtil.newEnterpriseList = initFieldListOfForEachEnterprise(enterpriseList, fieldDictionary)
            return newUtil
        }
        
        private func initFieldListOfForEachEnterprise(_ enterpriseList: [Enterprise], _ fieldDictionary: [String:[Field]]) -> [Enterprise] {
            enterpriseList.map { enterprise in
                guard let nim = enterprise.nim?.getValue(), let fieldList = fieldDictionary[nim] else {
                    return enterprise
                }
                
                var copyEnterprise = enterprise
                copyEnterprise.fields = fieldList
                return copyEnterprise
            }
        }
        
        private func setNewEnterpriseListOfProducerWrapper(util: UtilHandlerMakeProducerActionMiddleware?) -> UtilHandlerMakeProducerActionMiddleware? {
            guard var newUtil = util,
                let enterpriseList = newUtil.newEnterpriseList,
                let producer = newUtil.newProducer else {
                    return nil
            }
            
            newUtil.newProducer = setNewEnterpriseList(enterpriseList, ofProducer: producer)
            return newUtil
        }
        
        private func setNewEnterpriseList(_ enterpriseList: [Enterprise], ofProducer producer: Producer) -> Producer {
            var copyProducer = producer
            copyProducer.enterprises = enterpriseList
            return copyProducer
        }
        
        private func makeProducerAction(util: UtilHandlerMakeProducerActionMiddleware?) -> Action {
            guard let newProducer = util?.newProducer else {
                return ContainerMapAndTitleNavigationAction.MakeProducerFailureAction()
            }
            
            return ContainerMapAndTitleNavigationAction.MakeProducerSuccessAction(producer: newProducer)
        }
    }
    
    private struct UtilHandlerMakeProducerActionMiddleware {
        let appState: AppState
        var newProducer: Producer?
        var newFieldList: [Field]?
        var newfieldDictionaryByNim: [String:[Field]]?
        var newEnterpriseList: [Enterprise]?
    }
}
