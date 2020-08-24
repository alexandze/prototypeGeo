//
//  InputFormCulturalPracticeState.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct InputFormCulturalPracticeState: Equatable {
    static func == (lhs: InputFormCulturalPracticeState, rhs: InputFormCulturalPracticeState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var sectionInputElement: Section<ElementUIData>?
    var field: Field?
    var inputFormCulturalPracticeActionResponse: InputFormCulturalPracticeActionResponse?
    var isDirty: Bool?
    
    enum InputFormCulturalPracticeActionResponse {
        case inputElementSelectedOnListActionResponse
        case closeInputFormWithSaveActionResponse
        case noAction
        case closeInputFormWithoutSaveActionResponse
    }

    func changeValue(
        sectionInputElement: Section<ElementUIData>? = nil,
        field: Field? = nil,
        inputFormCulturalPracticeActionResponse: InputFormCulturalPracticeActionResponse? = nil,
        isDirty: Bool? = nil
    ) -> InputFormCulturalPracticeState {
        InputFormCulturalPracticeState(
            uuidState: UUID().uuidString,
            sectionInputElement: sectionInputElement ?? self.sectionInputElement,
            field: field ?? self.field,
            inputFormCulturalPracticeActionResponse: inputFormCulturalPracticeActionResponse ?? self.inputFormCulturalPracticeActionResponse,
            isDirty: isDirty ?? self.isDirty
        )
    }
}


