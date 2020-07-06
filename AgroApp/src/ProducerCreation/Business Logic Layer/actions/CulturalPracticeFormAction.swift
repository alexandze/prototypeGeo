//
//  CulturalPracticeAction.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct CulturalPracticeFormAction {
    struct SelectedFieldOnListAction: Action {
        let fieldType: FieldType
    }

    struct AddCulturalPracticeInputMultiSelectContainer: Action {}

    struct UpdateCulturalPracticeElementAction: Action {
        let culturalPracticeElementProtocol: CulturalPracticeElementProtocol
    }

    struct SelectElementOnListAction: Action {
        let indexPath: IndexPath
    }
}
