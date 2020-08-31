//
//  HandlerSelectFieldOnListAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension CulturalPracticeFormReducerHandler {

    class HandlerSelectFieldOnListAction: HandlerReducer {
        let fieldDetailsFactory: FieldDetailsFactory
        let fieldService: FieldService
        init(
            fieldDetailsFactory: FieldDetailsFactory = FieldDetailsFactoryImpl(),
            fieldService: FieldService = FieldServiceImpl()
        ) {
            self.fieldDetailsFactory = fieldDetailsFactory
            self.fieldService = fieldService
        }

        func handle(action: FieldListAction.SelectFieldOnListAction, _ state: CulturalPracticeFormState) -> CulturalPracticeFormState {
            let util = UtilHandlerSelectFieldOnListAction(
                state: state,
                fieldSelected: action.field,
                fieldDetailsFactory: fieldDetailsFactory
            )

            return (
                makeSectionCulturalPractice(util:) >>>
                    makeSectionField(util: ) >>>
                    newState(_:)
                )(util) ?? state
        }

        private func makeSectionCulturalPractice(util: UtilHandlerSelectFieldOnListAction?) -> UtilHandlerSelectFieldOnListAction? {
            guard var newUtil = util else { return nil }

            if newUtil.fieldSelected.culturalPratice == nil {
                newUtil.fieldSelected.culturalPratice = CulturalPractice(id: newUtil.fieldSelected.id)
            }

            newUtil.newSectionElementCulturalPracrice = newUtil
                .fieldDetailsFactory
                .makeSectionListElementUIData(newUtil.fieldSelected.culturalPratice)

            return newUtil
        }
        
        private func makeSectionField(util: UtilHandlerSelectFieldOnListAction?) -> UtilHandlerSelectFieldOnListAction? {
            guard var newUtil = util else {
                return nil
            }
            
            newUtil.newSectionElementField = fieldService.makeSectionByField(newUtil.fieldSelected)
            return newUtil
        }

        private func newState(_ util: UtilHandlerSelectFieldOnListAction?) -> CulturalPracticeFormState? {
            guard let newUtil = util,
                let newSectionCuluralPractice = newUtil.newSectionElementCulturalPracrice,
                let newSectionField = newUtil.newSectionElementField else {
                    return nil
            }

            return newUtil.state.changeValues(
                currentField: newUtil.fieldSelected,
                sections: newSectionField,
                culturalPracticeElementSectionList: newSectionCuluralPractice,
                fieldElementSectionList: newSectionField,
                title: "Pratiques culturelles parcelle \(newUtil.fieldSelected.id)",
                isFinishCompletedCurrentContainer: true,
                responseAction: .selectFieldOnListActionResponse
            )
        }
    }

    private struct UtilHandlerSelectFieldOnListAction {
        var state: CulturalPracticeFormState
        var fieldSelected: Field
        var fieldDetailsFactory: FieldDetailsFactory
        var newSectionElementCulturalPracrice: [Section<ElementUIData>]?
        var newSectionElementField: [Section<ElementUIData>]?
    }
}
