//
//  InputFormCulturalPracticeAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-04.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct InputFormCulturalPracticeAction {
    struct InputElementSelectedOnListAction: Action {
        let culturalPracticeInputElement: CulturalPracticeInputElement
        let field: Field
        let subAction: InputFormCulturalPracticeSubAction
    }

    struct CloseInputFormWithSaveAction: Action {
        let inputValue: String
        let subAction: InputFormCulturalPracticeSubAction = .closeWithSave
    }

    struct CloseInputFormWithoutSaveAction: Action { }
}
