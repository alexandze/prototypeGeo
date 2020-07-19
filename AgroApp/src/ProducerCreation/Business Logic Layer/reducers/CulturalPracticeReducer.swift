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
    public static func culturalPracticeReducer(action: Action, state: CulturalPracticeFormState?) -> CulturalPracticeFormState {
        var state = state ?? CulturalPracticeFormState(uuidState: UUID().uuidString)

        switch action {
        case let selectedFieldOnList as CulturalPracticeFormAction.SelectedFieldOnListAction:
            return CulturalPracticeReducerHandler.handle(
                selectedFieldOnListAction: selectedFieldOnList
            )
        case let addCulturalPracticeContainerAction as CulturalPracticeFormAction.AddCulturalPracticeInputMultiSelectContainer:
            CulturalPracticeReducerHandler.handle(
                addCulturalPracticeContainerAction: addCulturalPracticeContainerAction,
                state: state
            ).map { state = $0 }
        case let updateCulturalPracticeElement as CulturalPracticeFormAction.UpdateCulturalPracticeElementAction:
            CulturalPracticeReducerHandler.handle(
                updateCulturalPracticeElement: updateCulturalPracticeElement,
                state: state
            ).map { state = $0 }
        case let selectElementOnList as CulturalPracticeFormAction.WillSelectElementOnListAction:
            return CulturalPracticeReducerHandler.handle(willSelectElementOnList: selectElementOnList, state: state
            )
        default:
            break
        }

        return state
    }
}

class CulturalPracticeReducerHandler {
    static func handle(
        willSelectElementOnList: CulturalPracticeFormAction.WillSelectElementOnListAction,
        state: CulturalPracticeFormState
    ) -> CulturalPracticeFormState {
        let indexPathSelected = willSelectElementOnList.indexPath
        let culturalPracticeElement = state.sections![indexPathSelected.section].rowData[indexPathSelected.row]

        guard (culturalPracticeElement as? CulturalPracticeMultiSelectElement) != nil ||
            (culturalPracticeElement as? CulturalPracticeInputElement) != nil ||
            (culturalPracticeElement as? CulturalPracticeContainerElement) != nil else {
                return state.changeValues(
                    subAction: .canNotSelectElementOnList(culturalPracticeElement: culturalPracticeElement)
                )
        }

        return state.changeValues(subAction: .willSelectElementOnList(
            culturalPracticeElement: culturalPracticeElement,
            fieldType: state.currentField!
            )
        )
    }

    static func handle(updateCulturalPracticeElement: CulturalPracticeFormAction.UpdateCulturalPracticeElementAction, state: CulturalPracticeFormState) -> CulturalPracticeFormState? {
        let indexPathFind = findCulturalPracticeElementIndex(
            by: updateCulturalPracticeElement.culturalPracticeElementProtocol,
            state: state
        )

        return indexPathFind.map { indexPath in
            let newSections = update(
                sections: state.sections!,
                indexPath,
                updateCulturalPracticeElement.culturalPracticeElementProtocol
            )

            let isContainer = isContainerElement(
                culturalPracticeElement: updateCulturalPracticeElement.culturalPracticeElementProtocol
            )

            return state.changeValues(
                currentField: state.currentField,
                sections: newSections,
                subAction: .updateRows(indexPath: [indexPath]),
                isFinishCompletedCurrentContainer: isContainer ? true : state.isFinishCompletedCurrentContainer
            )
        }
    }

    private static func isContainerElement(culturalPracticeElement: CulturalPracticeElementProtocol) -> Bool {
        (culturalPracticeElement as? CulturalPracticeContainerElement) != nil
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
        state: CulturalPracticeFormState
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

    static func handle(selectedFieldOnListAction: CulturalPracticeFormAction.SelectedFieldOnListAction) -> CulturalPracticeFormState {
        switch selectedFieldOnListAction.fieldType {
        case .polygon(let fieldPolygone):
            let culturalPracticeElements = CulturalPractice
                .getCulturalPracticeElement(culturalPractice: fieldPolygone.culturalPratice)

            return CulturalPracticeFormState(
                uuidState: UUID().uuidString,
                currentField: selectedFieldOnListAction.fieldType,
                sections: createSection(by: culturalPracticeElements),
                subAction: .reloadData,
                title: "Pratiques culturelles parcelle \(fieldPolygone.id)"
            )

        case .multiPolygon(let fieldMultiPolygon):
            let culturalPracticeElements = CulturalPractice.getCulturalPracticeElement(culturalPractice: fieldMultiPolygon.culturalPratice)

            return CulturalPracticeFormState(
                uuidState: UUID().uuidString,
                currentField: selectedFieldOnListAction.fieldType,
                sections: createSection(by: culturalPracticeElements),
                subAction: .reloadData,
                title: "Pratiques culturelles parcelle \(fieldMultiPolygon.id)"
            )
        }
    }

    private static func createSection(by culturalPracticeElements: [CulturalPracticeElementProtocol]) -> [Section<CulturalPracticeElementProtocol>] {
        var sections: [Section<CulturalPracticeElementProtocol>] = []
        let countElement = culturalPracticeElements.count
        var indexSectionAdd: Int?
        // TODO refactoring
        (0..<countElement).forEach { index in
            switch culturalPracticeElements[index] {
            case let inputElement as CulturalPracticeInputElement:
                sections.append(Section(
                    sectionName: inputElement.title,
                    rowData: [inputElement]
                ))
            case let selectElement as CulturalPracticeMultiSelectElement:
                sections.append(Section(
                    sectionName: selectElement.title,
                    rowData: [selectElement]
                ))
            case let addElement as CulturalPracticeAddElement:
                sections.append(Section(
                    sectionName: addElement.title,
                    rowData: [addElement]
                ))

                indexSectionAdd = sections.count - 1
            case let containerElement as CulturalPracticeContainerElement:
                guard indexSectionAdd != nil else { return }
                sections[indexSectionAdd!].rowData.append(containerElement)
            default:
                break
            }
        }

        return sections
    }

    static func handle(
        addCulturalPracticeContainerAction: CulturalPracticeFormAction.AddCulturalPracticeInputMultiSelectContainer,
        state: CulturalPracticeFormState
    ) -> CulturalPracticeFormState? {

        guard let indexSectionDoseFumier = findSectionDoseFumier(sections: state.sections!) else {
            //TODO subAction not have section dose fumier
            return nil
        }

        guard state.isFinishCompletedCurrentContainer == nil || state.isFinishCompletedCurrentContainer! else {
            // TODO sub Action not completed container
            return nil
        }

        let totalDoseFumier = getTotalDoseFumier(indexSectionDoseFumier: indexSectionDoseFumier, sections: state.sections!)

        guard isPossibleAddFumierDose(currentTotalDose: totalDoseFumier) else {
            // TODO subAction can not add dose, because is max dose
            return nil
        }

        let inputMultiSelectContainer = createInputSelectContainer(totalDoseFumier: totalDoseFumier)

        // TODO refactoring
        return handleUpdateState(state: state) { (state: CulturalPracticeFormState) -> CulturalPracticeFormState in
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
                ]),
                isFinishCompletedCurrentContainer: false
            )
        }
    }

    //TODO util reducer
    static func handleUpdateState<T>(state: T, _ updateFunction: (T) -> T) -> T {
        updateFunction(state)
    }

    private static func createInputSelectContainer(totalDoseFumier: Int) -> CulturalPracticeContainerElement? {
        CulturalPractice.createCulturalPracticeInputMultiSelectContainer(
            index: totalDoseFumier
            ) as? CulturalPracticeContainerElement
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
}
