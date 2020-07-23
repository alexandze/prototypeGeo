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
        case let selectedFieldOnMapAction as MapFieldAction.SelectedFieldOnMapAction:
            return FieldListReducerHandler
                .handle(selectedFieldOnMapAction: selectedFieldOnMapAction, state)
        case let deselectedFieldOnMap as MapFieldAction.DeselectedFieldOnMapAction:
            return FieldListReducerHandler.handle(deselectedFieldOnMapAction: deselectedFieldOnMap, state)
        case let willSelectFieldOnListAction as FieldListAction.WillSelectFieldOnListAction:
            return FieldListReducerHandler.handle(willSelectFieldOnListAction: willSelectFieldOnListAction, state)
        case let isAppearAction as FieldListAction.IsAppearAction:
            return FieldListReducerHandler.handle(isAppearAction: isAppearAction, state)
        case let updateElementAction as CulturalPracticeFormAction.UpdateCulturalPracticeElementAction:
            return FieldListReducerHandler.handle(
                updateCulturalPracticeElementAction: updateElementAction,
                state
            )
        default:
            return state
        }
    }
}

class FieldListReducerHandler {

    static func handle(
        updateCulturalPracticeElementAction : CulturalPracticeFormAction.UpdateCulturalPracticeElementAction,
        _ state: FieldListState
    ) -> FieldListState {
        switch updateCulturalPracticeElementAction.culturalPracticeElementProtocol {
        case let inputElement as CulturalPracticeInputElement:
            return handleUpdateFieldForInputAndSelect(inputElement, updateCulturalPracticeElementAction.fieldType, state)
        case let selectElement as CulturalPracticeMultiSelectElement:
            return handleUpdateFieldForInputAndSelect(selectElement, updateCulturalPracticeElementAction.fieldType, state)
        case let containerElement as CulturalPracticeContainerElement:
            return handleUpdateFieldForContainerElement(
                containerElement,
                updateCulturalPracticeElementAction.fieldType,
                state
            )
        default:
            break
        }
        return state
    }

    static private func handleUpdateFieldForInputAndSelect(_ culturalPracticeElement: CulturalPracticeElementProtocol, _ fieldType: FieldType, _ state: FieldListState) -> FieldListState {
        guard let fieldTypeFindTuple = findFieldTypeById(state.fieldList!, fieldType.getId()),
        let culturalPracticeValue = culturalPracticeElement.value
            else { return state }

        let culturalPractice = fieldTypeFindTuple.0.getCulturalPractice() ?? CulturalPractice(id: fieldTypeFindTuple.0.getId())

        let newCulturalPracticeValue = culturalPracticeValue.changeValueOfCulturalPractice(
            culturalPractice,
            index: culturalPracticeElement.getIndex()
        )

        let fieldTypeNew = fieldTypeFindTuple.0.changeValue(culturalPractice: newCulturalPracticeValue)
        var newFieldList = state.fieldList!
        newFieldList[fieldTypeFindTuple.1] = fieldTypeNew

        return state.changeValue(
            fieldList: newFieldList,
            subAction: .updateFieldSuccess,
            indexForUpdate: fieldTypeFindTuple.1
        )
    }

    static private func handleUpdateFieldForContainerElement(
        _ containerElement: CulturalPracticeContainerElement,
        _ fieldType: FieldType,
        _ state: FieldListState
    ) -> FieldListState {
        // TODO refactoring
        let countInputElement = containerElement.culturalInputElement.count
        var previousState = state
        let countSelectElement = containerElement.culturalPracticeMultiSelectElement.count

        (0..<countInputElement).forEach { index in
            previousState = handleUpdateFieldForInputAndSelect(
                containerElement.culturalInputElement[index], fieldType, previousState)
        }

        (0..<countSelectElement).forEach { index in
            previousState = handleUpdateFieldForInputAndSelect(
                containerElement.culturalPracticeMultiSelectElement[index],
                fieldType, previousState
            )
        }

        return previousState
    }

    static private func findFieldTypeById(_ fieldTypes: [FieldType],_ id: Int) -> (FieldType, Int)? {
        let indexFind = fieldTypes.firstIndex { $0.getId() == id }
        return indexFind.map {  (fieldTypes[$0], $0) }
    }

    static func handle(
        willSelectFieldOnListAction: FieldListAction.WillSelectFieldOnListAction,
        _ state: FieldListState
    ) -> FieldListState {
        let fieldSelected = willSelectFieldOnListAction.field
        return state.changeValue(
            currentField: fieldSelected,
            subAction: .willSelectFieldOnListActionSucccess
        )
    }

    static func handle(
        isAppearAction: FieldListAction.IsAppearAction,
        _ state: FieldListState
    ) -> FieldListState {
        state.changeValue(subAction: .isAppearActionSuccess, isAppear: isAppearAction.isAppear)
    }

    static func handle(
        selectedFieldOnMapAction: MapFieldAction.SelectedFieldOnMapAction,
        _ state: FieldListState
        ) -> FieldListState {
        let secondArray = state.fieldList != nil ? state.fieldList! : []
        var firstArray = [selectedFieldOnMapAction.fieldType]
        firstArray += secondArray

        return state.changeValue(
            fieldList: firstArray,
            currentField: selectedFieldOnMapAction.fieldType,
            subAction: .selectedFieldOnMapActionSuccess
        )
    }

    static func handle(
        deselectedFieldOnMapAction: MapFieldAction.DeselectedFieldOnMapAction,
        _ state: FieldListState
    ) -> FieldListState {
        let fieldToRemove = deselectedFieldOnMapAction.fieldType
        let fieldList = state.fieldList != nil ? state.fieldList! : []
        let index = findIndexFieldByIdField(idField: fieldToRemove.getId(), fieldList: fieldList)

        let newFieldListState = index.map { (index: Int) -> FieldListState in
            return handleRemoveFieldInState(state: state, index: index)
        }

        return newFieldListState != nil ? newFieldListState! : state
    }

    private static func setCulturalPractice(
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

    private static func handleRemoveFieldInState(state: FieldListState, index: Int) -> FieldListState {
        var fieldArray = state.fieldList
        let removed = fieldArray?.remove(at: index)

        return state.changeValue(
            fieldList: fieldArray,
            currentField: removed,
            indexForRemove: index,
            subAction: .deselectedFieldOnMapActionSuccess
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
