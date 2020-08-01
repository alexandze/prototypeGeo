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
        case let didSelectedFieldOnMapAction as MapFieldAction.DidSelectedFieldOnMapAction:
            return FieldListReducerHandler().handle(didSelectedFieldOnMapAction: didSelectedFieldOnMapAction, state)
        case let didDeselectFieldOnMap as MapFieldAction.DidDelectFieldOnMapAction:
            return FieldListReducerHandler().handle(didDelectFieldOnMapAction: didDeselectFieldOnMap, state)
        case let willSelectFieldOnListAction as FieldListAction.WillSelectFieldOnListAction:
            return FieldListReducerHandler().handle(willSelectFieldOnListAction: willSelectFieldOnListAction, state)
        case let isAppearAction as FieldListAction.IsAppearAction:
            return FieldListReducerHandler().handle(isAppearAction: isAppearAction, state)
        case let updateFieldAction as FieldListAction.UpdateFieldAction:
            return HandlerUpdateFieldAction().handle(action: updateFieldAction, state)
        case let removeFieldAction as FieldListAction.RemoveFieldAction:
            return HandlerRemoveFieldAction().handle(action: removeFieldAction, state)
        default:
            return state
        }
    }
}

class FieldListReducerHandler {
    func handle(
        willSelectFieldOnListAction: FieldListAction.WillSelectFieldOnListAction,
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
        didSelectedFieldOnMapAction: MapFieldAction.DidSelectedFieldOnMapAction,
        _ state: FieldListState
        ) -> FieldListState {
        let secondArray = state.fieldList != nil ? state.fieldList! : []
        var firstArray = [didSelectedFieldOnMapAction.field]
        firstArray += secondArray

        return state.changeValue(
            fieldList: firstArray,
            currentField: didSelectedFieldOnMapAction.field,
            subAction: .selectedFieldOnMapActionSuccess
        )
    }

    func handle(
        didDelectFieldOnMapAction: MapFieldAction.DidDelectFieldOnMapAction,
        _ state: FieldListState
    ) -> FieldListState {
        let fieldToRemove = didDelectFieldOnMapAction.field
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
        copyState.subAction = .insertRows(indexPath: [
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
