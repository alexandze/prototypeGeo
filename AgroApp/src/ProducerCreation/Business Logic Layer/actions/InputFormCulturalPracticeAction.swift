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
        let sectionInputElement: Section<ElementUIData>
        let field: Field
    }
    
    struct CloseInputFormWithSaveAction: Action {
        let inputValue: String
    }

    struct CloseInputFormWithoutSaveAction: Action { }
    
    struct CheckIfInputValueIsValidAction: Action {
        let inputValue: String
    }
    
    struct CheckIfFormIsValidAndDirtyForPrintAlertAction: Action { }
}
