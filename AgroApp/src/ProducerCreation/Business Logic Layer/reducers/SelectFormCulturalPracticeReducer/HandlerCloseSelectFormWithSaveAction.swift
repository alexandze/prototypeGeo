//
//  HandlerCloseSelectFormWithSaveAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-26.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension SelectFormCulturalPracticeHandlerReducer {
    class HandlerCloseSelectFormWithSaveAction: HandlerReducer {
        func handle(
            action: SelectFormCulturalPracticeAction.CloseSelectFormWithSaveAction,
            _ state: SelectFormCulturalPracticeState
        ) -> SelectFormCulturalPracticeState {
            let util = UtilHandlerCloseSelectFormWithSaveAction(state: state, indexSelected: action.indexSelected)

            return (
                getRawAndValueSelectedByIndex(util: ) >>>
                    setRawAndValueOfSelectElement(util: ) >>>
                    setSectionWithSelectElement(util: ) >>>
                    newState(util: )
                )(util) ?? state
        }

        private func getRawAndValueSelectedByIndex(util: UtilHandlerCloseSelectFormWithSaveAction?) -> UtilHandlerCloseSelectFormWithSaveAction? {
            guard var newUtil = util,
                let selectElement = newUtil.state.selectElement,
                Util.hasIndexInArray(selectElement.values, index: newUtil.indexSelected)
                else {
                    return nil
            }

            newUtil.rawValueSelected = selectElement.values[newUtil.indexSelected].0
            newUtil.valueSelected = selectElement.values[newUtil.indexSelected].1
            return newUtil
        }

        private func setRawAndValueOfSelectElement(util: UtilHandlerCloseSelectFormWithSaveAction?) -> UtilHandlerCloseSelectFormWithSaveAction? {
            guard var newUtil = util,
                let rawSelected = newUtil.rawValueSelected,
                let valueSelected = newUtil.valueSelected,
                var selectElement = newUtil.state.selectElement else {
                    return nil
            }

            selectElement.rawValue = rawSelected
            selectElement.value = valueSelected
            selectElement.indexValue = newUtil.indexSelected
            newUtil.newSelectElement = selectElement
            return newUtil
        }

        private func setSectionWithSelectElement(util: UtilHandlerCloseSelectFormWithSaveAction?) -> UtilHandlerCloseSelectFormWithSaveAction? {
            guard var newUtil = util,
                let newSelectElement = newUtil.newSelectElement,
                var section = newUtil.state.section,
                Util.hasIndexInArray(section.rowData, index: 0)
                else {
                    return nil
            }

            section.rowData[0] = newSelectElement
            newUtil.newSection = section
            return newUtil
        }

        private func newState(util: UtilHandlerCloseSelectFormWithSaveAction?) -> SelectFormCulturalPracticeState? {
            guard let newUtil = util,
                let newSection = newUtil.newSection,
                let newSelectElement = newUtil.newSelectElement
                else {
                    return nil
            }

            return newUtil.state.changeValue(
                selectElement: newSelectElement,
                section: newSection,
                actionResponse: .closeSelectFormWithSaveActionResponse
            )
        }
    }

    private struct UtilHandlerCloseSelectFormWithSaveAction {
        var state: SelectFormCulturalPracticeState
        var indexSelected: Int
        var rawValueSelected: Int?
        var valueSelected: String?
        var newSelectElement: SelectElement?
        var newSection: Section<ElementUIData>?
    }
}
