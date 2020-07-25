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
    struct SelectElementSelectedOnList: Action {
        let culturalPracticeElement: CulturalPracticeElementProtocol
        let field: Field
        let subAction: SelectFormCulturalPracticeSubAction
    }

    struct ClosePresentedViewControllerAction: Action {
        let indexSelected: Int
    }

    struct ClosePresentedViewControllerWithSaveAction: Action {
        let indexSelected: Int
    }

    struct ClosePresentedViewControllerWithoutSaveAction: Action { }

    struct SetFormIsDirtyAction: Action {
        let isDirty: Bool
    }
}
