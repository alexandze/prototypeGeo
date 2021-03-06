//
//  CulturalPracticeFormState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct SelectFormCulturalPracticeState: Equatable {
    static func == (lhs: SelectFormCulturalPracticeState, rhs: SelectFormCulturalPracticeState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var selectElement: SelectElement?
    var section: Section<ElementUIData>?
    var field: Field?
    var actionResponse: SelectFormCulturalPracticeActionResponse?

    func changeValue(
        selectElement: SelectElement? = nil,
        section: Section<ElementUIData>? = nil,
        field: Field? = nil,
        actionResponse: SelectFormCulturalPracticeActionResponse? = nil
    ) -> SelectFormCulturalPracticeState {
        SelectFormCulturalPracticeState(
            uuidState: UUID().uuidString,
            selectElement: selectElement ?? self.selectElement,
            section: section ?? self.section,
            field: field ?? self.field,
            actionResponse: actionResponse ?? self.actionResponse
        )
    }
    
    func reset() -> SelectFormCulturalPracticeState {
        SelectFormCulturalPracticeState(
            uuidState: UUID().uuidString,
            selectElement: nil,
            section: nil,
            field: nil,
            actionResponse: .notResponse
        )
    }

    enum SelectFormCulturalPracticeActionResponse {
        case selectElementSelectedOnListActionResponse(currentIndexRow: Int)
        case closeSelectFormWithSaveActionResponse
        case closeSelectFormWithoutSaveAction
        case checkIfFormIsDirtyActionResponse(isDirty: Bool)
        case notResponse
    }
}
