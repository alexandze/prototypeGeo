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
                    checkIfCurrentSectionIsCulturalPractice(util: ) >>>
                    newState(util: )
                )(util) ?? state.changeValues(responseAction: .notResponse)
        }

        private func checkIfElementUIDataList(util: UtilRemoveDoseFumierAction?) -> UtilRemoveDoseFumierAction? {
            guard let newUtil = util,
                let sectionList = newUtil.state.culturalPracticeElementSectionList
                else { return nil }

            let indexPath = newUtil.indexPathDoseFumierFromAction
            
            let isSectionElementUIdataList = Util.hasIndexInArray(sectionList, index: indexPath.section) &&
                 sectionList[indexPath.section].typeSection == ElementUIListData.TYPE_ELEMENT

            guard isSectionElementUIdataList else {
                return nil
            }

            return newUtil
        }

        private func checkIfRemoveContainerElementHasValue(
            util: UtilRemoveDoseFumierAction?
        ) -> UtilRemoveDoseFumierAction? {
            guard let culturalPracticeElementSectionList = util?.state.culturalPracticeElementSectionList,
                var newUtil = util else { return nil }

            let sectionElementUIListData = culturalPracticeElementSectionList[newUtil.indexPathDoseFumierFromAction.section]
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
                let culturalPracticeElementSectionList = newUtil.state.culturalPracticeElementSectionList else { return nil }

            newUtil.conserveEmptyELementUIListData = []

            (0..<culturalPracticeElementSectionList.count).forEach { index in
                if index != newUtil.indexPathDoseFumierFromAction.section &&
                    culturalPracticeElementSectionList[index].typeSection == ElementUIListData.TYPE_ELEMENT &&
                    !allValueIsValidInSection(section: culturalPracticeElementSectionList[index]) {
                    newUtil.conserveEmptyELementUIListData?.append(culturalPracticeElementSectionList[index])
                }
            }

            return newUtil
        }

        private func removeValueInCululturalPracticeBySection(util: UtilRemoveDoseFumierAction?) -> UtilRemoveDoseFumierAction? {
            guard var newUtil = util,
                let culturalPracticeSectionForRemove = newUtil.state.culturalPracticeElementSectionList?[newUtil.indexPathDoseFumierFromAction.section],
                let culuralPractice = newUtil.state.currentField?.culturalPratice
                else { return nil }

            newUtil.newCulturalPractice = culturalPracticeFactory
                .makeCulturalPraticeByRemove(culuralPractice, section: culturalPracticeSectionForRemove)

            return newUtil
        }

        private func resetSection(util: UtilRemoveDoseFumierAction?) -> UtilRemoveDoseFumierAction? {
            guard var newUtil = util,
                let culturalPracticeSectionList = newUtil.state.culturalPracticeElementSectionList,
                let newCulturalPractice = newUtil.newCulturalPractice else {
                    return nil
            }

            newUtil.newCulturalPracticeSectionList = fieldDetailsFactory
                .makeSectionListElementUIDataByResetSectionElementUIListData(newCulturalPractice, culturalPracticeSectionList)

            return newUtil
        }

        private func addEmptySection(util: UtilRemoveDoseFumierAction?) -> UtilRemoveDoseFumierAction? {
            guard var newUtil = util,
                var newCulturalPracticeSectionList = newUtil.newCulturalPracticeSectionList,
                let sectionEmptyElementUIData = newUtil.conserveEmptyELementUIListData
                else {
                    return nil
            }
            
            guard !sectionEmptyElementUIData.isEmpty else { return newUtil }

            let countSection = newCulturalPracticeSectionList.count
            let lastSectiom = newCulturalPracticeSectionList[countSection - 1]

            if var lastIndex = lastSectiom.index {
                sectionEmptyElementUIData.forEach { sectionEmpty in
                    var copySectionEmpty = sectionEmpty
                    lastIndex += 1
                    copySectionEmpty.index = lastIndex
                    newCulturalPracticeSectionList.append(copySectionEmpty)
                }
            }

            if lastSectiom.index == nil {
                var myIndex = 0

                sectionEmptyElementUIData.forEach { sectionEmpty in
                    var copySectionEmpty = sectionEmpty
                    copySectionEmpty.index = myIndex
                    newCulturalPracticeSectionList.append(copySectionEmpty)
                    myIndex += 1
                }
            }

            newUtil.newCulturalPracticeSectionList = newCulturalPracticeSectionList
            return newUtil
        }

        private func getRemoveIndexList(util: UtilRemoveDoseFumierAction?) -> UtilRemoveDoseFumierAction? {
            guard var newUtil = util,
                let previousSectionList = newUtil.state.culturalPracticeElementSectionList
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
                let newCulturalPracticeSectionList = newUtil.newCulturalPracticeSectionList else {
                    return nil
            }

            var indexAddList = [IndexPath]()

            (0..<newCulturalPracticeSectionList.count).forEach { index in
                if newCulturalPracticeSectionList[index].typeSection == ElementUIListData.TYPE_ELEMENT {
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
        
        private func checkIfCurrentSectionIsCulturalPractice(util: UtilRemoveDoseFumierAction?) -> UtilRemoveDoseFumierAction? {
            guard var newUtil = util,
                let currentSectionList = newUtil.state.sections,
                let newSectionCulturalPracticeList = newUtil.newCulturalPracticeSectionList
                else {
                return nil
            }
            
            newUtil.isCurrrentSectionIsCulturalPractice = (currentSectionList
                .flatMap { $0.rowData }
                .map { $0.title }
                .first { hasTitle($0, inThisSectionList: newSectionCulturalPracticeList) } != nil)
            return newUtil
        }

        private func newState(util: UtilRemoveDoseFumierAction?) -> CulturalPracticeFormState? {
            guard let newUtil = util,
                let indexRemoveList = newUtil.indexRemoveList,
                let indexAddList = newUtil.indexAddList,
                let newCulturalPracticeSection = newUtil.newCulturalPracticeSectionList,
                let newField = newUtil.newField,
                let isCurrrentSectionIsCulturalPractice = newUtil.isCurrrentSectionIsCulturalPractice,
                let isContainerHasValue = newUtil.isContainerHasValue else {
                    return nil
            }

            return newUtil.state.changeValues(
                currentField: newField,
                sections: isCurrrentSectionIsCulturalPractice ? newCulturalPracticeSection : newUtil.state.sections,
                culturalPracticeElementSectionList: newCulturalPracticeSection,
                isFinishCompletedCurrentContainer: isContainerHasValue ? newUtil.state.isFinishCompletedLastDoseFumier : true,
                responseAction: .removeDoseFumierResponse(
                    indexPathsRemove: indexRemoveList,
                    indexPathsAdd: indexAddList,
                    isCurrrentSectionIsCulturalPractice: isCurrrentSectionIsCulturalPractice
                )
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
        
        private func hasTitle(_ title: String, inThisSectionList sectionList: [Section<ElementUIData>]) -> Bool {
            sectionList
                .flatMap { $0.rowData }
                .first { elementUIData in
                    elementUIData.title == title
            } != nil
        }

    }

    private struct UtilRemoveDoseFumierAction {
        var indexPathDoseFumierFromAction: IndexPath
        var state: CulturalPracticeFormState
        var isContainerHasValue: Bool?
        var conserveEmptyELementUIListData: [Section<ElementUIData>]?
        var newCulturalPractice: CulturalPractice?
        var newCulturalPracticeSectionList: [Section<ElementUIData>]?
        var indexRemoveList: [IndexPath]?
        var indexAddList: [IndexPath]?
        var newField: Field?
        var isCurrrentSectionIsCulturalPractice: Bool?
    }
}
