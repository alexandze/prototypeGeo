//
//  CulturalPracticeFormState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
struct CulturalPracticeFormState: Equatable {
    static func == (lhs: CulturalPracticeFormState, rhs: CulturalPracticeFormState) -> Bool {
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
    ) -> CulturalPracticeFormState {
        CulturalPracticeFormState(
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
