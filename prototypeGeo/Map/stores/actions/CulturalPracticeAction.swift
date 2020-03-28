//
//  CulturalPracticeAction.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct CulturalPracticeAction {
    struct SelectedFieldOnListAction: Action {
        let fieldType: FieldType
    }

    struct AddCulturalPracticeInputMultiSelectContainer: Action {
        let index: Int
    }
}
