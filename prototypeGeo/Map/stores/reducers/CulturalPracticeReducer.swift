//
//  CulturalPracticeReducer.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func culturalPracticeReducer(action: Action, state: CulturalPracticeState?) -> CulturalPracticeState {
        var state = state ?? CulturalPracticeState(uuidState: UUID().uuidString)
        
        switch action {
        case let selectedFieldOnList as CulturalPracticeAction.SelectedFieldOnListAction:
            return CulturalPracticeReducerHandler.handle(selectedFieldOnListAction: selectedFieldOnList)
        case let addCulturalPracticeContainerAction as CulturalPracticeAction.AddCulturalPracticeInputMultiSelectContainer:
          let stateNew =  CulturalPracticeReducerHandler.handle(
                addCulturalPracticeContainerAction: addCulturalPracticeContainerAction,
                state: state
            )
          if stateNew != nil {
            return stateNew!
            }
        default:
            break
        }
        
        return state
    }
}

class CulturalPracticeReducerHandler {
    static func handle(selectedFieldOnListAction: CulturalPracticeAction.SelectedFieldOnListAction) -> CulturalPracticeState {
        switch selectedFieldOnListAction.fieldType {
        case .polygon(let fieldPolygone):
            let culturalPracticeElements = CulturalPractice.getCulturalPracticeElement(culturalPractice: fieldPolygone.culturalPratice)

            return CulturalPracticeState(
                uuidState: UUID().uuidString,
                currentField: selectedFieldOnListAction.fieldType,
                sections: createSection(by: culturalPracticeElements),
                tableState: .reloadData
            )

        case .multiPolygon(let fieldMultiPolygon):
            let culturalPracticeElements = CulturalPractice.getCulturalPracticeElement(culturalPractice: fieldMultiPolygon.culturalPratice)

            return CulturalPracticeState(
                uuidState: UUID().uuidString,
                currentField: selectedFieldOnListAction.fieldType,
                sections: createSection(by: culturalPracticeElements),
                tableState: .reloadData
            )
        }
    }
    
    private static func createSection(by culturalPracticeElements: [CulturalPracticeElement]) -> [Section<CulturalPracticeElement>] {
        culturalPracticeElements.map { (culturalPracticeElement: CulturalPracticeElement) -> Section<CulturalPracticeElement> in
            switch culturalPracticeElement {
            case .culturalPracticeMultiSelectElement(let multiSelectElement):
                return Section<CulturalPracticeElement>(sectionName: multiSelectElement.title, rowData: [culturalPracticeElement])
            case .culturalPracticeAddElement(let addElement):
                return Section<CulturalPracticeElement>(sectionName: addElement.title, rowData: [culturalPracticeElement])
            case .culturalPracticeInputElement(let inputElement):
                return Section<CulturalPracticeElement>(sectionName: inputElement.title, rowData: [culturalPracticeElement])
            case .culturalPracticeInputMultiSelectContainer(let containerInputMultiSelect):
                return Section<CulturalPracticeElement>(sectionName: containerInputMultiSelect.title, rowData: [culturalPracticeElement])
            }
        }
    }
    
    static func handle(
        addCulturalPracticeContainerAction: CulturalPracticeAction.AddCulturalPracticeInputMultiSelectContainer,
        state: CulturalPracticeState
    ) -> CulturalPracticeState? {
        let sectionIndex = findAddElementIndex(from: state.sections!)

        if sectionIndex != nil {
            let inputMultiSelectContainer = CulturalPractice
            .createCulturalPracticeInputMultiSelectContainer(
                index: addCulturalPracticeContainerAction.index
            )

            return setCulturalPractice(state: state, sectionIndex!, inputMultiSelectContainer)
        }

        return nil
    }
    
    private static func findAddElementIndex(from sections: [Section<CulturalPracticeElement>]) -> Int? {
        sections.firstIndex(where: { (section: Section<CulturalPracticeElement>) -> Bool in
            guard !(section.rowData.isEmpty),
                case CulturalPracticeElement.culturalPracticeAddElement(_) = section.rowData[0]
                else {
                    return false
                }

            return true
        })
    }
    
    private static func setCulturalPractice(
        state: CulturalPracticeState,
        _ sectionIndex: Int,
        _ inputMultiSelectContainer: CulturalPracticeElement
    ) -> CulturalPracticeState {
        var copyState = state

        copyState.sections![sectionIndex].rowData.append(inputMultiSelectContainer)
        copyState.uuidState = UUID().uuidString
        copyState.tableState = .insertRows(indexPath: [
            IndexPath(
                row: copyState.sections![sectionIndex].rowData.count - 1,
                section: sectionIndex
            )
            ]
        )

        return copyState
    }
}
