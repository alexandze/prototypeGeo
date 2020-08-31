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
        let fieldService: FieldService

        init(
            culturalPracticeFactory: CulturalPracticeFactory = CulturalPracticeFactoryImpl(),
            fieldService: FieldService = FieldServiceImpl()
        ) {
            self.culturalPracticeFactory = culturalPracticeFactory
            self.fieldService = fieldService
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
                let currentSectionList = newUtil.state.sections,
                let culturalPracticeSectionList = newUtil.state.culturalPracticeElementSectionList,
                let fieldSectionList = newUtil.state.fieldElementSectionList
            else {
                return nil
            }

            let indexCurrentSectionFindOp = findIndexSection(currentSectionList, byId: newUtil.newSection.id)
            let indexCulturalPracticeSectionOp = findIndexSection(culturalPracticeSectionList, byId: newUtil.newSection.id)
            let indexFieldSectionOp = findIndexSection(fieldSectionList, byId: newUtil.newSection.id)

            if let indexCurrentSectionFind = indexCurrentSectionFindOp {
                newUtil.indexCurrentSectionPathFind = IndexPath(row: 0, section: indexCurrentSectionFind)
            }
            
            if let indexCulturalPracticeSection = indexCulturalPracticeSectionOp {
                newUtil.indexCulturalPracticeSection = IndexPath(row: 0, section: indexCulturalPracticeSection)
            }
            
            if let indexFieldSection = indexFieldSectionOp {
                newUtil.indexFieldSection = IndexPath(row: 0, section: indexFieldSection)
            }
            
            return newUtil
        }
        
        private func updataSectionList(util: UtilUpdateCulturalPracticeElementAction?) -> UtilUpdateCulturalPracticeElementAction? {
            guard var newUtil = util,
                var currentSectionList = newUtil.state.sections,
                var culturalPracticeSectionList = newUtil.state.culturalPracticeElementSectionList,
                var fieldSectionList = newUtil.state.fieldElementSectionList
                else {
                return nil
            }
            
            if let indexPathSectionFind = newUtil.indexCurrentSectionPathFind {
                currentSectionList[indexPathSectionFind.section] = newUtil.newSection
                newUtil.newSectionList = currentSectionList
            }
            
            if let indexCulturalPracticeSection = newUtil.indexCulturalPracticeSection {
                culturalPracticeSectionList[indexCulturalPracticeSection.section] = newUtil.newSection
                newUtil.newCulturalPracticeSectionList = culturalPracticeSectionList
            }
            
            if let indexFieldSection = newUtil.indexFieldSection {
                fieldSectionList[indexFieldSection.section] = newUtil.newSection
                newUtil.newFieldSectionList = fieldSectionList
            }
            
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
            newUtil.newField = fieldService.makeFieldUpdateBySection(newUtil.newSection, newUtil.newField)
            newUtil.newField.culturalPratice = newUtil.newCulturalPractice
            return newUtil
        }

        private func newState(util: UtilUpdateCulturalPracticeElementAction?) -> CulturalPracticeFormState? {
            guard let newUtil = util else {
                return nil
            }

            let isFinishCompletedCurrentContainer = newUtil.newSection.typeSection == ElementUIListData.TYPE_ELEMENT
                ? true
                : newUtil.state.isFinishCompletedLastDoseFumier
            
            let indexPathList = newUtil.indexCurrentSectionPathFind != nil ? [newUtil.indexCurrentSectionPathFind!] : []

            return newUtil.state.changeValues(
                currentField: newUtil.newField,
                sections: newUtil.newSectionList ?? newUtil.state.sections,
                culturalPracticeElementSectionList: newUtil.newCulturalPracticeSectionList ?? newUtil.state.culturalPracticeElementSectionList,
                fieldElementSectionList: newUtil.newFieldSectionList ?? newUtil.state.fieldElementSectionList,
                isFinishCompletedCurrentContainer: isFinishCompletedCurrentContainer,
                responseAction: .updateElementResponse(indexPaths: indexPathList)
            )
        }
        
        private func findIndexSection(_ sectionList: [Section<ElementUIData>], byId idSectionFind: UUID) -> Int? {
            (0..<sectionList.count).firstIndex { index in
                sectionList[index].id == idSectionFind
            }
        }

        deinit {
            print("******* deinit HandlerUpdateCulturalPracticeElementAction ************")
        }
    }

    private struct UtilUpdateCulturalPracticeElementAction {
        var state: CulturalPracticeFormState
        var newSection: Section<ElementUIData>
        var newField: Field
        var indexCurrentSectionPathFind: IndexPath?
        var indexCulturalPracticeSection: IndexPath?
        var indexFieldSection: IndexPath?
        var newSectionList: [Section<ElementUIData>]?
        var newCulturalPractice: CulturalPractice?
        var newCulturalPracticeSectionList: [Section<ElementUIData>]?
        var newFieldSectionList: [Section<ElementUIData>]?
    }
}
