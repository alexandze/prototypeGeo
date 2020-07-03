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
    var fieldType: FieldType?
    var culturalPracticeSubAction: CulturalPracticeFormSubAction?
    var isDirty: Bool?

    func changeValue(
        culturalPraticeElement: CulturalPracticeElementProtocol? = nil,
        fieldType: FieldType? = nil,
        isDirty: Bool? = nil,
        culturalPracticeSubAction: CulturalPracticeFormSubAction? = nil
    ) -> SelectFormCulturalPracticeState {
        SelectFormCulturalPracticeState(
            uuidState: UUID().uuidString,
            culturalPraticeElement: culturalPraticeElement ?? self.culturalPraticeElement,
            fieldType: fieldType ?? self.fieldType,
            culturalPracticeSubAction: culturalPracticeSubAction ?? self.culturalPracticeSubAction,
            isDirty: isDirty ?? self.isDirty
        )
    }
}

enum CulturalPracticeFormSubAction {
    case newDataForm
    case printAlert
    case formIsDirty
    case closeWithSave
    case closeWithoutSave
}
