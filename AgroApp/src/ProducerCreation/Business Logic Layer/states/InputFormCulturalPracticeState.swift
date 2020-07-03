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
    var fieldType: FieldType?
    var inputFormSubAction: InputFormSubAction?
    var isDirty: Bool?
}

enum InputFormSubAction {
    case test
}
