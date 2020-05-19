//
//  MapFieldReducer.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func mapFieldReducer(action: Action, state: MapState?) -> MapState {
        var state = state ?? MapState()

        switch action {
        case let getAllMapFieldSuccess as MapFieldAction.GetAllFieldSuccess :
            state.mapFieldAllFieldsState = getAllMapFieldSuccess.mapFieldAllFieldState
        case let selectedFieldOnMapAction as MapFieldAction.SelectedFieldOnMapAction:
            state.fieldListState =
                MapFieldReducerHandler.handleSelectedFieldAction(
                    state: state,
                    selectedFieldOnMapAction: selectedFieldOnMapAction
            )
        case let deselectedFieldOnMap as MapFieldAction.DeselectedFieldOnMapAction:
            MapFieldReducerHandler.handleDeselectedFieldAction(
                state: state,
                deselectedFieldOnMapAction: deselectedFieldOnMap)
                .map {
                    state.fieldListState = $0
                }
        default:
            break
        }

        return state
    }
}

class MapFieldReducerHandler {
    static func handleSelectedFieldAction(
        state: MapState,
        selectedFieldOnMapAction:
        MapFieldAction.SelectedFieldOnMapAction) -> FieldListState {
        let secondArray = state.fieldListState.fieldList
        var firstArray = [selectedFieldOnMapAction.fieldType]
        firstArray += secondArray
        let uuid = UUID().uuidString

        return FieldListState(
            uuidState: uuid,
            fieldList: firstArray,
            currentField: selectedFieldOnMapAction.fieldType,
            isForRemove: false,
            indexForRemove: -1
        )
    }

    static func handleDeselectedFieldAction(
        state: MapState,
        deselectedFieldOnMapAction: MapFieldAction.DeselectedFieldOnMapAction
    ) -> FieldListState? {
        let fieldToRemove = deselectedFieldOnMapAction.fieldType
        let fieldList = state.fieldListState.fieldList

        switch fieldToRemove {
        case .polygon(let fieldPolygon):
            let index = findIndexFieldByIdField(idField: fieldPolygon.id, fieldList: fieldList)
            return index.map { (index: Int) -> FieldListState in
                return handleRemoveFieldInState(fieldList: fieldList, index: index)
            }
        case .multiPolygon(let fieldMultiPolygon):
            let index = findIndexFieldByIdField(idField: fieldMultiPolygon.id, fieldList: fieldList)
            return index.map { (index: Int) -> FieldListState in
                return handleRemoveFieldInState(fieldList: fieldList, index: index)
            }
        }
    }

    private static func setCulturalPractice(
        state: CulturalPracticeState,
        _ sectionIndex: Int,
        _ inputMultiSelectContainer: CulturalPracticeElementProtocol
    ) -> CulturalPracticeState {
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

    private static func handleRemoveFieldInState(fieldList: [FieldType], index: Int) -> FieldListState {
        let uuid = UUID().uuidString
        var fieldArray = fieldList
        let removed = fieldArray.remove(at: index)

        return FieldListState(
            uuidState: uuid,
            fieldList: fieldArray,
            currentField: removed,
            isForRemove: true,
            indexForRemove: index
        )
    }

    private static func findIndexFieldByIdField(idField: Int, fieldList: [FieldType]) -> Int? {
        fieldList.firstIndex {
            switch $0 {
            case .polygon(let fieldPolygon):
                return fieldPolygon.id == idField
            case .multiPolygon(let multiPolygon):
                return multiPolygon.id == idField
            }
        }
    }
}
