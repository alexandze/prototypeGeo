//
//  HandleAddDoseFumierAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-23.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension CulturalPracticeFormReducerHandler {
    class HandleAddDoseFumierAction: HandlerReducer {
        let fieldDetailsFactory: FieldDetailsFactory

        init(fieldDetailsFactory: FieldDetailsFactory = FieldDetailsFactoryImpl()) {
            self.fieldDetailsFactory = fieldDetailsFactory
        }

        func handle(action: CulturalPracticeFormAction.AddDoseFumierAction, _ state: CulturalPracticeFormState) -> CulturalPracticeFormState {
            // verifier si a fini de completer la dose avant d'ajouter une autre
            // verifier si c est le maximun de dose
            // creer la section
            // newState

            let util = UtilHandleAddDoseFumierAction(state: state)

            return (
                checkIfFinishCompletedLastDoseFumier(util: ) >>>
                    checkIfMaxDoseFumier(util: ) >>>
                    makeNewDoseFumier(util: ) >>>
                    checkIfCurrentSectionIsCulturalPractice(util: ) >>>
                    newState(util: )
            )(util) ?? state
        }

        private func checkIfFinishCompletedLastDoseFumier(util: UtilHandleAddDoseFumierAction?) -> UtilHandleAddDoseFumierAction? {
            guard var newUtil = util else { return nil }
            newUtil.isFinishCompletedLastDoseFumier = newUtil.state.isFinishCompletedLastDoseFumier ?? true
            return newUtil
        }

        private func checkIfMaxDoseFumier(util: UtilHandleAddDoseFumierAction?) -> UtilHandleAddDoseFumierAction? {
            guard var newUtil = util,
            let culturalPracticeSectionList = newUtil.state.culturalPracticeElementSectionList else { return nil }
            let maxDoseFumier = CulturalPractice.MAX_DOSE_FUMIER
            var countDoseFumier = 0

            (0..<culturalPracticeSectionList.count).forEach { index in
                if culturalPracticeSectionList[index].typeSection == ElementUIListData.TYPE_ELEMENT {
                    countDoseFumier += 1
                }
            }

            newUtil.isMaxDoseFumier = countDoseFumier == maxDoseFumier
            return newUtil
        }

        private func makeNewDoseFumier(util: UtilHandleAddDoseFumierAction?) -> UtilHandleAddDoseFumierAction? {
            guard var newUtil = util,
                let isFinishCompletedLastDoseFumier = newUtil.isFinishCompletedLastDoseFumier,
                let isMaxDoseFumier = newUtil.isMaxDoseFumier,
                let culturalPracticeElementSectionList = newUtil.state.culturalPracticeElementSectionList
                else { return nil }

            guard isFinishCompletedLastDoseFumier && !isMaxDoseFumier else {
                return newUtil
            }

            newUtil.newSectionListWithAddDoseFumier = fieldDetailsFactory.makeSectionWitNewDoseFumier(culturalPracticeElementSectionList)
            return newUtil
        }
        
        private func checkIfCurrentSectionIsCulturalPractice(util: UtilHandleAddDoseFumierAction?) -> UtilHandleAddDoseFumierAction? {
            guard var newUtil = util,
                let currentSectionList = newUtil.state.sections,
                let newSectionCulturalPracticeList = newUtil.newSectionListWithAddDoseFumier
                else {
                return nil
            }
            
            newUtil.isCurrrentSectionIsCulturalPractice = (currentSectionList
                .flatMap { $0.rowData }
                .map { $0.title }
                .first { hasTitle($0, inThisSectionList: newSectionCulturalPracticeList) } != nil)
            
            return newUtil
        }

        private func newState(util: UtilHandleAddDoseFumierAction?) -> CulturalPracticeFormState? {
            guard let newUtil = util,
                let isFinishCompletedLastDoseFumier = newUtil.isFinishCompletedLastDoseFumier,
                let isMaxDoseFumier = newUtil.isMaxDoseFumier,
                let isCurrrentSectionIsCulturalPractice = newUtil.isCurrrentSectionIsCulturalPractice
            else { return nil }
            
            if let newSectionListWithAddDoseFumier = newUtil.newSectionListWithAddDoseFumier {
                let indexPath = IndexPath(row: 0, section: (newSectionListWithAddDoseFumier.count - 1))
                
                return newUtil.state.changeValues(
                    sections: isCurrrentSectionIsCulturalPractice ? newSectionListWithAddDoseFumier : newUtil.state.sections,
                    culturalPracticeElementSectionList: newSectionListWithAddDoseFumier,
                    isFinishCompletedCurrentContainer: false,
                    responseAction: .addDoseFumierActionResponse(
                        indexPaths: [indexPath],
                        isMaxDoseFumier: false,
                        isFinishCompletedLastDoseFumier: true,
                        isCurrrentSectionIsCulturalPractice: isCurrrentSectionIsCulturalPractice
                    )
                )
            }

            return newUtil.state.changeValues(
                responseAction: .addDoseFumierActionResponse(
                    indexPaths: [],
                    isMaxDoseFumier: isMaxDoseFumier,
                    isFinishCompletedLastDoseFumier: isFinishCompletedLastDoseFumier,
                    isCurrrentSectionIsCulturalPractice: isCurrrentSectionIsCulturalPractice
                )
            )

        }
        
        private func hasTitle(_ title: String, inThisSectionList sectionList: [Section<ElementUIData>]) -> Bool {
            sectionList
                .flatMap { $0.rowData }
                .first { elementUIData in
                    elementUIData.title == title
            } != nil
        }
    }

    private struct UtilHandleAddDoseFumierAction {
        var state: CulturalPracticeFormState
        var isFinishCompletedLastDoseFumier: Bool?
        var isMaxDoseFumier: Bool?
        var newSectionListWithAddDoseFumier:  [Section<ElementUIData>]?
        var isCurrrentSectionIsCulturalPractice: Bool?
    }
}
