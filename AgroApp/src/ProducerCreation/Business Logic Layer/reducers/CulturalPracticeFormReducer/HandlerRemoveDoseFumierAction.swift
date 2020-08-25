//
//  HandlerRemoveDoseFumierAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-31.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
extension CulturalPracticeFormReducerHandler {
    class HandlerRemoveDoseFumierAction: HandlerReducer {

        func handle(
            action: CulturalPracticeFormAction.RemoveDoseFumierAction,
            _ state: CulturalPracticeFormState
        ) -> CulturalPracticeFormState {
            let util = UtilRemoveDoseFumierAction(
                indexPathDoseFumierFromAction: action.indexPath,
                state: state
            )

            return (
                checkIfRemoveContainerElementHasValue(util:) >>>
                    hasContainerElementForNotRemoveWithNoValue(util:) >>>
                    getIndexDoseFumierFromCulturalPracticeElement(util:) >>>
                    removeDoseFumierWithIndex(util:) >>>
                    createContainerElementsIfHasCulturalPractice(util:) >>>
                    createContainerElementsWithNoValueIfHasNoValue(util:) >>>
                    getAllIndexPathContainerElementForRemove(util:) >>>
                    getAllIndexPathContainerElementForAddIfHas(util:) >>>
                    removeAllCulturalPracticeContainerElement(util:) >>>
                    addNewCulturalPracticeContainerElementIfThere(util:) >>>
                    newState(util:)
                )(util) ?? state.changeValues(responseAction: .notResponse)
        }

        private func checkIfRemoveContainerElementHasValue(
            util: UtilRemoveDoseFumierAction?
        ) -> UtilRemoveDoseFumierAction? {
            guard let sections = util?.state.sectionsCulturalPracticeElement,
                var newUtil = util,
                let containerElement =
                sections[newUtil.indexPathDoseFumierFromAction.section]
                    .rowData[newUtil.indexPathDoseFumierFromAction.row]
                    as? CulturalPracticeContainerElement
                else { return nil }

            newUtil.isContainerHasValue = containerElement.hasAllValueCompleted()
            return newUtil
        }

        private func hasContainerElementForNotRemoveWithNoValue(
            util: UtilRemoveDoseFumierAction?
        ) -> UtilRemoveDoseFumierAction? {
            guard let section = util?.state.sectionsCulturalPracticeElement,
                let indexPath = util?.indexPathDoseFumierFromAction,
                var newUtil = util
                else { return nil  }

            (1..<section[indexPath.section].rowData.count).forEach { index in
                guard index != indexPath.row,
                    let conainerElement = section[indexPath.section].rowData[index] as? CulturalPracticeContainerElement,
                    !conainerElement.hasAllValueCompleted()
                    else { return }

                newUtil.hasContainerElementForNotRemoveWithNotValue = true
            }

            return newUtil
        }

        private func getIndexDoseFumierFromCulturalPracticeElement(
            util: UtilRemoveDoseFumierAction?
        ) -> UtilRemoveDoseFumierAction? {
            guard let sections = util?.state.sectionsCulturalPracticeElement,
                let indexPathDoseFumierFromAction = util?.indexPathDoseFumierFromAction,
                var newUtil = util
                else { return nil }
            let index = sections[indexPathDoseFumierFromAction.section].rowData[indexPathDoseFumierFromAction.row].getIndex()
            newUtil.indexDoseFumierFromCulturalPracticeElement = index
            return newUtil
        }

        private func removeDoseFumierWithIndex(
            util: UtilRemoveDoseFumierAction?
        ) -> UtilRemoveDoseFumierAction? {
            guard var newUtil = util else { return nil }
            guard let culturalPractice = util?.state.currentField?.culturalPratice
                else { return util }

            newUtil.culturalPracticeWithDoseRemoveByIndex =
                culturalPractice.removeDoseFumierIndex(indexRemove: util?.indexDoseFumierFromCulturalPracticeElement)

            return newUtil
        }

        private func createContainerElementsIfHasCulturalPractice(
            util: UtilRemoveDoseFumierAction?
        ) -> UtilRemoveDoseFumierAction? {
            guard var newUtil = util else { return nil }
            guard let culturalPractice = util?.culturalPracticeWithDoseRemoveByIndex
                else { return util }

            newUtil.newCulturalPracticeElementContainer = CulturalPractice.getCulturalPracticeDynamic(from: culturalPractice)
            return newUtil
        }

        private func createContainerElementsWithNoValueIfHasNoValue(
            util: UtilRemoveDoseFumierAction?
        ) -> UtilRemoveDoseFumierAction? {
            guard let hasContainerElementForNotRemoveWithNotValue = util?.hasContainerElementForNotRemoveWithNotValue,
                hasContainerElementForNotRemoveWithNotValue else { return util }

            guard var newUtil = util else { return nil }

            let indexForContainerWithNoValue = newUtil.newCulturalPracticeElementContainer?.count ?? 0

            let containerWithNotValue = CulturalPractice.createCulturalPracticeInputMultiSelectContainer(
                index: indexForContainerWithNoValue
            )

            if var newCulturalPracticeElementContainer = newUtil.newCulturalPracticeElementContainer {
                newCulturalPracticeElementContainer.append(containerWithNotValue)
                newUtil.newCulturalPracticeElementContainer = newCulturalPracticeElementContainer
                return newUtil
            }

            newUtil.newCulturalPracticeElementContainer = [containerWithNotValue]
            return newUtil
        }

        private func getAllIndexPathContainerElementForRemove(
            util: UtilRemoveDoseFumierAction?
        ) -> UtilRemoveDoseFumierAction? {
            guard let sections = util?.state.sectionsCulturalPracticeElement,
                let indexPathRemoveDoseFromAction = util?.indexPathDoseFumierFromAction,
                var newUtil = util
                else { return nil }

            var doseFumierRemoveIndexPaths = [IndexPath]()
            let containerSection = sections[indexPathRemoveDoseFromAction.section]

            // Le premier element est le add Element
            (1..<containerSection.rowData.count).forEach { index in
                doseFumierRemoveIndexPaths.append(IndexPath(row: index, section: indexPathRemoveDoseFromAction.section))
            }

            newUtil.doseFumierRemoveIndexPaths = doseFumierRemoveIndexPaths
            return newUtil
        }

        private func getAllIndexPathContainerElementForAddIfHas(
            util: UtilRemoveDoseFumierAction?
        ) -> UtilRemoveDoseFumierAction? {
            guard var newUtil = util else { return nil }
            guard let culturalPracticeContainerElements = util?.newCulturalPracticeElementContainer else { return util }
            var indexPathAdd = [IndexPath]()

            (0..<culturalPracticeContainerElements.count).forEach { index in
                indexPathAdd.append(IndexPath(row: (index + 1), section: newUtil.indexPathDoseFumierFromAction.section))
            }

            newUtil.doseFumierAddIndexPaths = indexPathAdd
            return newUtil
        }

        private func removeAllCulturalPracticeContainerElement(
            util: UtilRemoveDoseFumierAction?
        ) -> UtilRemoveDoseFumierAction? {
            guard var sections = util?.state.sectionsCulturalPracticeElement,
                let indexPathRemove = util?.doseFumierRemoveIndexPaths,
                var newUtil = util
                else { return nil }

            indexPathRemove.sorted().reversed().forEach { indexPath in
                sections[indexPath.section].rowData.remove(at: indexPath.row)
            }

            newUtil.sectionWithAllContainerElementRemoved = sections
            return newUtil
        }

        private func addNewCulturalPracticeContainerElementIfThere(
            util: UtilRemoveDoseFumierAction?
        ) -> UtilRemoveDoseFumierAction? {
            guard var sections = util?.sectionWithAllContainerElementRemoved,
                let indexPathDoseFumierFromAction = util?.indexPathDoseFumierFromAction,
                var newUtil = util else { return nil }

            guard let culturalPracticeElementContainer = util?.newCulturalPracticeElementContainer
                else { return util }

            culturalPracticeElementContainer.forEach { element in
                sections[indexPathDoseFumierFromAction.section].rowData.append(element)
            }

            newUtil.sectionWithAllContainerElementRemoved = sections
            return newUtil
        }

        private func newState(util: UtilRemoveDoseFumierAction?) -> CulturalPracticeFormState? {
            guard let state = util?.state,
                let sections = util?.sectionWithAllContainerElementRemoved,
                let indexPathRemove = util?.doseFumierRemoveIndexPaths,
                let isContainerHasElement = util?.isContainerHasValue,
                let culturalPractice = util?.culturalPracticeWithDoseRemoveByIndex,
                var currentField = util?.state.currentField
                else { return nil }

            currentField.culturalPratice = culturalPractice

            return state.changeValues(
                currentField: currentField,
                currentSectionElement: sections,
                sectionsCulturalPracticeElement: sections,
                isFinishCompletedCurrentContainer: isContainerHasElement ? state.isFinishCompletedCurrentContainer : true,
                responseAction: .removeDoseFumierResponse(indexPathsRemove: indexPathRemove, indexPathsAdd: util?.doseFumierAddIndexPaths)
            )
        }
    }

    private struct UtilRemoveDoseFumierAction {
        var indexPathDoseFumierFromAction: IndexPath
        var state: CulturalPracticeFormState
        var indexDoseFumierFromCulturalPracticeElement: Int?
        var culturalPracticeWithDoseRemoveByIndex: CulturalPractice?
        var newCulturalPracticeElementContainer: [CulturalPracticeElementProtocol]?
        var doseFumierRemoveIndexPaths: [IndexPath]?
        var doseFumierAddIndexPaths: [IndexPath]?
        var sectionWithAllContainerElementRemoved: [Section<CulturalPracticeElementProtocol>]?
        var isContainerHasValue: Bool?
        var hasContainerElementForNotRemoveWithNotValue: Bool?
    }
}
