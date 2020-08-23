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

        func handle(
            action: CulturalPracticeFormAction.UpdateCulturalPracticeElementAction,
            _ state: CulturalPracticeFormState
        ) -> CulturalPracticeFormState {

            let util = UtilUpdateCulturalPracticeElementAction(
                state: state,
                elementUIData: action.elementUIData,
                culturalPractice: state.currentField?.culturalPratice,
                fieldFromAction: action.field
            )

            return (
                findCulturalPracticeElementIndex(util:) >>>
                    updateSectionWithNewCulturalPracticeElement(util:) >>>
                    isContainerElement(util:) >>>
                    updateFieldifInputAndSelectElement(util:) >>>
                    updateFieldIfContainerElement(util:) >>>
                    createNewState(util:)
                )(util) ?? state.changeValues(responseAction: .notResponse)
        }

        private func findCulturalPracticeElementIndex(
            util: UtilUpdateCulturalPracticeElementAction?
        ) -> UtilUpdateCulturalPracticeElementAction? {
            if let sections = util?.state?.sections,
                let elementUIData = util?.elementUIData,
                var newUtil = util {
                var firstIndexRow: Int?

                let firstIndexSection = sections.firstIndex { section in
                    firstIndexRow = section.rowData.firstIndex { elementUIDataFromSection in
                        return elementUIData.id == elementUIDataFromSection.id
                    }

                    return firstIndexRow != nil
                }

                let indexPath = firstIndexRow != nil && firstIndexSection != nil
                    ? IndexPath(row: firstIndexRow!, section: firstIndexSection!)
                    : nil

                newUtil.indexOfCulturalPracticeElement = indexPath
                return newUtil
            }

            return nil
        }

        private func updateSectionWithNewCulturalPracticeElement(
            util: UtilUpdateCulturalPracticeElementAction?
        ) -> UtilUpdateCulturalPracticeElementAction? {
            guard var copySection = util?.state?.sections,
                let indexPathFind = util?.indexOfCulturalPracticeElement,
                let elementUIData = util?.elementUIData,
                var newUtil = util
                else { return nil }

            copySection[indexPathFind.section].rowData[indexPathFind.row] = elementUIData
            newUtil.sectionsUpdate = copySection
            return newUtil
        }

        private func isContainerElement(util: UtilUpdateCulturalPracticeElementAction?) -> UtilUpdateCulturalPracticeElementAction? {
            guard let elementUIData = util?.elementUIData,
                var newUtil = util
                else { return nil }
            newUtil.isContainerElement = (elementUIData as? ElementUIListData) != nil
            return newUtil
        }

        private func updateFieldifInputAndSelectElement(
            util: UtilUpdateCulturalPracticeElementAction?
        ) -> UtilUpdateCulturalPracticeElementAction? {
            guard
                (util?.elementUIData as? InputElement) != nil ||
                    (util?.elementUIData as? SelectElement) != nil
                else { return util }

            guard let fieldFromAction = util?.fieldFromAction,
                let elementUIData = util?.elementUIData,
                var newUtil = util else { return nil }

            let culturalPractice = util?.culturalPractice ??
                CulturalPractice(id: fieldFromAction.id)

            guard let newCulturalPracticeWithNewValue = culturalPracticeElement.value?
                .changeValueOfCulturalPractice(
                    culturalPractice,
                    index: util?.culturalPracticeElementProtocole?.getIndex()
                ) else { return nil }

            newUtil.culturalPractice = newCulturalPracticeWithNewValue
            return newUtil
        }

        private func updateFieldIfContainerElement(
            util: UtilUpdateCulturalPracticeElementAction?
        ) -> UtilUpdateCulturalPracticeElementAction? {
            guard let containerElement = util?.culturalPracticeElementProtocole as? CulturalPracticeContainerElement
                else { return util }

            let countInputElement = containerElement.culturalInputElement.count
            var previousUtil = util
            let countSelectElement = containerElement.culturalPracticeMultiSelectElement.count

            (0..<countInputElement).forEach { index in
                previousUtil?.culturalPracticeElementProtocole = containerElement.culturalInputElement[index]
                previousUtil = updateFieldifInputAndSelectElement(util: previousUtil)
            }

            (0..<countSelectElement).forEach { index in
                previousUtil?.culturalPracticeElementProtocole = containerElement.culturalPracticeMultiSelectElement[index]
                previousUtil = updateFieldifInputAndSelectElement(
                    util: previousUtil
                )
            }

            return previousUtil
        }

        private func createNewState(util: UtilUpdateCulturalPracticeElementAction?) -> CulturalPracticeFormState? {
            guard let newSections = util?.sectionsUpdate,
                let newCulturalPractice = util?.culturalPractice,
                let isContainerElement = util?.isContainerElement,
                let indexOfCulturalPracticeElement = util?.indexOfCulturalPracticeElement,
                var copyCurrentField = util?.state?.currentField,
                let state = util?.state
                else { return nil }

            copyCurrentField.culturalPratice = newCulturalPractice

            return state.changeValues(
                currentField: copyCurrentField,
                sections: newSections,
                isFinishCompletedCurrentContainer: isContainerElement ? true : state.isFinishCompletedCurrentContainer,
                responseAction: .updateElementResponse(indexPath: [indexOfCulturalPracticeElement])
            )
        }

        deinit {
            print("******* deinit HandlerUpdateCulturalPracticeElementAction ************")
        }
    }

    private struct UtilUpdateCulturalPracticeElementAction {
        var state: CulturalPracticeFormState?
        var elementUIData: ElementUIData?
        var culturalPractice: CulturalPractice?
        var indexOfCulturalPracticeElement: IndexPath?
        var sectionsUpdate: [Section<ElementUIData>]?
        var isContainerElement: Bool?
        var fieldFromAction: Field?
    }
}
