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
            CulturalPracticeReducerHandler.handle(
                addCulturalPracticeContainerAction: addCulturalPracticeContainerAction,
                state: state
            ).map { state = $0 }
        case let updateCulturalPracticeElement as CulturalPracticeAction.UpdateCulturalPracticeElement:
            CulturalPracticeReducerHandler.handle(
                updateCulturalPracticeElement: updateCulturalPracticeElement,
                state: state
            ).map { state = $0 }
        default:
            break
        }

        return state
    }
}

class CulturalPracticeReducerHandler {
    static func handle(updateCulturalPracticeElement: CulturalPracticeAction.UpdateCulturalPracticeElement, state: CulturalPracticeState) -> CulturalPracticeState? {
        let indexPathFind = findCulturalPracticeElementIndex(
            by: updateCulturalPracticeElement.culturalPracticeElementProtocol,
            state: state
        )

        return indexPathFind.map { indexPath in
            let newSections = update(sections: state.sections!, indexPath, updateCulturalPracticeElement.culturalPracticeElementProtocol)

            return CulturalPracticeState(
                uuidState: UUID().uuidString,
                currentField: state.currentField,
                sections: newSections,
                culturalPracticeSubState: .updateRows(indexPath: [indexPath])
            )
        }
    }

    static private func update(
        sections: [Section<CulturalPracticeElementProtocol>],
        _ indexPath: IndexPath,
        _ culturalPracticeElementProtocol: CulturalPracticeElementProtocol) -> [Section<CulturalPracticeElementProtocol>] {
        var copySection = sections
        copySection[indexPath.section].rowData[indexPath.row] = culturalPracticeElementProtocol
        return copySection
    }

    static private func findCulturalPracticeElementIndex(
        by culturalPracticeElementProtocol: CulturalPracticeElementProtocol,
        state: CulturalPracticeState
    ) -> IndexPath? {
        if let sections = state.sections {
            var firstIndexRow: Int?

            let firstIndexSection = sections.firstIndex { section in
                firstIndexRow = section.rowData.firstIndex { culturalPracticeElement in
                    return culturalPracticeElementProtocol.key == culturalPracticeElement.key
                }

                return firstIndexRow != nil
            }

            return firstIndexRow != nil && firstIndexSection != nil
                ? IndexPath(row: firstIndexRow!, section: firstIndexSection!)
                : nil
        }

        return nil
    }

    static func handle(selectedFieldOnListAction: CulturalPracticeAction.SelectedFieldOnListAction) -> CulturalPracticeState {
        switch selectedFieldOnListAction.fieldType {
        case .polygon(let fieldPolygone):
            let culturalPracticeElements = CulturalPractice.getCulturalPracticeElement(culturalPractice: fieldPolygone.culturalPratice)

            return CulturalPracticeState(
                uuidState: UUID().uuidString,
                currentField: selectedFieldOnListAction.fieldType,
                sections: createSection(by: culturalPracticeElements),
                culturalPracticeSubState: .reloadData
            )

        case .multiPolygon(let fieldMultiPolygon):
            let culturalPracticeElements = CulturalPractice.getCulturalPracticeElement(culturalPractice: fieldMultiPolygon.culturalPratice)

            return CulturalPracticeState(
                uuidState: UUID().uuidString,
                currentField: selectedFieldOnListAction.fieldType,
                sections: createSection(by: culturalPracticeElements),
                culturalPracticeSubState: .reloadData
            )
        }
    }

    private static func createSection(by culturalPracticeElements: [CulturalPracticeElementProtocol]) -> [Section<CulturalPracticeElementProtocol>] {
        culturalPracticeElements.map { (culturalPracticeElement: CulturalPracticeElementProtocol) -> Section<CulturalPracticeElementProtocol> in
            return Section<CulturalPracticeElementProtocol>(sectionName: culturalPracticeElement.title, rowData: [culturalPracticeElement])
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

    private static func findAddElementIndex(from sections: [Section<CulturalPracticeElementProtocol>]) -> Int? {
        sections.firstIndex(where: { (section: Section<CulturalPracticeElementProtocol>) -> Bool in
            guard !(section.rowData.isEmpty),
                (section.rowData[0] as? CulturalPracticeAddElement) != nil
                else {
                    return false
                }

            return true
        })
    }

    private static func setCulturalPractice(
        state: CulturalPracticeState,
        _ sectionIndex: Int,
        _ inputMultiSelectContainer: CulturalPracticeElementProtocol
    ) -> CulturalPracticeState {
        var copyState = state

        copyState.sections![sectionIndex].rowData.append(inputMultiSelectContainer)
        copyState.uuidState = UUID().uuidString
        copyState.culturalPracticeSubState = .insertRows(indexPath: [
            IndexPath(
                row: copyState.sections![sectionIndex].rowData.count - 1,
                section: sectionIndex
            )
            ]
        )

        return copyState
    }
}
