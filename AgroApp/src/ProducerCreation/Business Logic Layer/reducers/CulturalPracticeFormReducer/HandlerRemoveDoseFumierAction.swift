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

        let culturalPracticeFactory: CulturalPracticeFactory
        let fieldDetailsFactory: FieldDetailsFactory

        init(
            culturalPracticeFactory: CulturalPracticeFactory = CulturalPracticeFactoryImpl(),
            fieldDetailsFactory: FieldDetailsFactory = FieldDetailsFactoryImpl()
        ) {
            self.culturalPracticeFactory = culturalPracticeFactory
            self.fieldDetailsFactory = fieldDetailsFactory
        }

        func handle(
            action: CulturalPracticeFormAction.RemoveDoseFumierAction,
            _ state: CulturalPracticeFormState
        ) -> CulturalPracticeFormState {
            let util = UtilRemoveDoseFumierAction(
                indexPathDoseFumierFromAction: action.indexPath,
                state: state
            )

            return (
                checkIfElementUIDataList(util: ) >>>
                    checkIfRemoveContainerElementHasValue(util:) >>>
                    conserveEmptyElementUIdataList(util:) >>>
                    removeValueInCululturalPracticeBySection(util:) >>>
                    resetSection(util: ) >>>
                    addEmptySection(util: ) >>>
                    getRemoveIndexList(util: ) >>>
                    getAddIndexList(util:) >>>
                    setFieldWithNewCulturalPractice(util:) >>>
                    newState(util: )
                )(util) ?? state.changeValues(responseAction: .notResponse)
        }

        private func checkIfElementUIDataList(util: UtilRemoveDoseFumierAction?) -> UtilRemoveDoseFumierAction? {
            guard let newUtil = util,
                let sectionList = newUtil.state.sections
                else { return nil }

            let indexPath = newUtil.indexPathDoseFumierFromAction
            var isSectionElementUIdataList = false

            if Util.hasIndexInArray(sectionList, index: indexPath.section) {
                isSectionElementUIdataList = sectionList[indexPath.section].typeSection == ElementUIListData.TYPE_ELEMENT
            }

            guard isSectionElementUIdataList else {
                return nil
            }

            return newUtil
        }

        private func checkIfRemoveContainerElementHasValue(
            util: UtilRemoveDoseFumierAction?
        ) -> UtilRemoveDoseFumierAction? {
            guard let sections = util?.state.sections,
                var newUtil = util else { return nil }

            let sectionElementUIListData = sections[newUtil.indexPathDoseFumierFromAction.section]
            var isContainerHasValue = false

            sectionElementUIListData.rowData.forEach { elementUIData in
                if let selectElement = elementUIData as? SelectElement, selectElement.value != nil {
                    isContainerHasValue = true
                }

                if let inputElement = elementUIData as? InputElement, inputElement.isValid {
                    isContainerHasValue = true
                }
            }

            newUtil.isContainerHasValue = isContainerHasValue
            return newUtil
        }

        private func conserveEmptyElementUIdataList(util: UtilRemoveDoseFumierAction?) -> UtilRemoveDoseFumierAction? {
            guard var newUtil = util,
                let sectionList = newUtil.state.sections else { return nil }

            newUtil.conserveEmptyELementUIListData = []

            (0..<sectionList.count).forEach { index in
                if index != newUtil.indexPathDoseFumierFromAction.section &&
                    sectionList[index].typeSection == ElementUIListData.TYPE_ELEMENT &&
                    !allValueIsValidInSection(section: sectionList[index]) {
                    newUtil.conserveEmptyELementUIListData?.append(sectionList[index])
                }
            }

            return newUtil
        }

        private func removeValueInCululturalPracticeBySection(util: UtilRemoveDoseFumierAction?) -> UtilRemoveDoseFumierAction? {
            guard var newUtil = util,
                let sectionForRemove = newUtil.state.sections?[newUtil.indexPathDoseFumierFromAction.section],
                let culuralPractice = newUtil.state.currentField?.culturalPratice
                else { return nil }

            newUtil.newCulturalPractice = culturalPracticeFactory
                .makeCulturalPraticeByRemove(culuralPractice, section: sectionForRemove)

            return newUtil
        }

        private func resetSection(util: UtilRemoveDoseFumierAction?) -> UtilRemoveDoseFumierAction? {
            guard var newUtil = util,
                let sectionList = newUtil.state.sections,
                let newCulturalPractice = newUtil.newCulturalPractice else {
                    return nil
            }

            newUtil.newSectionList = fieldDetailsFactory
                .makeSectionListElementUIDataByResetSectionElementUIListData(newCulturalPractice, sectionList)

            return newUtil
        }

        private func addEmptySection(util: UtilRemoveDoseFumierAction?) -> UtilRemoveDoseFumierAction? {
            guard var newUtil = util,
                var newSectionList = newUtil.newSectionList,
                let sectionEmptyElementUIData = newUtil.conserveEmptyELementUIListData
                else {
                    return nil
            }

            guard !sectionEmptyElementUIData.isEmpty else { return newUtil }

            let countSection = newSectionList.count
            let lastSectiom = newSectionList[countSection - 1]

            if var lastIndex = lastSectiom.index {
                sectionEmptyElementUIData.forEach { sectionEmpty in
                    var copySectionEmpty = sectionEmpty
                    lastIndex += 1
                    copySectionEmpty.index = lastIndex
                    newSectionList.append(copySectionEmpty)
                }
            }

            if lastSectiom.index == nil {
                var myIndex = 0

                sectionEmptyElementUIData.forEach { sectionEmpty in
                    var copySectionEmpty = sectionEmpty
                    copySectionEmpty.index = myIndex
                    newSectionList.append(copySectionEmpty)
                    myIndex += 1
                }
            }

            newUtil.newSectionList = newSectionList
            return newUtil
        }

        private func getRemoveIndexList(util: UtilRemoveDoseFumierAction?) -> UtilRemoveDoseFumierAction? {
            guard var newUtil = util,
                let previousSectionList = newUtil.state.sections
                else { return nil }

            var indexRemoveList = [IndexPath]()

            (0..<previousSectionList.count).forEach { index in
                if previousSectionList[index].typeSection == ElementUIListData.TYPE_ELEMENT {
                    indexRemoveList.append(IndexPath(row: 0, section: index))
                }
            }

            newUtil.indexRemoveList = indexRemoveList
            return newUtil
        }

        private func getAddIndexList(util: UtilRemoveDoseFumierAction?) -> UtilRemoveDoseFumierAction? {
            guard var newUtil = util,
                let newSectionList = newUtil.newSectionList else {
                    return nil
            }

            var indexAddList = [IndexPath]()

            (0..<newSectionList.count).forEach { index in
                if newSectionList[index].typeSection == ElementUIListData.TYPE_ELEMENT {
                    indexAddList.append(IndexPath(row: 0, section: index))
                }
            }

            newUtil.indexAddList = indexAddList
            return newUtil
        }

        private func setFieldWithNewCulturalPractice(util: UtilRemoveDoseFumierAction?) -> UtilRemoveDoseFumierAction? {
            guard var newUtil = util,
                var newField = newUtil.state.currentField,
                let newCuluralPractice = newUtil.newCulturalPractice else {
                    return nil
            }

            newField.culturalPratice = newCuluralPractice
            newUtil.newField = newField
            return newUtil
        }

        private func newState(util: UtilRemoveDoseFumierAction?) -> CulturalPracticeFormState? {
            guard let newUtil = util,
                let indexRemoveList = newUtil.indexRemoveList,
                let indexAddList = newUtil.indexAddList,
                let newSection = newUtil.newSectionList,
                let newField = newUtil.newField,
                let isContainerHasValue = newUtil.isContainerHasValue else {
                    return nil
            }

            return newUtil.state.changeValues(
                currentField: newField,
                sections: newSection,
                isFinishCompletedCurrentContainer: isContainerHasValue ? newUtil.state.isFinishCompletedLastDoseFumier : true,
                responseAction: .removeDoseFumierResponse(indexPathsRemove: indexRemoveList, indexPathsAdd: indexAddList)
            )
        }

        private func allValueIsValidInSection(section: Section<ElementUIData>) -> Bool {
            var isAllValueValid = true

            section.rowData.forEach { elementUIData in
                if let selectElement = elementUIData as? SelectElement, selectElement.value == nil {
                    isAllValueValid = false
                }

                if let inputElement = elementUIData as? InputElement, !inputElement.isValid {
                    isAllValueValid = false
                }
            }

            return isAllValueValid
        }

    }

    private struct UtilRemoveDoseFumierAction {
        var indexPathDoseFumierFromAction: IndexPath
        var state: CulturalPracticeFormState
        var isContainerHasValue: Bool?
        var conserveEmptyELementUIListData: [Section<ElementUIData>]?
        var newCulturalPractice: CulturalPractice?
        var newSectionList: [Section<ElementUIData>]?
        var indexRemoveList: [IndexPath]?
        var indexAddList: [IndexPath]?
        var newField: Field?
    }
}
