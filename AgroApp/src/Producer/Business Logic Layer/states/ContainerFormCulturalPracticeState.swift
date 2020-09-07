//
//  ContainerFormCulturalPracticeState.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-09.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct ContainerFormCulturalPracticeState: Equatable {
    static func == (lhs: ContainerFormCulturalPracticeState, rhs: ContainerFormCulturalPracticeState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var field: Field?
    var section: Section<ElementUIData>?
    var elementUIDataObservableList: [ElementUIDataObservable]?
    var isFormValid: Bool?
    var actionResponse: ActionResponse?

    enum ActionResponse {
        case containerElementSelectedOnListActionResponse
        case checkIfFormIsDirtyAndValidAction(isPrintAlert: Bool)
        case checkIfInputValueIsValidActionResponse(indexElementUIData: Int)
        case closeContainerFormWithSaveActionResponse
        case closeContainerFormWithoutSaveActionResponse
    }

    func changeValue(
        field: Field? = nil,
        section: Section<ElementUIData>? = nil,
        elementUIDataObservableList: [ElementUIDataObservable]? = nil,
        isFormValid: Bool? = nil,
        actionResponse: ActionResponse
    ) -> ContainerFormCulturalPracticeState {
        ContainerFormCulturalPracticeState(
            uuidState: UUID().uuidString,
            field: field ?? self.field,
            section: section ?? self.section,
            elementUIDataObservableList: elementUIDataObservableList ?? self.elementUIDataObservableList,
            isFormValid: isFormValid ?? self.isFormValid,
            actionResponse: actionResponse
        )
    }
}
