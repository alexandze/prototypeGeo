//
//  HandlerUpdateCulturalPracticeElementAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-31.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift
extension CulturalPracticeFormReducerHandler {
    class HandlerUpdateCulturalPracticeElementAction: HandlerReducer {
        let culturalPracticeFactory: CulturalPracticeFactory
        
        init(culturalPracticeFactory: CulturalPracticeFactory = CulturalPracticeFactoryImpl()) {
            self.culturalPracticeFactory = culturalPracticeFactory
        }

        func handle(
            action: CulturalPracticeFormAction.UpdateCulturalPracticeElementAction,
            _ state: CulturalPracticeFormState
        ) -> CulturalPracticeFormState {

            let util = UtilUpdateCulturalPracticeElementAction(
                state: state,
                newSection: action.section,
                newField: action.field
            )
            
            // cherche l'index a metter a jour
            // mettre a jour l'index
            // mettre a jour la pratique culturelle par la section
            // mettre a jour le field avec la pratique culturelle
            
            return (
                findIndexSectionForUpdate(util: ) >>>
                    updataSectionList(util: ) >>>
                    updateCulturalPractice(util: ) >>>
                    updateField(util: ) >>>
                    newState(util: )
                )(util) ?? state.changeValues(responseAction: .notResponse)
        }
        
        private func findIndexSectionForUpdate(util: UtilUpdateCulturalPracticeElementAction?) -> UtilUpdateCulturalPracticeElementAction? {
            guard var newUtil = util,
                let sectionList = newUtil.state.sections else {
                return nil
            }
            
            let indexSectionFindOp = (0..<sectionList.count).firstIndex { index in
                sectionList[index].id == newUtil.newSection.id
            }
            
            guard let indexSectionFind = indexSectionFindOp else {
                return nil
            }
            
            newUtil.indexSectionPathFind = IndexPath(row: 0, section: indexSectionFind)
            return newUtil
        }
        
        private func updataSectionList(util: UtilUpdateCulturalPracticeElementAction?) -> UtilUpdateCulturalPracticeElementAction? {
            guard var newUtil = util,
                let sectionList = newUtil.state.sections,
                let indexPathSectionFind = newUtil.indexSectionPathFind
                else {
                return nil
            }
            
            var newSectionList = sectionList
            newSectionList[indexPathSectionFind.section] = newUtil.newSection
            newUtil.newSectionList = newSectionList
            return newUtil
        }
        
        private func updateCulturalPractice(util: UtilUpdateCulturalPracticeElementAction?) -> UtilUpdateCulturalPracticeElementAction? {
            guard var newUtil = util,
                let culturalPractice = newUtil.newField.culturalPratice
                else {
                    return nil
            }
            
            newUtil.newCulturalPractice = culturalPracticeFactory.makeCulturalPracticeByUpdate(culturalPractice, newUtil.newSection)
            
            guard newUtil.newCulturalPractice != nil else {
                return nil
            }
            
            return newUtil
        }
        
        private func updateField(util: UtilUpdateCulturalPracticeElementAction?) -> UtilUpdateCulturalPracticeElementAction? {
            guard var newUtil = util else { return nil }
            newUtil.newField.culturalPratice = newUtil.newCulturalPractice
            return newUtil
        }
        
        private func newState(util: UtilUpdateCulturalPracticeElementAction?) -> CulturalPracticeFormState? {
            guard let newUtil = util,
                let newSectionList = newUtil.newSectionList,
                let indexFind = newUtil.indexSectionPathFind
                else {
                    return nil
            }
            
            let isFinishCompletedCurrentContainer = newUtil.newSection.typeSection == ElementUIListData.TYPE_ELEMENT
                ? true
                : newUtil.state.isFinishCompletedLastDoseFumier
            
            return newUtil.state.changeValues(
                currentField: newUtil.newField,
                sections: newSectionList,
                isFinishCompletedCurrentContainer: isFinishCompletedCurrentContainer,
                responseAction: .updateElementResponse(indexPath: [indexFind])
            )
        }

        deinit {
            print("******* deinit HandlerUpdateCulturalPracticeElementAction ************")
        }
    }

    private struct UtilUpdateCulturalPracticeElementAction {
        var state: CulturalPracticeFormState
        var newSection: Section<ElementUIData>
        var newField: Field
        var indexSectionPathFind: IndexPath?
        var newSectionList: [Section<ElementUIData>]?
        var newCulturalPractice: CulturalPractice?
        
    }
}
