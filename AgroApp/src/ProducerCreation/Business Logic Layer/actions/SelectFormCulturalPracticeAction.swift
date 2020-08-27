//
//  CulturalPracticeFormAction.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct SelectFormCulturalPracticeAction {
    struct SelectElementSelectedOnListAction: Action {
        let section: Section<ElementUIData>
        let field: Field
    }

    struct CloseSelectFormWithSaveAction: Action {
        let indexSelected: Int
    }

    struct CloseSelectFormWithoutSaveAction: Action { }
    
    struct CheckIfFormIsDirtyAction: Action {
        let indexSelected: Int
    }
}
