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
        case let selectedFieldOnList as CulturalPracticeListAction.SelectedFieldOnListAction:
            return CulturalPracticeReducerHandler.handle(selectedFieldOnListAction: selectedFieldOnList)
        case let addCulturalPracticeContainerAction as CulturalPracticeListAction.AddCulturalPracticeInputMultiSelectContainer:
            CulturalPracticeReducerHandler.handle(
                addCulturalPracticeContainerAction: addCulturalPracticeContainerAction,
                state: state
            ).map { state = $0 }
        case let updateCulturalPracticeElement as CulturalPracticeListAction.UpdateCulturalPracticeElement:
            CulturalPracticeReducerHandler.handle(
                updateCulturalPracticeElement: updateCulturalPracticeElement,
                state: state
            ).map { state = $0 }
        case let selectElementOnList as CulturalPracticeListAction.SelectElementOnListAction:
            return CulturalPracticeReducerHandler.handle(selectElementOnList: selectElementOnList, state: state)
        default:
            break
        }

        return state
    }
}

class CulturalPracticeReducerHandler {
    static func handle(
        selectElementOnList: CulturalPracticeListAction.SelectElementOnListAction,
        state: CulturalPracticeState
    ) -> CulturalPracticeState {
        let indexPathSelected = selectElementOnList.indexPath
        let culturalPracticeElement = state.sections![indexPathSelected.section].rowData[indexPathSelected.row]

        guard (culturalPracticeElement as? CulturalPracticeMultiSelectElement) != nil ||
            (culturalPracticeElement as? CulturalPracticeInputElement) != nil ||
            (culturalPracticeElement as? CulturalPracticeInputMultiSelectContainer) != nil else {
                return state.changeValues(
                    subAction: .canNotSelectElementOnList(culturalPracticeElement: culturalPracticeElement)
                )
        }

        return state.changeValues(subAction: .selectElementOnList(
            culturalPracticeElement: culturalPracticeElement,
            fieldType: state.currentField!
            )
        )
    }

    static func handle(updateCulturalPracticeElement: CulturalPracticeListAction.UpdateCulturalPracticeElement, state: CulturalPracticeState) -> CulturalPracticeState? {
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
                subAction: .updateRows(indexPath: [indexPath])
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

    static func handle(selectedFieldOnListAction: CulturalPracticeListAction.SelectedFieldOnListAction) -> CulturalPracticeState {
        switch selectedFieldOnListAction.fieldType {
        case .polygon(let fieldPolygone):
            let culturalPracticeElements = CulturalPractice.getCulturalPracticeElement(culturalPractice: fieldPolygone.culturalPratice)

            return CulturalPracticeState(
                uuidState: UUID().uuidString,
                currentField: selectedFieldOnListAction.fieldType,
                sections: createSection(by: culturalPracticeElements),
                subAction: .reloadData
            )

        case .multiPolygon(let fieldMultiPolygon):
            let culturalPracticeElements = CulturalPractice.getCulturalPracticeElement(culturalPractice: fieldMultiPolygon.culturalPratice)

            return CulturalPracticeState(
                uuidState: UUID().uuidString,
                currentField: selectedFieldOnListAction.fieldType,
                sections: createSection(by: culturalPracticeElements),
                subAction: .reloadData
            )
        }
    }

    private static func createSection(by culturalPracticeElements: [CulturalPracticeElementProtocol]) -> [Section<CulturalPracticeElementProtocol>] {
        culturalPracticeElements.map { (culturalPracticeElement: CulturalPracticeElementProtocol) -> Section<CulturalPracticeElementProtocol> in
            return Section<CulturalPracticeElementProtocol>(sectionName: culturalPracticeElement.title, rowData: [culturalPracticeElement])
        }
    }

    static func handle(
        addCulturalPracticeContainerAction: CulturalPracticeListAction.AddCulturalPracticeInputMultiSelectContainer,
        state: CulturalPracticeState
    ) -> CulturalPracticeState? {

        guard let indexSectionDoseFumier = findSectionDoseFumier(sections: state.sections!) else {
            //TODO subAction not have section dose fumier
            return nil
        }

        let totalDoseFumier = getTotalDoseFumier(indexSectionDoseFumier: indexSectionDoseFumier, sections: state.sections!)

        guard isPossibleAddFumierDose(currentTotalDose: totalDoseFumier) else {
            // TODO subAction can not add dose, because is max dose
            return nil
        }

        let inputMultiSelectContainer = createInputSelectContainer(totalDoseFumier: totalDoseFumier)

        // TODO refactoring
        return handleUpdateState(state: state) { (state: CulturalPracticeState) -> CulturalPracticeState in
            var copySection = state.sections!
            copySection[indexSectionDoseFumier].rowData.append(inputMultiSelectContainer!)

            return state.changeValues(
                sections: copySection,
                subAction: .insertRows(
                    indexPath: [
                        IndexPath(
                            row: copySection[indexSectionDoseFumier].rowData.count - 1,
                            section: indexSectionDoseFumier
                        )
                ]))
        }
    }

    //TODO util reducer
    static func handleUpdateState<T>(state: T, _ updateFunction: (T) -> T) -> T {
        updateFunction(state)
    }

    private static func createInputSelectContainer(totalDoseFumier: Int) -> CulturalPracticeInputMultiSelectContainer? {
        CulturalPractice.createCulturalPracticeInputMultiSelectContainer(
                index: totalDoseFumier
        ) as? CulturalPracticeInputMultiSelectContainer
    }

    private static func isPossibleAddFumierDose(currentTotalDose: Int) -> Bool {
        currentTotalDose < CulturalPractice.MAX_DOSE_FUMIER
    }

    private static func findSectionDoseFumier(sections: [Section<CulturalPracticeElementProtocol>]) -> Int? {
        return sections.firstIndex { (section: Section<CulturalPracticeElementProtocol>) -> Bool in
            guard !(section.rowData.isEmpty) &&
                (section.rowData[0] as? CulturalPracticeAddElement) != nil else { return false }
            return true
        }
    }

    private static func getTotalDoseFumier(indexSectionDoseFumier: Int, sections: [Section<CulturalPracticeElementProtocol>]) -> Int {
        // minus one because in this section there is a row for button add dose fumier
        (sections[indexSectionDoseFumier].rowData.count - 1)
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
}