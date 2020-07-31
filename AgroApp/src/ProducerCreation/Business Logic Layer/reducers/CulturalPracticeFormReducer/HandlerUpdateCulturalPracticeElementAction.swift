//
//  HandlerUpdateCulturalPracticeElementAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-31.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class HandlerUpdateCulturalPracticeElementAction {

    func handle(
        action: CulturalPracticeFormAction.UpdateCulturalPracticeElementAction,
        _ state: CulturalPracticeFormState
    ) -> CulturalPracticeFormState {
        let util = UtilUpdateCulturalPracticeElementAction(
            state: state,
            culturalPracticeElementProtocole: action.culturalPracticeElementProtocol,
            culturalPractice: state.currentField?.culturalPratice,
            fieldFromAction: action.field
        )

        let composeFunc = findCulturalPracticeElementIndex(util:) >>>
            updateSectionWithNewCulturalPracticeElement(util:) >>>
            isContainerElement(util:) >>>
            updateFieldifInputAndSelectElement(util:) >>>
            updateFieldIfContainerElement(util:) >>>
            createNewState(util:)

        let newState = composeFunc(util)
        return newState ?? state
    }

    private func findCulturalPracticeElementIndex(
        util: UtilUpdateCulturalPracticeElementAction?
    ) -> UtilUpdateCulturalPracticeElementAction? {
        if let sections = util?.state?.sections,
            let culturalPracticeElementProtocole = util?.culturalPracticeElementProtocole,
            var newUtil = util {
            var firstIndexRow: Int?

            let firstIndexSection = sections.firstIndex { section in
                firstIndexRow = section.rowData.firstIndex { culturalPracticeElement in
                    return culturalPracticeElementProtocole.key == culturalPracticeElement.key
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
            let culturalPracticeElementProtocol = util?.culturalPracticeElementProtocole,
            var newUtil = util
            else { return nil }

        copySection[indexPathFind.section].rowData[indexPathFind.row] = culturalPracticeElementProtocol
        newUtil.sectionsUpdate = copySection
        return newUtil
    }

    private func isContainerElement(util: UtilUpdateCulturalPracticeElementAction?) -> UtilUpdateCulturalPracticeElementAction? {
        guard let culturalPracticeElementProtocole = util?.culturalPracticeElementProtocole,
            var newUtil = util
            else { return nil }
        newUtil.isContainerElement = (culturalPracticeElementProtocole as? CulturalPracticeContainerElement) != nil
        return newUtil
    }

    private func updateFieldifInputAndSelectElement(
        util: UtilUpdateCulturalPracticeElementAction?
    ) -> UtilUpdateCulturalPracticeElementAction? {
        guard
            (util?.culturalPracticeElementProtocole as? CulturalPracticeInputElement) != nil ||
                (util?.culturalPracticeElementProtocole as? CulturalPracticeMultiSelectElement) != nil
            else { return util }

        guard let fieldFromAction = util?.fieldFromAction,
            let culturalPracticeElement = util?.culturalPracticeElementProtocole,
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
            subAction: .updateRows(indexPath: [indexOfCulturalPracticeElement]),
            isFinishCompletedCurrentContainer: isContainerElement ? true : state.isFinishCompletedCurrentContainer
        )
    }

    deinit {
        print("******* deinit HandlerUpdateCulturalPracticeElementAction ************")
    }
}

private struct UtilUpdateCulturalPracticeElementAction {
    var state: CulturalPracticeFormState?
    var culturalPracticeElementProtocole: CulturalPracticeElementProtocol?
    var culturalPractice: CulturalPractice?
    var indexOfCulturalPracticeElement: IndexPath?
    var sectionsUpdate: [Section<CulturalPracticeElementProtocol>]?
    var isContainerElement: Bool?
    var fieldFromAction: Field?
}
