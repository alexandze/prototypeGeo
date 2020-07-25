//
//  CulturalPracticeFormReducer.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func selectFormCulturalPracticeReducer(action: Action, state: SelectFormCulturalPracticeState?) -> SelectFormCulturalPracticeState {
        let state = state ?? SelectFormCulturalPracticeState(uuidState: UUID().uuidString)

        switch action {
        case let selectedElementOnList as SelectFormCulturalPracticeAction.SelectElementSelectedOnList:
            return CulturalPracticeFormReducerHandler().handle(selectedElementOnList: selectedElementOnList)
        case let setFormIsDirtyAction as SelectFormCulturalPracticeAction.SetFormIsDirtyAction:
            return CulturalPracticeFormReducerHandler().handleUpdateState(state: state) { (state: SelectFormCulturalPracticeState) -> SelectFormCulturalPracticeState in
                state.changeValue(isDirty: setFormIsDirtyAction.isDirty, culturalPracticeSubAction: .formIsDirty)
            }
        case let closedPresentedViewControllerAction as SelectFormCulturalPracticeAction.ClosePresentedViewControllerAction:
            return CulturalPracticeFormReducerHandler().handle(
                closePresentedViewControllerAction: closedPresentedViewControllerAction,
                state: state
            )
        case let closePresentedViewControllerWithSaveAction as SelectFormCulturalPracticeAction.ClosePresentedViewControllerWithSaveAction:
            return CulturalPracticeFormReducerHandler().handle(
                closePresentedViewControllerWithSaveAction: closePresentedViewControllerWithSaveAction,
                state: state
            )
        case _ as SelectFormCulturalPracticeAction.ClosePresentedViewControllerWithoutSaveAction:
            return CulturalPracticeFormReducerHandler().handleUpdateState(state: state) {state in state.changeValue(culturalPracticeSubAction: .closeWithoutSave) }
        default:
            break
        }

        return state
    }
}

class CulturalPracticeFormReducerHandler {

    func handle(
        closePresentedViewControllerWithSaveAction: SelectFormCulturalPracticeAction.ClosePresentedViewControllerWithSaveAction,
        state: SelectFormCulturalPracticeState
    ) -> SelectFormCulturalPracticeState {
        let indexSelected = closePresentedViewControllerWithSaveAction.indexSelected
        let culturalPraticeValue = findCulturalPracticeValueByIndex(culturalPraticeElementProtocol: state.culturalPraticeElement!, index: indexSelected)?.0

        return handleUpdateState(state: state) { (state: SelectFormCulturalPracticeState) -> SelectFormCulturalPracticeState in
            if culturalPraticeValue != nil,
                var culturalPraticeSelectElement = state.culturalPraticeElement as? CulturalPracticeMultiSelectElement {
                culturalPraticeSelectElement.value = culturalPraticeValue

                return state.changeValue(
                    culturalPraticeElement: culturalPraticeSelectElement,
                    culturalPracticeSubAction: .closeWithSave
                )
            }

            return state
        }
    }

    func handle(selectedElementOnList: SelectFormCulturalPracticeAction.SelectElementSelectedOnList) -> SelectFormCulturalPracticeState {
        SelectFormCulturalPracticeState(
            uuidState: UUID().uuidString,
            culturalPraticeElement: selectedElementOnList.culturalPracticeElement,
            field: selectedElementOnList.field,
            selectFormCulturalParacticeSubAction: selectedElementOnList.subAction
        )
    }

    func handle(
        closePresentedViewControllerAction: SelectFormCulturalPracticeAction.ClosePresentedViewControllerAction,
        state: SelectFormCulturalPracticeState

    ) -> SelectFormCulturalPracticeState {
        if let isDirty = state.isDirty, isDirty {
            return state.changeValue(culturalPracticeSubAction: .printAlert)
        }

        return state.changeValue(culturalPracticeSubAction: .closeWithoutSave)
    }

    private func findCulturalPracticeValueByIndex(
        culturalPraticeElementProtocol: CulturalPracticeElementProtocol,
        index: Int) -> (CulturalPracticeValueProtocol, String)? {
        if let selectElement = culturalPraticeElementProtocol as? CulturalPracticeMultiSelectElement {
            return selectElement.tupleCulturalTypeValue[index]
        }

        return nil
    }

    //TODO util reducerHandle
    func handleUpdateState<T>(state: T, _ updateFunction: (T) -> T) -> T {
        updateFunction(state)
    }
}
