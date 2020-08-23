//
//  FieldListReducer.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-17.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    static func fieldListReducer(action: Action, state: FieldListState?) -> FieldListState {
        let state = state ?? FieldListState(uuidState: UUID().uuidString, fieldList: [])

        switch action {
        case let selectedFieldOnMapAction as MapFieldAction.WillSelectedFieldOnMapAction:
            return FieldListReducerHandler
                .HandlerDidSelectedFieldOnMapAction().handle(action: selectedFieldOnMapAction, state)
        case let deselectFieldOnMap as MapFieldAction.WillDeselectFieldOnMapAction:
            return FieldListReducerHandler().handle(delectFieldOnMapAction: deselectFieldOnMap, state)
        case let selectFieldOnListAction as FieldListAction.SelectFieldOnListAction:
            return FieldListReducerHandler().handle(selectFieldOnListAction: willSelectFieldOnListAction, state)
        case let isAppearAction as FieldListAction.IsAppearAction:
            return FieldListReducerHandler().handle(isAppearAction: isAppearAction, state)
        case let updateFieldAction as FieldListAction.UpdateFieldAction:
            return FieldListReducerHandler
                .HandlerUpdateFieldAction().handle(action: updateFieldAction, state)
        case let removeFieldAction as FieldListAction.RemoveFieldAction:
            return FieldListReducerHandler
                .HandlerRemoveFieldAction().handle(action: removeFieldAction, state)
        default:
            return state
        }
    }
}

class FieldListReducerHandler {
    func handle(
        willSelectFieldOnListAction: FieldListAction.SelectFieldOnListAction,
        _ state: FieldListState
    ) -> FieldListState {
        let fieldSelected = willSelectFieldOnListAction.field

        return state.changeValue(
            currentField: fieldSelected,
            subAction: .willSelectFieldOnListActionSucccess
        )
    }

    func handle(
        isAppearAction: FieldListAction.IsAppearAction,
        _ state: FieldListState
    ) -> FieldListState {
        state.changeValue(subAction: .isAppearActionSuccess, isAppear: isAppearAction.isAppear)
    }

    func handle(
        delectFieldOnMapAction: MapFieldAction.WillDeselectFieldOnMapAction,
        _ state: FieldListState
    ) -> FieldListState {
        let fieldToRemove = delectFieldOnMapAction.field
        let fieldList = state.fieldList ?? []
        let index = findIndexFieldByIdField(idField: fieldToRemove.id, fieldList: fieldList)

        let newFieldListState = index.map { (index: Int) -> FieldListState in
            return handleRemoveFieldInState(state: state, index: index)
        }

        return newFieldListState != nil ? newFieldListState! : state
    }

    private func setCulturalPractice(
        state: CulturalPracticeFormState,
        _ sectionIndex: Int,
        _ inputMultiSelectContainer: CulturalPracticeElementProtocol
    ) -> CulturalPracticeFormState {
        var copyState = state

        copyState.sections![sectionIndex].rowData.append(inputMultiSelectContainer)
        copyState.uuidState = UUID().uuidString

        copyState.responseAction = .insertContainerElementResponse(indexPath: [
            IndexPath(
                row: copyState.sections![sectionIndex].rowData.count - 1,
                section: sectionIndex
            )
            ]
        )

        return copyState
    }

    private func handleRemoveFieldInState(state: FieldListState, index: Int) -> FieldListState {
        var fieldArray = state.fieldList
        let removed = fieldArray?.remove(at: index)

        return state.changeValue(
            fieldList: fieldArray,
            currentField: removed,
            indexForRemove: index,
            subAction: .deselectedFieldOnMapActionSuccess
        )
    }

    private func findIndexFieldByIdField(idField: Int, fieldList: [Field]) -> Int? {
        fieldList.firstIndex { $0.id == idField }
    }
}
