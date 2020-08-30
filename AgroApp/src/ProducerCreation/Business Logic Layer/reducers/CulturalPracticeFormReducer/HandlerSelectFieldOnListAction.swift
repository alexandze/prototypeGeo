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

        init(fieldDetailsFactory: FieldDetailsFactory = FieldDetailsFactoryImpl()) {
            self.fieldDetailsFactory = fieldDetailsFactory
        }

        func handle(action: FieldListAction.SelectFieldOnListAction, _ state: CulturalPracticeFormState) -> CulturalPracticeFormState {
            let util = UtilHandlerSelectFieldOnListAction(
                state: state,
                fieldSelected: action.field,
                fieldDetailsFactory: fieldDetailsFactory
            )

            return (
                makeSection(_:) >>>
                    newState(_:)
                )(util) ?? state
        }

        private func makeSection(_ util: UtilHandlerSelectFieldOnListAction?) -> UtilHandlerSelectFieldOnListAction? {
            guard var newUtil = util else { return nil }

            if newUtil.fieldSelected.culturalPratice == nil {
                newUtil.fieldSelected.culturalPratice = CulturalPractice(id: newUtil.fieldSelected.id)
            }

            newUtil.newSectionElementUIData = newUtil
                .fieldDetailsFactory
                .makeSectionListElementUIData(newUtil.fieldSelected.culturalPratice)

            return newUtil
        }

        private func newState(_ util: UtilHandlerSelectFieldOnListAction?) -> CulturalPracticeFormState? {
            guard let newUtil = util,
                let newSectionElementUIData = newUtil.newSectionElementUIData else {
                    return nil
            }

            return newUtil.state.changeValues(
                currentField: newUtil.fieldSelected,
                sections: newSectionElementUIData,
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
        var newSectionElementUIData: [Section<ElementUIData>]?
    }
}
