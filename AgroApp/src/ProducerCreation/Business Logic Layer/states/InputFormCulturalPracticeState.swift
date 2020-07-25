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
    var inputElement: CulturalPracticeInputElement?
    var field: Field?
    var inputFormSubAction: InputFormCulturalPracticeSubAction?
    var isDirty: Bool?

    func changeValue(
        inputElement: CulturalPracticeInputElement? = nil,
        field: Field? = nil,
        inputFormSubAction: InputFormCulturalPracticeSubAction? = nil,
        isDirty: Bool? = nil
    ) -> InputFormCulturalPracticeState {
        InputFormCulturalPracticeState(
            uuidState: UUID().uuidString,
            inputElement: inputElement ?? self.inputElement,
            field: field ?? self.field,
            inputFormSubAction: inputFormSubAction ?? self.inputFormSubAction,
            isDirty: isDirty ?? self.isDirty
        )
    }
}

enum InputFormCulturalPracticeSubAction {
    case newFormData
    case closeWithSave
    case noAction
    case closeWithoutSave
}
