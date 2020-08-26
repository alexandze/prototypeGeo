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
    var isDirty: Bool?
    var actionResponse: SelectFormCulturalPracticeActionResponse?

    func changeValue(
        selectElement: SelectElement? = nil,
        section: Section<ElementUIData>? = nil,
        field: Field? = nil,
        isDirty: Bool? = nil,
        actionResponse: SelectFormCulturalPracticeActionResponse? = nil
    ) -> SelectFormCulturalPracticeState {
        SelectFormCulturalPracticeState(
            uuidState: UUID().uuidString,
            selectElement: selectElement ?? self.selectElement,
            section: section ?? self.section,
            field: field ?? self.field,
            isDirty: isDirty ?? self.isDirty,
            actionResponse: actionResponse ?? self.actionResponse
        )
    }
    
    enum SelectFormCulturalPracticeActionResponse {
        case selectElementSelectedOnListActionResponse
        case closeSelectFormWithSaveActionResponse
        case closeSelectFormWithoutSaveAction
        case setSelectFormIsDirtyActionResponse
        case checkIfFormIsDirtyActionResponse
    }
}


