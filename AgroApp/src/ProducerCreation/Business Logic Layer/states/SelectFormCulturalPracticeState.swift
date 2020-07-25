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
    var culturalPraticeElement: CulturalPracticeElementProtocol?
    var field: Field?
    var selectFormCulturalParacticeSubAction: SelectFormCulturalPracticeSubAction?
    var isDirty: Bool?

    func changeValue(
        culturalPraticeElement: CulturalPracticeElementProtocol? = nil,
        field: Field? = nil,
        isDirty: Bool? = nil,
        culturalPracticeSubAction: SelectFormCulturalPracticeSubAction? = nil
    ) -> SelectFormCulturalPracticeState {
        SelectFormCulturalPracticeState(
            uuidState: UUID().uuidString,
            culturalPraticeElement: culturalPraticeElement ?? self.culturalPraticeElement,
            field: field ?? self.field,
            selectFormCulturalParacticeSubAction: culturalPracticeSubAction ?? self.selectFormCulturalParacticeSubAction,
            isDirty: isDirty ?? self.isDirty
        )
    }
}

enum SelectFormCulturalPracticeSubAction {
    case newDataForm
    case printAlert
    case formIsDirty
    case closeWithSave
    case closeWithoutSave
}
